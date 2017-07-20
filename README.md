# PeriodOverlap

This gem helps your validate against overlapping time periods, allowing you to define the `error` messages yourself.

PeriodOverlap is a simple validation helper for your Rails app by utilizing a plain old Ruby object.

## Community / Readings:
Famous gem by robinbortlik:
[validates_overlap](https://github.com/robinbortlik/validates_overlap)

Good reading about date range overlapping using the database:
[makandracards.com - test if two date ranges overlap](https://makandracards.com/makandra/984-test-if-two-date-ranges-overlap-in-ruby-or-rails)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'period_overlap', :git => 'https://github.com/simonneutert/period_overlap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install period_overlap

## Usage

**Assuming you have a running rails app, with a model (in this case: _periods_) that defines a period via a _starting_ and an _ending_ __date__, e.g.**

```ruby
Period.new
=> #<Period:0x007ff5a2133860
 id: nil,
 starting: nil,
 ending: nil,
 info: nil,
 distribution_general: nil,
 distribution_direct: nil,
 estate_id: nil,
 created_at: nil,
 updated_at: nil>
```

**Add a custom validation to your period model.**

``` ruby
  class Period < ApplicationRecord
    # ...
    validate :has_overlaps
    attr_reader :overlaps
    # ...
  end
```

**Then call the object like in the snippet below, passing in the following params:**
1. `model` - send in your model by using `self`
2. `model_starting` - the model's attribute describing the starting date of the period as Symbol/String
3. `model_ending` - the model's attribute describing the ending date of the period as Symbol/String
4. `starting` - form data of the period starting attribute (see above)
5. `ending` - form data of the period ending attribute (see above)
6. `additional_query` - **(optional)** add a query without leading dot

```ruby
def has_overlaps
  # the variable set for "attr_reader" and the one you store
  # the return of "PeriodOverlap::Validator" in must match!
  @overlaps = PeriodOverlap::Validator.new(
    model = self, # always "self"!
    model_starting_attr = :starting,
    model_ending_attr = :ending,
    starting_attr = starting,
    ending_attr = ending
    additional_query = "foo = #{bar_id}" # use SQL Syntax for this optional where() query, be careful :wink:
  ).overlap? do
    errors.add(:starting, 'Your personalized error message for the attribute "starting".')
    errors.add(:ending, 'Your personalized error message for the attribute "ending".')
  end
end
```

**Optional step:** have the overlapping periods in your views

``` erb
<% period.overlaps.each do |overlap| %>
  # your code here
<% end %>
```

## Performance

It is recommended to add a combined index for the two corresponding attributes that represent the starting and the ending of the period.

`rails generate migration AddIndexToPeriods`

and

```
class Addindextoanswers < ActiveRecord::Migration[5.1]
  def change
    add_index :periods,[:starting, :ending]
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/simonneutert/period_overlap.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
