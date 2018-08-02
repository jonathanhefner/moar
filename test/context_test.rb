require "test_helper"
require "moar"

class ContextTest < Minitest::Test

  def test_minimum_page_number
    (-2..0).each do |page|
      moar = Moar::Context.new([10], page, false)
      assert_equal 1, moar.page
    end
  end

  def test_incremental_limit
    each_scenario(accumulative: false) do |context|
      expected = context.increments[context.page - 1] || context.increments.sum
      assert_equal expected, context.limit
    end
  end

  def test_accumulative_limit
    each_scenario(accumulative: true) do |context|
      expected = context.increments.take(context.page).sum
      assert_equal expected, context.limit
    end
  end

  def test_incremental_offset
    each_scenario(accumulative: false) do |context|
      expected = context.increments.take(context.page - 1).sum *
        [context.page - context.increments.length, 1].max
      assert_equal expected, context.offset
    end
  end

  def test_accumulative_offset
    each_scenario(accumulative: true) do |context|
      expected = context.increments.take(context.page - 1).sum *
        [context.page - context.increments.length, 0].max
      assert_equal expected, context.offset
    end
  end

  private

  def each_scenario(accumulative: false)
    [[1], [2, 3], [1, 2, 3]].each do |increments|
      (1..increments.length + 3).each do |page|
        context = Moar::Context.new(increments, page, accumulative)
        assert_equal increments, context.increments
        assert_equal page, context.page
        assert_equal accumulative, context.accumulative
        yield context
      end
    end
  end

end
