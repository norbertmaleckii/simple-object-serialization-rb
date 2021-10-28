# frozen_string_literal: true

module PlainSerializer
  class ObjectSerializer
    include Callee

    param :serializer_class
    param :object
    param :options

    def call
      {
        data: data,
        meta: meta
      }
    end

    private

    def data
      serializer_class.call(object, options)
    end

    def meta
      Hash(options[:meta])
    end
  end
end
