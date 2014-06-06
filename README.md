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

Kissable enables you to conduct a/b tests contingent on users having cookies enabled. To conduct a test you need to have a name for a test and specify how many groups you want and the ratios of these groups.

You instantiate the object with these items.

```ruby
Kissable::AB.new(testname, groups, ratio)
```

* `testname` (required) This should be unique per test. It both passes the property to KM tracking as well as helps generate unique user groups for the test.
* `groups` (optional) This is used to name the groups used in the test. It will accept up to four group names. Defaults to `%w{Original Variant}`.
* `ratio` (optional) The ratio of how you want users sent to the specified groups. It expects all weightings to equal 100. It defaults to an even weight for all groups in the test.
* Store the result from `identity` and use it to set up a switch in the relevant controller.

```ruby
# home_controller.rb
def index
  @ab_test = Kissable::AB.new('top-navigation or side-navigation test')
  @users_identity = @ab_test.identity

  case @users_identity.id
  switch 'Original'
    render 'index'
  else
    render 'index-variant'
  end
end
```

* Inside of the individual template files, you can add KISSmetrics tracking code by passing the user's identity into the `Kissable.tracking_script` class method.

```ruby
  Kissable.tracking_script(@users_identity)
```

### Rails

```ruby
ab = Kissable::AB.new('some cool test')
ab.identity(cookies)
```

### Sinatra

Sinatra handles cookies much differently than Rails. Sinatra stores the cookies which were sent in the request object in `request` and the cookies which will be sent back to the user in the `response` object. In order to make this as easy as possible, Kissable uses a Sinatra cookie adapter. This adapter needs to be instantiated with the `request` and `response` objects, then passed to identity.

```ruby
sca = Kissable::SinatraCookieAdapter.new(request, response)

ab = Kissable::AB.new('some cool test')
ab.identity(sca)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
