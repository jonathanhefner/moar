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

  def test_default_translations
    visit_and_assert_translations Post, %r"^More", %r"^Load"
  end

  def test_custom_translations
    I18n.backend.store_translations(:en, moar: {
      more: "MMMO",
      loading: "LLLO",
    })
    visit_and_assert_translations Post, %r"MMMO", %r"LLLO"
  end

  private

  def visit_and_assert_translations(model_class, more_pattern, loading_pattern)
    visit polymorphic_path(model_class)
    link = find "#link"
    assert_match more_pattern, link.text
    assert_match loading_pattern, link["data-disable-with"]
  end

end
