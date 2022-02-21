# frozen_string_literal: true

module SimpleObjectSerialization
  class ObjectSerializer
    attr_reader :serializer_class, :object, :options

    def initialize(serializer_class, object, options)
      @serializer_class = serializer_class
      @object = object
      @options = options
    end

    def self.call(*params, **options, &block)
      new(*params, **options).call(&block)
    end

    def call
      {
        data: data,
        errors: errors,
        messages: messages,
        meta: meta
      }
    end

    private

    def data
      serializer_class.call(object, options)
    end

    def errors
      Hash(options[:errors])
    end

    def messages
      Array(options[:messages])
    end

    def meta
      Hash(options[:meta])
    end
  end
end
