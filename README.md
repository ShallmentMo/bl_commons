# BlCommons
BL Common Utilities

## Usage

### ResourcesController and ResourceConcern

* add route your `routes.rb`, so you can behave like a server

```
# routes.rb
mount BlCommons::Engine => '/'
```

* add `bl_commons.rb` to your initializers

```
# frozen_string_literal: true

BlCommons::BlResources.register(:web, { host: Rails.application.secrets.web_host })

```

* include concer in one of your model and specify your attributs, so you can behave like client

```
include BlCommons::RemoteResourceConcern

bl_remote_resource(attributes: %i[name avatar], node: :web)
```

or

```
include BlCommons::SyncResourceConcern

bl_sync_resource(attributes: %i[name avatar], nodes: [:b2c])
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'bl_commons'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bl_commons
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
