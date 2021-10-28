# frozen_string_literal: true

require 'active_support/json'
require 'callee'
require 'dry/initializer'

require_relative 'plain_serializer/version'
require_relative 'plain_serializer/attribute'
require_relative 'plain_serializer/attributes'
require_relative 'plain_serializer/collection_serializer'
require_relative 'plain_serializer/object_serializer'
require_relative 'plain_serializer/entity'

module PlainSerializer
end
