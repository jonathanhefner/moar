require_relative "system_test_case"
require "selenium-webdriver"

class DynamicHtmlSystemTest < SystemTestCase

  driven_by :selenium, using: :headless_chrome

  def test_pagination
    iterate_and_verify(Post, true)
  end

end
