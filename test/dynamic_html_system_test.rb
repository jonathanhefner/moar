require_relative "system_test_case"
require "selenium-webdriver"

class DynamicHtmlSystemTest < SystemTestCase

  driven_by :selenium, using: :headless_chrome

  def test_pagination
    iterate_and_verify(Post, javascript: true)
  end

  def test_pagination_with_omitted_container
    Post.limit(Post.count - Moar.config.increments.first).delete_all
    iterate_and_verify(Post, javascript: true)
  end

  def test_pagination_with_invalid_target
    visit posts_path
    click_link "broken"
    error = nil
    Timeout.timeout(Capybara.default_max_wait_time) do # wait for Ajax
      error = page.driver.browser.manage.logs.get(:browser)[0] until error
    end
    assert_match %r"#eyedees", error.message
  end

end
