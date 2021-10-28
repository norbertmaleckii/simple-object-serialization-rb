# frozen_string_literal: true

module PlainSerializer
  class Attributes
    extend Dry::Initializer

    param :attributes, default: proc { [] }

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
