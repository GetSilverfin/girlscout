# frozen_string_literal: true

module GirlScout
  class List < GirlScout::Object
    include Enumerable

    attr_accessor :item_class
    alias size count
    alias length count

    def initialize(attr, item_class)
      super(attr)
      @item_class = item_class
    end

    def items
      @items ||= begin
        args = ['Embedded'].concat(item_class.resource_path.split("/").tap { |ary| ary.delete("") })

        (@attributes.dig(*args) || []).map do |attr|
          @item_class.new(attr)
        end
      end
    end

    def [](index)
      items[index]
    end

    def each(&block)
      items.each(&block)
    end
  end
end
