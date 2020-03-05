# Pb

Utility for Google **P**rotocol **B**uffers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'the_pb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install the_pb

## Usage

You can use `Pb` to generate protobuf objects.

```ruby
[1] pry(main)> Pb.to_timestamp("2019-03-01T15:30:00")
=> <Google::Protobuf::Timestamp: seconds: 1551421800, nanos: 0>

[2] pry(main)> Pb.to_strval("Hello")
=> <Google::Protobuf::StringValue: value: "Hello">
```

You can also use `Pb.to_proto` to generate nested objects.

```proto
message Account {
  int64 id = 1;
  google.protobuf.Timestamp registered_at = 2;
  Profile profile = 3;
}

message Profile {
  int64 id = 1;
}
```

```ruby
[1] pry(main)> Pb.to_proto(Account, { id: 1, registered_at: Time.new(2019, 3, 1), profile: { id: 2 })
=> <Account: id: 1, registered_at: <Google::Protobuf::Timestamp: seconds: 1551366000, nanos: 0>, profile: <Profile: id: 2>>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wantedly/the_pb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wantedly/the_pb/blob/master/CODE_OF_CONDUCT.md).
