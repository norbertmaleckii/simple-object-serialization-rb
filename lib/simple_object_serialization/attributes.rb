# frozen_string_literal: true

module SimpleObjectSerialization
  class Attributes
    attr_reader :attributes

    def initialize
      @attributes = []
    end

    def push(attribute)
      attributes.push(attribute)
    end

    def hash_for(serializer)
      {}.tap do |hash|
        attributes.each do |attribute|
          next if attribute.skip_for?(serializer)

          hash[attribute.name] = attribute.value_for(serializer)
        end
      end
    end
  end
end
