require_relative "system_test_case"

PostsController.class_eval do
  def new
    index
  end
end

class StaticHtmlSystemTest < SystemTestCase

  driven_by :rack_test

  def test_pagination
    iterate_and_verify(Post, false)
  end

  def test_pagination_with_no_records
    Post.delete_all
    iterate_and_verify(Post, false)
  end

  def test_pagination_with_different_config
    Moar.config.tap do |config|
      config.increments = [1, 2, 3]
      config.page_param = :p
      config.accumulation_param = :k
    end
    iterate_and_verify(Post, false)
  end

  def test_pagination_with_single_page_size
    Moar.config.increments = [5]
    iterate_and_verify(Post, false)
  end

  def test_pagination_with_custom_action
    visit new_post_path
    assert_equal new_post_path, URI(find("#link")["href"]).path
  end

end
