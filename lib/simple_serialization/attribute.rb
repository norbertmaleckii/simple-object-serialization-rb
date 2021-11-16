# frozen_string_literal: true

module SimpleSerialization
  class Attribute
    attr_reader :name, :options, :block

    def initialize(name, options, block)
      @name = name
      @options = options
      @block = block
    end

    def skip_for?(serializer)
      options[:if] ? !serializer.instance_eval(&options[:if]) : false
    end

    def value_for(serializer)
      block ? serializer.instance_eval(&block) : serializer.object.public_send(name)
    end
  end
end
