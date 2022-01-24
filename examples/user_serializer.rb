# frozen_string_literal: true

require 'date'
require 'kaminari'

class UserSerializer < SimpleObjectSerialization::Entity
  object_alias :user

  define_attribute :index, if: proc { options[:index] } do
    options[:index]
  end

  define_attribute :id
  define_attribute :email
  define_attribute :login, if: proc { !email.nil? } do
    login
  end

  define_attribute :created_at
  define_attribute :updated_at, if: proc { !email.nil? } do
    user.created_at
  end

  private

  def email
    user.email
  end

  def login
    user.email.split('@').first
  end
end

class UserWithoutDSLSerializer < SimpleObjectSerialization::Entity
  # rubocop:disable Metrics/AbcSize
  def call
    hash = {}
    hash[:index] = options[:index] if options[:index]
    hash[:id] = user.id
    hash[:email] = user.email
    hash[:login] = login unless email.nil?
    hash[:created_at] = user.created_at
    hash[:updated_at] = user.created_at unless email.nil?
    hash
  end
  # rubocop:enable Metrics/AbcSize

  private

  def email
    user.email
  end

  def login
    user.email.split('@').first
  end

  def user
    object
  end
end

User = Struct.new(:id, :email, :created_at)
