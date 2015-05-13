require "minitest/autorun"
require "minitest/pride"
require "minitest/hooks"

require "sequel"

DB = Sequel.sqlite

DB.create_table(:users) do
  primary_key :id
  Integer :supervisor_id
  Integer :apartment_id
end

DB.create_table(:quizzes) do
  primary_key :id
  Integer :user_id
end

DB.create_table(:questions) do
  primary_key :id
  Integer :quiz_id
end

DB.create_table(:posts) do
  primary_key :id
  Integer :user_id
end

DB.create_table(:supervisors) do
  primary_key :id
end

DB.create_table(:apartments) do
  primary_key :id
  Integer :building_id
end

DB.create_table(:buildings) do
  primary_key :id
end

Sequel::Model.plugin :jsonapi_eager

class User < Sequel::Model
  one_to_many :quizzes
  one_to_many :posts
  many_to_one :apartment
  many_to_one :supervisor
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

class Supervisor < Sequel::Model
  one_to_many :users
end

class Building < Sequel::Model
  one_to_many :apartments
end

class Apartment < Sequel::Model
  one_to_one :user
  many_to_one :building
end
