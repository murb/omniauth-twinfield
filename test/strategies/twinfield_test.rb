# frozen_string_literal: true

require "test_helper"

module OmniAuth
  module Strategies
    class TwinfieldTest < Minitest::Test
      def test_that_it_is_a_strategy
        assert ::OmniAuth::Strategies::Twinfield.new(nil).is_a?(OmniAuth::Strategies::OAuth2)
      end
    end
  end
end
