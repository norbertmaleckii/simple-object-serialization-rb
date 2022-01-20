# frozen_string_literal: true

module SimpleObjectSerialization
  class Entity
    attr_reader :object, :options

    def initialize(object, options = {})
      @object = object
      @options = options
    end

    def self.call(*params, **options, &block)
      new(*params, **options).call(&block)
    end

    def self.object_alias(name)
      define_method(name) do
        object
      end
    end

    def self.define_attribute(name, options = {}, &block)
      attribute = Attribute.new(name, options, block)

      attributes.push(attribute)
    end

    def self.attributes
      @attributes ||= Attributes.new
    end

    def self.serialize_collection(collection, options = {})
      hash = CollectionSerializer.call(self, collection, options)

      JSON.generate(hash)
    end

    def self.serialize(object, options = {})
      hash = ObjectSerializer.call(self, object, options)

      JSON.generate(hash)
    end

    def call
      self.class.attributes.hash_for(self)
    end
  end
end
