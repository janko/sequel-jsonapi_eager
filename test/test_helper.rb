require "minitest/autorun"
require "minitest/pride"
require "minitest/hooks"

require "sequel"

DB = Sequel.sqlite

DB.create_table(:users)     { primary_key :id }
DB.create_table(:quizzes)   { primary_key :id; Integer :user_id }
DB.create_table(:questions) { primary_key :id; Integer :quiz_id }
DB.create_table(:posts)     { primary_key :id; Integer :user_id }

Sequel::Model.plugin :jsonapi_eager

class User < Sequel::Model
  one_to_many :quizzes
  one_to_many :posts
end

class Quiz < Sequel::Model
  many_to_one :user
  one_to_many :questions
end

class Question < Sequel::Model
  many_to_one :quiz
end

class Post < Sequel::Model
  many_to_one :user
end
