# frozen_string_literal: true

module PlainSerializer
  class CollectionSerializer
    include Callee

    param :serializer_class
    param :collection
    param :options

    def call
      {
        data: data,
        meta: meta
      }
    end

    private

    def data
      collection.map.with_index do |object, index|
        serializer_class.call(object, options.merge(index: index))
      end
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
