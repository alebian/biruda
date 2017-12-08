# Biruda
[![Gem Version](https://badge.fury.io/rb/biruda.svg)](https://badge.fury.io/rb/biruda)
[![Dependency Status](https://gemnasium.com/badges/github.com/alebian/biruda.svg)](https://gemnasium.com/github.com/alebian/biruda)
[![Build Status](https://travis-ci.org/alebian/biruda.svg)](https://travis-ci.org/alebian/biruda)
[![Code Climate](https://codeclimate.com/github/alebian/biruda/badges/gpa.svg)](https://codeclimate.com/github/alebian/biruda)
[![Test Coverage](https://codeclimate.com/github/alebian/biruda/badges/coverage.svg)](https://codeclimate.com/github/alebian/biruda/coverage)

Biruda is a simple DSL to build HTML documents.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'biruda'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biruda

## Usage

```ruby
page = Biruda.create_html do
    head do
        title 'This is a Biruda HTML DSL test'
        script src: 'mypage.com/mysuper.js'
    end
    body do
        h1 'HEADING'
        p [
            'This is part of my ',
            -> { b 'paragraph' },
            ', amazing.'
        ]
    end
end

puts page
```

This will print:

```
<!DOCTYPE html>
<html>
    <head>
        <title>This is a Biruda HTML DSL test</title>
        <script src="mypage.com/mysuper.js" />
    </head>
    <body>
        <h1>HEADING</h1>
        <p>
            This is part of my <b>paragraph</b>, amazing.
        </p>
    </body>
</html>'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`rubocop -R lib spec --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request
