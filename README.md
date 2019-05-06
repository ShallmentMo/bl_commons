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

### BaiduTongji

* add `baidu_tongji.rb` to your initializers

  ```ruby
  BlCommons::BaiduTongji.username = "your username"
  BlCommons::BaiduTongji.password = "********"
  BlCommons::BaiduTongji.token = "***********"
  ```

* using `BlCommons::BaiduTongji::BaiduTongjiClient.get(site_id, api_method, params)` to request data from baidu tongji. [ref](https://tongji.baidu.com/api/manual/Chapter1/getData.html)

* e.g.:

  request:
```ruby
BlCommons::BaiduTongji::BaiduTongjiClient.get(site_id, "overview/getTimeTrendRpt", max_results: 0)
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
