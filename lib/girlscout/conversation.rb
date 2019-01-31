# frozen_string_literal: true

module GirlScout
  class Conversation < GirlScout::Object
    endpoint '/conversations'

    class << self
      def all(options = {})
        # TO DO: put this in Resource
        params = options.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
        params = "?#{params}" unless params == ""

        List.new(resource[params].get, Conversation)
      end

      def find(id)
        Conversation.new(resource["/#{id}"].get)
      end

      def create(attributes)
        attributes = attributes.as_json if attributes.respond_to?(:as_json)
        attributes['reload'] ||= true
        Conversation.new(resource.post(payload: attributes)['item'])
      end

      def create_note(id, attributes)
        attributes = attributes.as_json if attributes.respond_to?(:as_json)
        Thread.new(resource["/#{id}/notes"].post(payload: attributes))
      end
    end

    def customer
      @customer ||= Customer.new(self['createdBy'] || {})
    end

    def threads
      @threads ||= (self['threads'] || []).map { |attr| Thread.new(attr) }
    end

    def mailbox
      @mailbox ||= Mailbox.new(self['mailbox'] || {})
    end

    def as_json
      # TODO: Test
      json = super.dup
      json['customer'] = customer.as_json if key?('customer')
      json['threads'] = threads.map(&:as_json) if key?('threads')
      json['mailbox'] = mailbox.as_json if key?('mailbox')
      json
    end
  end
end
