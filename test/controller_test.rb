require "test_helper"
require "moar"

PostsController.class_eval do
  def index
    @posts = moar(Post).order(:id)

    render inline: <<~ERB
      <p id="page"><%= @moar.page %></p>
      <p id="accumulative"><%= @moar.accumulative %></p>
      <p id="limit"><%= @moar.limit %></p>
      <p id="count"><%= @posts.count %></p>
      <p id="ids"><%= @posts.map(&:id).join(",") %></p>
    ERB
  end
end

class ControllerTest < ActionDispatch::IntegrationTest

  fixtures "posts"

  def test_incremental_pagination
    iterate_pages_and_check(accumulative: false)
  end

  def test_accumulative_pagination
    iterate_pages_and_check(accumulative: true)
  end

  def test_pagination_with_no_records
    Post.destroy_all
    iterate_pages_and_check
  end

  private

  def moar_increments
    Moar::Controller::PAGE_SIZES
  end

  def iterate_pages_and_check(beyond: 1, accumulative: false)
    page_ids = []

    (1..moar_increments.length + beyond).each do |page|
      get posts_path, params: {
        page: (page unless page == 1),
        page_acc: accumulative.presence,
      }.compact

      assert_equal page.to_s, css_select("#page").text
      assert_equal accumulative.to_s, css_select("#accumulative").text
      assert_operator css_select("#count").text.to_i, :<=, css_select("#limit").text.to_i

      page_ids << css_select("#ids").text.presence
    end

    total_limit = moar_increments.sum * (1 + beyond)
    expected_ids = Post.order(:id).limit(total_limit).pluck(:id).join(",")
    actual_ids = (accumulative ? page_ids.last(1 + beyond) : page_ids).compact.join(",")
    assert_equal expected_ids, actual_ids
  end

end
