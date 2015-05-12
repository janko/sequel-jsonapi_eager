require "test_helper"

class PluginTest < Minitest::Test
  include Minitest::Hooks

  def around
    DB.transaction(rollback: :always) { yield }
  end

  def setup
    @user     = User.create
    @quiz     = @user.add_quiz({})
    @question = @quiz.add_question({})
    @post     = @user.add_post({})
  end

  def test_model
    user = User.jsonapi_eager("quizzes.questions,posts").all.first
    assert_user(user)
  end

  def test_dataset
    user = User.dataset.jsonapi_eager("quizzes.questions,posts").all.first
    assert_user(user)
  end

  def test_instance
    user = @user.jsonapi_eager("quizzes.questions,posts")
    assert_user(user)
  end

  def test_passing_array
    user = User.jsonapi_eager(["quizzes.questions", "posts"]).all.first
    assert_user(user)
  end

  private

  def assert_user(user)
    assert_equal [@quiz],     user.associations[:quizzes]
    assert_equal [@question], user.quizzes[0].associations[:questions]
    assert_equal [@post],     user.associations[:posts]
  end
end
