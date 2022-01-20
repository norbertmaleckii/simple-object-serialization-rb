# frozen_string_literal: true

require 'date'
require 'kaminari'

RSpec.describe SimpleObjectSerialization::Entity do
  describe '.define_attribute' do
    subject(:user_serializer_class) do
      Class.new(described_class) do
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
    end

    let(:user_class) do
      Struct.new(:id, :email, :created_at)
    end

    let(:users) do
      Kaminari.paginate_array(Array.new(4) { user.dup }).page(2).per(2)
    end

    context 'with user email' do
      let(:user) do
        user_class.new(1, 'user@example.com', DateTime.new(2020, 1, 1))
      end

      it '.call' do
        expect(user_serializer_class.call(user)).to eq(
          id: 1,
          email: 'user@example.com',
          login: 'user',
          created_at: DateTime.new(2020, 1, 1),
          updated_at: DateTime.new(2020, 1, 1)
        )
      end

      it '.serialize' do
        expected_json = JSON.generate(
          {
            'data' => {
              'id' => 1,
              'email' => 'user@example.com',
              'login' => 'user',
              'created_at' => '2020-01-01T00:00:00+00:00',
              'updated_at' => '2020-01-01T00:00:00+00:00'
            },
            'meta' => {}
          }
        )

        expect(user_serializer_class.serialize(user)).to eq(expected_json)
      end

      it '.serialize_collection' do
        expected_json = JSON.generate(
          {
            'data' => [
              {
                'index' => 0,
                'id' => 1,
                'email' => 'user@example.com',
                'login' => 'user',
                'created_at' => '2020-01-01T00:00:00+00:00',
                'updated_at' => '2020-01-01T00:00:00+00:00'
              },
              {
                'index' => 1,
                'id' => 1,
                'email' => 'user@example.com',
                'login' => 'user',
                'created_at' => '2020-01-01T00:00:00+00:00',
                'updated_at' => '2020-01-01T00:00:00+00:00'
              }
            ],
            'meta' => {
              'total_count' => 4,
              'total_pages' => 2,
              'per_page' => 2,
              'prev_page' => 1,
              'current_page' => 2,
              'next_page' => nil
            }
          }
        )

        expect(user_serializer_class.serialize_collection(users)).to eq(expected_json)
      end
    end

    context 'without user email' do
      let(:user) do
        user_class.new(1, nil, DateTime.new(2020, 1, 1))
      end

      it '.call' do
        expect(user_serializer_class.call(user)).to eq(
          id: 1,
          email: nil,
          created_at: DateTime.new(2020, 1, 1)
        )
      end

      it '.serialize' do
        expected_json = JSON.generate(
          { 'data' => { 'id' => 1, 'email' => nil, 'created_at' => '2020-01-01T00:00:00+00:00' }, 'meta' => {} }
        )

        expect(user_serializer_class.serialize(user)).to eq(expected_json)
      end

      it '.serialize_collection' do
        expected_json = JSON.generate(
          {
            'data' => [
              {
                'index' => 0,
                'id' => 1,
                'email' => nil,
                'created_at' => '2020-01-01T00:00:00+00:00'
              },
              {
                'index' => 1,
                'id' => 1,
                'email' => nil,
                'created_at' => '2020-01-01T00:00:00+00:00'
              }
            ],
            'meta' => {
              'total_count' => 4,
              'total_pages' => 2,
              'per_page' => 2,
              'prev_page' => 1,
              'current_page' => 2,
              'next_page' => nil
            }
          }
        )

        expect(user_serializer_class.serialize_collection(users)).to eq(expected_json)
      end
    end
  end
end
