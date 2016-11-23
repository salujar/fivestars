require 'httparty'
require 'json'
require 'uri'

require_relative './exceptions'

module FiveStars
  module OAuth

    def user_verify_pin(opts={})
      url = URI.join(api_uri_root, @verify_pin_url).to_s
      body = {
        phone: @phone,
        pin:   @pin
      }.merge(opts)

      request_phone_token(url, body)
    end

    def user_auth(opts={})
      @phone_token = user_verify_pin   # set @phone_token

      url = URI.join(api_uri_root, @login_url).to_s
      body = {
        phone:       @phone,
        phone_token: @phone_token
      }.merge(opts)

      request_session_token(url, body)
    end

    def request_session_token(url, body)
      puts "\nFiveStars::Auth  POST-ing #{url} with params #{{ body: body.to_json, headers: headers }}\n"
      response = HTTParty.send(:post, url, body: body.to_json, headers: headers)

      if response.code != 202
        byebug;

        puts
        raise AuthError, JSON.parse(response.body)['error']
      end

      begin
        parsed_response = JSON.parse(response.body)

        token = nil
        if body.has_key?(:pin)
          token = @phone_token = parsed_response['phone_token']
        elsif body.has_key?(:phone_token)
          token = @session_token = parsed_response['session_token']
        else
          raise InvalidCredentialError "Invalid credentail payload, credentails was: #{body}"
        end
      rescue JSON::ParserError
        raise AuthError, "Client failed to get a session token, response was:  #{response.body}"
      end

      return token
    end
    alias_method :request_phone_token, :request_session_token

  end
end