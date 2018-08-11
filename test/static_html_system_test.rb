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
    visit_and_assert_translations posts_path, %r"^More[^%]*$", %r"^Load[^%]*$"
  end

  def test_custom_translations
    I18n.backend.store_translations(:en, moar: {
      more: "MMMO %{results_name}",
      loading: "LLLO %{results_name}",
    })
    visit_and_assert_translations posts_path, %r"MMMO posts", %r"LLLO posts"
  end

  def test_results_name_custom_i18n
    I18n.backend.store_translations(:en,
      moar: { more: "%{results_name}" },
      activerecord: { models: { post: { one: "post", other: "peest" } } },
    )
    visit_and_assert_translations posts_path, %r"peest", %r"."
  end

  def test_results_name_custom_inflection
    # HACK trigger internal caching / method generation reliant on
    # inflection, otherwise subsequent tests may fail even when original
    # inflection is restored
    polymorphic_path(Post)

    I18n.backend.store_translations(:en, moar: { more: "%{results_name}" })
    ActiveSupport::Inflector.inflections.irregular "post", "posten"
    visit_and_assert_translations posts_path, %r"posten", %r"."
    ActiveSupport::Inflector.inflections.irregular "post", "posts"
  end

  private

  def visit_and_assert_translations(path, more_pattern, loading_pattern)
    visit path
    link = find "#link"
    assert_match more_pattern, link.text
    assert_match loading_pattern, link["data-disable-with"]
  end

end
