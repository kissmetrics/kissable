module Kissable
  class SinatraCookieAdapter
    attr_reader :request, :response

    def initialize(request, response)
      @request = request
      @response = response
    end

    def [](cookie_name)
      request.cookies[cookie_name]
    end

    def []=(cookie_name, cookie_data)
      response.set_cookie(cookie_name, cookie_data)
    end
  end
end