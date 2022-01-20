# SimpleObjectSerialization

Serialization system for Ruby with awsesome features!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_object_serialization'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install serializer

## Usage

```ruby
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
```


```ruby
User = Struct.new(:id, :email, :created_at)

user = User.new(1, 'user@example.com', DateTime.new(2020, 1, 1))
users = Kaminari.paginate_array(Array.new(4) { user.dup }).page(2).per(2)

UserSerializer.call(user, meta: { current_time: Time.now })
#=> {:id=>1, :email=>"user@example.com", :login=>"user", :created_at=>Wed, 01 Jan 2020 00:00:00 +0000, :updated_at=>Wed, 01 Jan 2020 00:00:00 +0000}

UserSerializer.serialize(user, meta: { current_time: Time.now })
#=> "{\"data\":{\"id\":1,\"email\":\"user@example.com\",\"login\":\"user\",\"created_at\":\"2020-01-01T00:00:00+00:00\",\"updated_at\":\"2020-01-01T00:00:00+00:00\"},\"meta\":{\"current_time\":\"2021-10-28T18:44:07.044+02:00\"}}"

UserSerializer.serialize_collection(users, meta: { current_time: Time.now })
#=> "{\"data\":[{\"index\":0,\"id\":1,\"email\":\"user@example.com\",\"login\":\"user\",\"created_at\":\"2020-01-01T00:00:00+00:00\",\"updated_at\":\"2020-01-01T00:00:00+00:00\"},{\"index\":1,\"id\":1,\"email\":\"user@example.com\",\"login\":\"user\",\"created_at\":\"2020-01-01T00:00:00+00:00\",\"updated_at\":\"2020-01-01T00:00:00+00:00\"}],\"meta\":{\"current_time\":\"2021-10-28T18:44:22.140+02:00\",\"total_count\":4,\"total_pages\":2,\"per_page\":2,\"prev_page\":1,\"current_page\":2,\"next_page\":null}}"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/norbertmaleckii/simple-object-serialization-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/norbertmaleckii/simple-object-serialization-rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Serializer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/norbertmaleckii/simple-object-serialization-rb/blob/main/CODE_OF_CONDUCT.md).
