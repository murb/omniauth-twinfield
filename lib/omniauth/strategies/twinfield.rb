# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    # Twinfield OmniAuth Strategy; follows OmniAuth::Strategies::OAuth2's base strategy
    class Twinfield < OmniAuth::Strategies::OAuth2
      class InvalidToken < StandardError
      end

      args %i[client_id client_secret]

      option :client_id, nil
      option :client_secret, nil

      option :name, "twinfield"

      option :client_options, {
        site: "https://login.twinfield.com/auth/authentication/connect/",
        authorize_url: "authorize",
        token_url: "token",
        accesstokenvalidation_url: "accesstokenvalidation",
        userinfo_url: "userinfo"
      }

      option :authorize_params, {
        response_type: :code,
        nonce: SecureRandom.hex(24),
        scope: "openid twf.user twf.organisation twf.organisationUser offline_access"
      }

      option :token_params, {
        grant_type: "authorization_code"
      }

      def request_phase
        redirect client.auth_code.authorize_url({ redirect_uri: callback_url }.merge(authorize_params))
      end

      def uid
        raw_info["sub"]
      end

      def info
        raw_info
      end

      def refresh_token
        access_token.to_hash[:refresh_token]
      end

      def raw_info
        @raw_info ||= self.class.validate_token(access_token.token)
      end

      def build_access_token
        verifier = request.params["code"]

        data = {
          headers: authorization_header,
          code: verifier,
          redirect_uri: callback_url.split(/\?/)[0],
          grant_type: "authorization_code"
        }

        client.auth_code.get_token(verifier, data)
      end

      private

      def authorization_header
        {
          "Authorization" => "Basic #{Base64.encode64("#{options.client_id}:#{options.client_secret}").gsub("\n",
                                                                                                            "")}",
          "User-Agent" => "Twinfield OmniAuth"
        }
      end

      class << self
        # Can't do a JWT token validation in absence of verification keys
        def validate_token(token)
          uri = URI.parse("https://login.twinfield.com/auth/authentication/connect/accesstokenvalidation?token=#{token}")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Get.new(uri)
          http_response = http.request(request)

          response = JSON.parse(http_response.body)

          raise InvalidToken, response["Message"] if response["Message"]

          response
        end
      end
    end
  end
end
