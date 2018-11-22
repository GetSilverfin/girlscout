# frozen_string_literal: true

require 'json'

module GirlScout
  class Resource
    METHODS = %i[get put post patch delete].freeze

    def initialize(url: '')
      @url = url
    end

    def url
      @url
    end

    def [](path)
      Resource.new(url: "#{@url}#{path}")
    end

    METHODS.each do |method|
      define_method(method) do |payload: nil, query: nil|
        options = { method: method, headers: { 'Authorization' => "Bearer #{Config.oauth_token}",
                                               'Content-Type'  => 'application/json'} }
        if payload
          options[:body] = JSON.generate(payload)
          options[:headers] ||= {}
        end
        options[:query] = query if query

        request(options)
      end
    end

    def request(options = {})
      response = Excon.new(url).request(options)
      if response.status >= 400 && response.status < 600
        raise GirlScout::Error, (JSON.parse(response.body) rescue {})
      end

      JSON.parse(response.body) rescue {}
    end
  end
end
