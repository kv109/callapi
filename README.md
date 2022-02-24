# Callapi [![Gem Version](https://badge.fury.io/rb/callapi.svg)](http://badge.fury.io/rb/callapi) [![Code Climate](https://codeclimate.com/github/kv109/Callapi/badges/gpa.svg)](https://codeclimate.com/github/kv109/Callapi)


Easy API calls

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'callapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install callapi

## Usage

### Basics

##### 1 Configuration: Set your API host

```ruby
require 'callapi'

Callapi::Config.configure do |config|
  config.api_host = 'http://your.api.org/v2'
end
```

##### 2 Routes: set your calls

```ruby
Callapi::Routes.draw do
  get 'notes'       # This creates #get_notes_call method
  get 'notes/:id'   # This creates #get_notes_by_id_call method
  post 'notes'      # This creates #post_notes_call method
end
```

##### 3 Use your calls: #data and #body methods

```ruby
get_notes_call.data.each do |note|
  puts note['title']
end

# Raw response:
get_notes_call.body    #=> '[{"id":1,"title":"Jogging in park"},{"id":2,"title":"Pick-up posters from post-office"}]'

# Request with params:
post_notes_call(id: 1, title: "Swimming").data

# Request with params and headers:
post_notes_call(id: 1, title: "Swimming").add_headers('X-SECRET-TOKEN' => '783hdkfds349').data
```

### Routes

##### HTTP methods

```ruby
Callapi::Routes.draw do
  get 'results'     #=> #get_results_call
  post 'results'    #=> #post_results_call
  put 'results'     #=> #put_results_call
  patch 'results'   #=> #patch_results_call
  delete 'results'  #=> #delete_results_call
end
```

##### Params

```ruby
Callapi::Routes.draw do
  get 'users/:id'                 #=> #get_users_by_id_call(id: 109) | :id is required
  put 'users/:id'                 #=> #put_users_by_id_call(id: 109, name: 'Kacper', age: 467)
  put 'users/:id/posts/:post_id'  #=> #put_users_by_id_posts_by_post_id_call(id: 109, post_id: 209)
end
```

##### Namespaces

```ruby
Callapi::Routes.draw do
  get 'users'               #=> #get_users_call
  
  namespace 'users' do
    get ':id'               #=> #get_users_by_id_call(id: 109)
    delete ':id'            #=> #delete_users_by_id_call(id: 109)
  end
  
  namespace 'users/:id/posts' do
    get ':post_id'          #=> #get_users_by_id_posts_by_post_id_call(id: 109, post_id: 209)
  end
end
```

##### Options

```ruby
Callapi::Routes.draw do
  get 'users', parser: Callapi::Call::Parser::Json
end
```

## Parsers

##### Available parsers

Callapi provides following parsers:
- `Callapi::Call::Parser::Json`
- `Callapi::Call::Parser::Json::AsObject`
- `Callapi::Call::Parser::Plain`

Default is `Callapi::Call::Parser::Json`. 

`Callapi::Call::Parser::Json` - converts JSON to `Hash`. If the API response for `/notes/12` is 

```javascript
{ "id": 2, "title": "Pick-up posters from post-office" }
```

then with `#data` method we can convert this response to `Hash`:
```ruby
get_notes_by_id_call(id: 12).data['id']  #=> 2
```

`Callapi::Call::Parser::Json::AsObject` - converts JSON to an object called `DeepStruct` (very similar to [`OpenStruct`](http://www.ruby-doc.org/stdlib-2.0/libdoc/ostruct/rdoc/OpenStruct.html)):
```ruby
get_notes_by_id_call(id: 12).data.title  #=> "Pick-up posters from post-office"
```

`Callapi::Call::Parser::Plain` - does not parse at all:
```ruby
get_notes_by_id_call(id: 12).data  #=> '{ "id": 2, "title": "Pick-up posters from post-office" }'
```

##### Setting parsers

Default parser for all calls can be set in configuration:
```ruby
Callapi::Config.configure do |config|
  config.default_response_parser = Callapi::Call::Parser::Json::AsObject
end
```

Default parser for specific calls can be set in routes:
```ruby
Callapi::Routes.draw do
  get 'users', parser: Callapi::Call::Parser::Json::AsObject
  get 'version', parser: Callapi::Call::Parser::Plain
end
```

Parser can be also set for each call instance separately:
```ruby
get_notes_call.with_response_parser(Callapi::Call::Parser::Json::AsObject).data    #=> [#<DeepStruct id=1, title="Jogging in park">]
get_notes_call.with_response_parser(Callapi::Call::Parser::Plain).data             #=> "[{\n  \"id\": 1, \"title\": \"Jogging in park\"\n}]"

call = get_notes_call
call.with_response_parser(Callapi::Call::Parser::Json::AsObject).data  #=> [#<DeepStruct id=1, title="Jogging in park">]
call.reload # DO NOT FORGET TO CLEAR CACHE!
call.with_response_parser(Callapi::Call::Parser::Plain).data           #=> "[{\n  \"id\": 1, \"title\": \"Jogging in park\"\n}]"
```

## Configuration

##### Config options

- `api_host`
- `default_response_parser`
- `log_level`

```ruby
Callapi::Config.configure do |config|
  config.api_host = 'http://your.api.org/v2'

  # see Parsers section
  config.default_response_parser = Callapi::Call::Parser::Json::AsObject
  
  # :none is only possible option. turns off logs.
  config.log_level = :none
end
```

## TO DO

- Support HTTPS

## Contributing

1. Fork it ( https://github.com/[my-github-username]/callapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
