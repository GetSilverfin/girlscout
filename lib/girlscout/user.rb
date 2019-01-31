# frozen_string_literal: true

module GirlScout
  class User < GirlScout::Object
    endpoint '/users'

    class << self
     def all(options = {})
        # TODO: put this in Resource
        params = options.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
        params = "?#{params}" unless params == ""

        List.new(resource[params].get, User)
      end

      def find(id)
        User.new(resource["/#{id}"].get)
      end

      def me
        find('me')
      end
    end

    def as_json
      json = super
      json['type'] = 'user'
      json
    end
  end
end
