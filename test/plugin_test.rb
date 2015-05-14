require "test_helper"
require "pry"

class PluginTest < Minitest::Test
  include Minitest::Hooks

  def around
    DB.transaction(rollback: :always) { yield }
  end

  def setup
    @supervisor = Supervisor.create
    @user       = @supervisor.add_user({})
    @quiz       = @user.add_quiz({})
    @question   = @quiz.add_question({})
    @post       = @user.add_post({})
    @building   = Building.create
    @apartment  = @building.add_apartment({}).tap { |a| @user.update(apartment: a) }
  end

  def test_model
    user = User.jsonapi_eager(include_param).all.first
    assert_user(user)
  end

  def test_dataset
    user = User.dataset.jsonapi_eager(include_param).all.first
    assert_user(user)
  end

  def test_instance
    user = @user.jsonapi_eager(include_param)
    assert_user(user)
  end

  def test_passing_array
    user = User.jsonapi_eager(include_param.split(",")).all.first
    assert_user(user)
  end

  def test_undefined_association
    assert_raises(Sequel::UndefinedAssociation) { @user.jsonapi_eager("foo") }
    assert_raises(Sequel::UndefinedAssociation) { User.jsonapi_eager("foo") }
    assert_raises(Sequel::UndefinedAssociation) { User.dataset.jsonapi_eager("foo") }
  end

  def test_symbol_creation
    User.jsonapi_eager("foo.bar,baz") rescue nil
    assert_empty Symbol.all_symbols.grep(/foo|bar|baz/)

    User.dataset.jsonapi_eager("foo.bar,baz") rescue nil
    assert_empty Symbol.all_symbols.grep(/foo|bar|baz/)

    @user.jsonapi_eager("foo.bar,baz") rescue nil
    assert_empty Symbol.all_symbols.grep(/foo|bar|baz/)
  end

  private

  def assert_user(user)
    assert_equal [@quiz],     user.associations[:quizzes]
    assert_equal [@question], user.quizzes[0].associations[:questions]
    assert_equal [@post],     user.associations[:posts]
    assert_equal @supervisor, user.associations[:supervisor]
    assert_equal @apartment,  user.associations[:apartment]
    assert_equal @building,   user.apartment.associations[:building]
  end

  def include_param
    "quizzes.questions,posts,supervisor,apartment.building"
  end
end
