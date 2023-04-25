require_relative "system_test_case"
require "selenium-webdriver"

class DynamicHtmlSystemTest < SystemTestCase

  driven_by :selenium_chrome_headless

  def test_pagination
    iterate_and_verify(Post, javascript: true)
  end

  def test_pagination_with_omitted_container
    Post.where.not(id: Post.limit(Moar.config.increments.first).pluck(:id)).delete_all
    iterate_and_verify(Post, javascript: true)
  end

  def test_pagination_with_invalid_target
    visit posts_path
    click_link "broken"
    error = nil
    Timeout.timeout(Capybara.default_max_wait_time) do # wait for Ajax
      error = page.driver.browser.logs.get(:browser)[0] until error
    end
    assert_match %r"#eyedees", error.message
  end

  def test_navigate_back_to_accumulated
    increments = [1, 1]
    PostsController.moar_increments increments

    visit posts_path

    increments.length.times do
      click_link "link"
      # Sleep to prevent Turbo Drive from causing flakey failures (possibly
      # related to restoration visits and the Turbo cache).
      sleep 0.5
    end

    go_back
    sleep 0.5

    verify_ids(Post, Moar::Context.new(increments, increments.length, true))
  end

end
