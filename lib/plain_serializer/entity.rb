# frozen_string_literal: true

module PlainSerializer
  class Entity
    include Callee

    param :object
    param :options, default: proc { {} }

    def self.object_alias(name)
      define_method(name) do
        object
      end
    end

    def self.define_attribute(name, options = {}, &block)
      attribute = Attribute.new(
        name: name,
        options: options,
        block: block
      )

      attributes.push(attribute)
    end

    def self.attributes
      @attributes ||= Attributes.new
    end

    def self.serialize_collection(collection, options = {})
      hash = CollectionSerializer.call(self, collection, options)

      ActiveSupport::JSON.encode(hash)
    end

    def self.serialize(object, options = {})
      hash = ObjectSerializer.call(self, object, options)

      ActiveSupport::JSON.encode(hash)
    end

    def call
      self.class.attributes.hash_for(self)
    end
  end
end
