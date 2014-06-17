require 'digest/sha1'

module Kissable
  class AB
    MAX_GROUP_COUNT = 4

    attr_reader :groups, :ratios, :test_name

    def initialize(test_name, groups=nil, ratios=nil)
      @test_name = test_name

      @groups = groups
      @groups ||= %w{Original Variant}

      @ratios = ratios
      @ratios ||= [100.0 / @groups.length] * @groups.length

      validate_groups
      validate_ratios
    end

    def group(cookies)
      @cookies = cookies

      abset.each do |i, val|
        return i if val > seed
      end
    end

    def cookies
      @cookies ||= {}
    end

    def tracking_script(group)
      "<script>_kmq.push(['set', {'#{test_name}' : '#{group}'}]);</script>"
    end

    private

    def cookie_exists?
      cookie && cookie != ''
    end

    def sha
      @sha ||= Digest::SHA1.hexdigest(test_name).to_i(16)
    end

    def seed
      @seed ||= (sha ^ ab_cookie_value) % 100
    end

    def abset
      return @abset if @abset

      sum = 0
      @abset = {}
      @abset = groups.zip(ratios.map { |i| sum += i })
    end

    # Simply reads/sets the cookie used for control
    def ab_cookie_value
      if cookie_exists?
        abid = cookie.to_i
        Kissable.configuration.logger.info("Returning User: #{abid}")
      else
        abid = rand(10000000)
        set_cookie(abid)
      end

      abid
    end

    def cookie
      cookies[cookie_name.to_s]
    end

    def set_cookie(cookie_value)
      cookies[cookie_name] = cookie_data(cookie_value)
    end

    def cookie_data(cookie_value)
      default_values = {
        :value => cookie_value.to_s,
        :path => '/',
        :expires => Time.now + 52 * 604800
      }

      if Kissable.configuration.domain
        default_values.merge!(:domain => Kissable.configuration.domain)
      end

      default_values
    end

    def cookie_name
      'abid'
    end

    def validate_groups
      raise ArgumentError, 'A minimium of two groups are required' if groups.length < 2
      raise ArgumentError, "The max number of split groups is #{MAX_GROUP_COUNT}" if groups.length > MAX_GROUP_COUNT
    end

    def validate_ratios
      unless ratios.length == groups.length
        raise ArgumentError, 'Mismatch with groups and ratios'
      end
      total = ratios.inject(0) { |tot, rate| tot + rate.to_i }
      raise ArgumentError, "Kissable ratios sum to #{total} not 100" unless total == 100
    end
  end
end
