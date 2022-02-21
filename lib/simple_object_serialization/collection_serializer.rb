# frozen_string_literal: true

module SimpleObjectSerialization
  class CollectionSerializer
    attr_reader :serializer_class, :collection, :options

    def initialize(serializer_class, collection, options)
      @serializer_class = serializer_class
      @collection = collection
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
      collection.map.with_index do |object, index|
        serializer_class.call(object, options.merge(index: index))
      end
    end

    def errors
      Hash(options[:errors])
    end

    def messages
      Array(options[:messages])
    end

    def meta
      Hash(options[:meta]).tap do |hash|
        hash.merge!(pagination) if collection.respond_to?(:current_page)
      end
    end

    def pagination
      {
        total_count: collection.total_count,
        total_pages: collection.total_pages,
        per_page: collection.limit_value,
        prev_page: collection.prev_page,
        current_page: collection.current_page,
        next_page: collection.next_page
      }
    end
  end
end
