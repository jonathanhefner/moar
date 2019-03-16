require "test_helper"
require "moar"

class LinkToMoreTest < ActionView::TestCase

  # Manually include the helper module, because although the railtie
  # indiomatically loads the Moar::Helper module into ActionView::Base,
  # ActionView::TestCase does not descend from ActionView::Base
  include Moar::Helper

  def test_works_with_array
    array = moar(Post).to_a
    link_to_more(array, "#id") # does not raise
  end

  def test_does_not_load_relation
    relation = moar(Post)
    refute relation.loaded? # sanity check
    link_to_more(relation, "#id")
    refute relation.loaded?
  end

  def test_does_not_load_first_record
    relation = moar(Post)
    link_to_more(relation, "#id")
    assert Post.any? # sanity check
    Post.delete_all
    assert_nil relation.first
  end

  private

  # include Moar::Controller for `moar` method and `@moar` variable
  include Moar::Controller

  def request # mock for helper
    ActionDispatch::TestRequest.create
  end

  def controller_path # mock for helper
    "posts"
  end

end
