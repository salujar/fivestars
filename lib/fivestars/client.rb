require_relative 'api/users'
require_relative './oauth'

module FiveStars
  class Client 

    include FiveStars::API::Users::Auth
    include FiveStars::API::Users::Memberships
    include FiveStars::OAuth

    attr_reader :session_token

    def initialize(*args)
      # @base_url = 'http://www.nerfstars.com/api/unified/'

      opts = args.last.is_a?(Hash) ? args.last : { }

      opts.delete_if { |k, v| v.nil? }
      opts = default_fivestars_configuration.merge(opts)
      
      @session_token  = opts[:session_token]

      @uri_scheme     = opts[:uri_scheme]
      @uri_host       = opts[:uri_host]
      @uri_base_path  = opts[:uri_base_path]
      @auth_site      = opts[:auth_site]
      @verify_pin_url = opts[:verify_pin_url]
      @login_url      = opts[:login_url]
      @phone          = opts[:phone]
      @pin            = opts[:pin]
      @phone_token    = opts[:phone_token]
    end

    # defaults to staging env.
    def default_fivestars_configuration
      {
        uri_scheme:     'http',
        uri_host:       'www.nerfstars.com',
        uri_base_path:  '/api/unified/',
        auth_site:      'https://www.nerfstars.com',
        verify_pin_url: 'users/auth/verify_pin',
        login_url:      'users/auth/login',
        phone:          nil,
        pin:            nil,
        phone_token:    nil
      }
    end
    
    def credentials
      { session_token: @session_token }
    end

    def api_uri_root
      # ex: www.nerfstars.com/api/unified
      # uri.scheme, uri.host, uri.path, uri.query, uri.fragment
      URI.parse('').tap do |uri|
        uri.scheme = @uri_scheme
        uri.host   = @uri_host.gsub(/https?:\/\//, '')      # removes http:// or https:// if any
        uri.path   = @uri_base_path
      end.to_s
    end

    def post(path, params={})
      request(:post, path, params)
    end

    def get(path, params={})
      request(:get, path, params)
    end

    def put(path, params={})
      request(:put, path, params)
    end

    def delete(path, params={})
      request(:delete, path, params)
    end


    private

    def request(method, path, params)
      params ||= {}
      uri = full_url(path)

      puts "\nFiveStars::Client   #{method.upcase}-ing #{uri} with params #{params.merge(headers: headers, cookies: cookies)}\n\n"
      response = HTTParty.send(method, uri, params.merge(headers: headers, cookies: cookies))
      # puts (response.nil?) ? response : parse(response)
    end

    def full_url(path)
      URI.join(api_uri_root, path).to_s
    end

    def headers
      {
        "Connection"    => 'keep-alive',
        "Accept"        => 'application/json'
      }
    end

    def cookies
      { "session_token" => @session_token }.delete_if { |k, v| v.nil? }  # remove in case @session_token is nil
    end

    def parse(response)
      JSON.parse(response.body)
    end

  end
end