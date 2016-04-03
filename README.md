# mojang-rb
[![Gem Version](https://badge.fury.io/rb/mojang.svg)](https://badge.fury.io/rb/mojang)
[![License](https://img.shields.io/:license-mit-blue.svg)]()

A Ruby wrapper for the Mojang and Minecraft web APIs.

## Installation
### RubyGems

```shell
$ gem install mojang
```

### Bundler
Add this line to the application's Gemfile:

```ruby
gem('mojang')
```

Then execute:

```shell
$ bundle
```

## Usage
```ruby
require 'mojang'

# Get status information
Mojang.status

# Check if a user has paid
Mojang.has_paid?('Notch')

# And get some information on them
uuid = Mojang.userid('Notch')
Mojang.name_history(uuid)
Mojang.username(uuid)
```
