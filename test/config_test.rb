require "test_helper"
require "moar"

class ConfigTest < Minitest::Test

  DEFAULT_FULL_PAGE_SIZE = 60 # highly divisible, many factors

  def teardown
    Moar.config = Moar::Config.new
  end

  def test_config_global
    assert_instance_of Moar::Config, Moar.config
  end

  def test_increments_accessor
    Moar.config.increments = [1]
    assert_equal [1], Moar.config.increments
  end

  def test_increments_default
    assert_equal DEFAULT_FULL_PAGE_SIZE, Moar.config.increments.sum
  end

end
