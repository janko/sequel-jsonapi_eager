# Sequel::Plugins::JsonapiEager

*DEPRECATION NOTICE: This gem is deprecated in favor of the
`tactical_eager_loading` Sequel plugin. It solves all of the eager loading
automatically, and it also reuses reciprocal associations which eliminates
DoSing. And it's general so it can be also used outside of JSON APIs.*

This [Sequel](http://sequel.jeremyevans.net/) plugin enables you to dynamically
eager load associations of objects you're exposing for your JSON API.

## Motivation

The [JSON-API](http://jsonapi.org/) specification introduces the ability for
clients to choose which associations they want to include in the response:

```http
GET /users?include=quizzes.questions,posts
```

You as an author of the API want to eager load those associations, to avoid
N+1 queries. However, Sequel has a slighly different API for eager loading
associations:

```rb
User.eager(:quizzes => :questions).eager(:posts)
```

This plugin translates the JSON-API `include` format into Sequel.

## Usage

```ruby
gem 'sequel-jsonapi_eager'
```

This plugin exposes the `jsonapi_eager` method to your Sequel objects, to which
you can pass in the `include` query parameter.

```ruby
User.plugin :jsonapi_eager

users = User.jsonapi_eager("quizzes.questions,posts")
# translates into `User.eager(:quizzes => :questions).eager(:posts)`

users.all
# SELECT * FROM `users`
# SELECT * FROM `quizzes` WHERE (`quizzes`.`user_id` IN (3, 54, 5))
# SELECT * FROM `questions` WHERE (`questions`.`quiz_id` IN (2, 17, 19, 43))
# SELECT * FROM `posts` WHERE (`posts`.`user_id` IN (3, 54, 5))
```

You can also use this method in the dataset:

```ruby
User.active.jsonapi_eager("quizzes.questions,posts")
```

What this plugin also gives you, which was the non-trivial part of the plugin,
is the ability to eager load associations on model *instances*.

```ruby
user = User[user_id]
user.jsonapi_eager("quizzes.questions,posts")
```

You need this when exposing single resources in your API, because you need to
determine what to eager load at serialization time, at which point you only
have the instance. Moreover, Sequel removes the eager loading when you fetch
single records, so the following doesn't work:

```ruby
user = User.eager(:quizzes => :questions)[user_id]
user # Doesn't contain the eager loading anymore
user.quizzes.map(&:questions) # N+1 query
```

This plugins helps you make very flexible APIs, while still keeping the
performance tip-top.

## License

[MIT](/LICENSE.txt)
