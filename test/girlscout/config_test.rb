# frozen_string_literal: true

require 'support'

module GirlScout
  class ConfigTest < GirlScoutTest
    def setup
      # don't setup the keys!
    end

    def test_oauth_token
      assert_raises OAuth2::Error do
        Config.oauth_token
      end
    end

    def test_api_prefix
      assert Config.api_prefix == GirlScout::DEFAULT_API_PREFIX,
             'should defaults to defined constant'
    end

    def test_reset!
      Config.client_id = 'asdf'
      Config.client_secret = 'ghjk'
      Config.api_prefix = 'zxcv'
      Config.reset!

      assert Config.instance_eval("@client_id") != 'asdf', 'should reset client_id'
      assert Config.instance_eval("@client_secret") != 'ghjk', 'should reset client_secret'
      assert Config.instance_eval("@oauth_client").nil?, 'should reset oauth_client'
      assert Config.instance_eval("@access_token").nil?, 'should reset access_token'
      assert Config.api_prefix != 'zxcv', 'should resets api_prefix'
    end
  end
end
