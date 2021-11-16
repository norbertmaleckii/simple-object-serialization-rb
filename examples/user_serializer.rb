# frozen_string_literal: true

require 'date'
require 'kaminari'

class UserSerializer < SimpleSerialization::Entity
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

User = Struct.new(:id, :email, :created_at)
