# Kissable

[![Build Status](https://travis-ci.org/kissmetrics/kissable.png?branch=master)](https://travis-ci.org/kissmetrics/kissable) [![Gem Version](https://badge.fury.io/kissmetrics/kissable.png)](http://badge.fury.io/kissmetrics/kissable) [![Coverage Status](https://coveralls.io/repos/kissmetrics/kissable/badge.png?branch=master)](https://coveralls.io/r/kissmetrics/kissable?branch=master)

Kissable is a gem used to create, track, and store information for A/B tests in user cookies.

## Installation

Add this line to your application's Gemfile:

    gem 'kissable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kissable

## Usage

Kissable helps you run A/B tests by breaking up your users into test groups (e.g. Original vs. Variant). Name your test, list your test groups, and the ratio at which people should be distributed to each group. Kissable does the assignment pseudo-randomly.

For anonymous users cookies must be enabled. Cookies are used to assign a user to a group and keep him there. For logged in users a unique identifier (e.g. login) is used instead for the same purpose.

You instantiate the object with these items.

```ruby
Kissable::AB.new(testname, groups, ratio)
```

* `testname` (required) This should be unique per test. It both passes the property to KM tracking as well as helps generate unique user groups for the test.
* `groups` (optional) This is used to name the groups used in the test. It will accept up to four group names. Defaults to `%w{Original Variant}`.
* `ratio` (optional) The ratio of how you want users sent to the specified groups. It expects all weightings to equal 100. It defaults to an even weight for all groups in the test.
* Store the result from `group` and use it to set up a switch in the relevant controller.

```ruby
# home_controller.rb
def index
  @ab_test = Kissable::AB.new('top-navigation test')
  @users_ab_group = @ab_test.group(cookies)

  case @users_ab_group
  when 'Original'
    render 'index'
  else
    render 'index-variant'
  end
end
```

* Inside of the individual template files, you can add KISSmetrics tracking code by passing the user's group into the `#tracking_script` instance method.

```ruby
  ab_test = Kissable::AB.new('top-navigation test')
  users_ab_group = ab_test.group(cookies)
  ab_test.tracking_script(users_ab_group)
```

* For logged in users, you can use some unique identifier instead.

```ruby
  ab_test = Kissable::AB.new('top-navigation test')
  users_ab_group = ab_test.group(email)
  # Add your custom tracking code here.
```

### Rails

```ruby
ab = Kissable::AB.new('some cool test')
ab.group(cookies)
```

### Sinatra

Sinatra handles cookies much differently than Rails. Sinatra stores the cookies which were sent in the request object in `request` and the cookies which will be sent back to the user in the `response` object. In order to make this as easy as possible, Kissable uses a Sinatra cookie adapter. This adapter needs to be instantiated with the `request` and `response` objects, then passed to `group`.

```ruby
sca = Kissable::SinatraCookieAdapter.new(request, response)

ab = Kissable::AB.new('some cool test')
users_ab_group = ab.group(sca)
```

### Configuration

Kissable allows you some potential configurations.

```ruby
Kissable.configure do |config|
  config.logger = Logger.new(STDOUT)
  config.domain = '.kissmetrics.com'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
