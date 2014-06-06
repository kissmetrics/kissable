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

    def identity(cookies)
      @cookies = cookies

      abset.each do |i, val|
        return abid_object.new(i, test_name) if val > seed
      end
    end

    def cookies
      @cookies ||= {}
    end

    private

    def cookie_exists?
      cookie && cookie != ''
    end

    def abid_object
      @abid_object ||= Struct.new(:id, :name)
    end

    def sha
      @sha ||= Digest::SHA1.hexdigest(test_name).to_i(16)
    end

    def seed
      @seed ||= (sha ^ ab_cookie_value) % 100
    end

    def abset
      @abset if @abset

      sum = 0
      @abset = Hash.new
      @abset = groups.zip(ratios.map! { |i| sum += i })
    end

    # Simply reads/sets the cookie used for control
    def ab_cookie_value
      if cookie_exists?
        # TODO: Add a logger
        # Rails.logger.info("Returning User: #{abid}")
        abid = cookie.to_i
      else
        abid = cookie_value
        set_cookie(abid)
      end

      abid
    end

    def cookie
      cookies[cookie_name.to_s]
    end

    def set_cookie(cookie_value)
      cookies[cookie_name] = cookie_data
    end

    def cookie_data
      { :value => cookie_value.to_s,
        :path => '/',
        :expires => Time.now + 52 * 604800
        # :domain => '.kissmetrics.com'
      }
    end

    def cookie_name
      'abid'
    end

    def cookie_value
      rand(10000000)
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
      raise ArgumentError, "ABHelper ratios sum to #{total} not 100" unless total == 100
    end
  end
end
