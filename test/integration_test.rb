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

      <%= link_to_more @posts %><!-- no html_options -->
      <%= link_to_more @posts, id: "link", class: "someclass" %>
    ERB
  end

  def new
    index
  end
end

class IntegrationTest < ActionDispatch::IntegrationTest

  fixtures "posts"

  def test_incremental_pagination
    iterate_pages_and_check(posts_path, accumulative: false)
  end

  def test_accumulative_pagination
    iterate_pages_and_check(posts_path, accumulative: true)
  end

  def test_pagination_with_no_records
    Post.destroy_all
    iterate_pages_and_check(posts_path)
  end

  def test_pagination_with_custom_action
    iterate_pages_and_check(new_post_path)
  end

  private

  def moar_increments
    Moar::Controller::PAGE_SIZES
  end

  def iterate_pages_and_check(path, beyond: 1, accumulative: false)
    app_params = { "foo" => "foooo", "bar" => { "baz" => "baaaaz" } }
    page_ids = []

    (1..moar_increments.length + beyond).each do |page|
      get path, params: app_params.merge(
        page: (page unless page == 1),
        page_acc: accumulative.presence,
      ).compact

      assert_equal page.to_s, css_select("#page").text
      assert_equal accumulative.to_s, css_select("#accumulative").text
      assert_operator css_select("#count").text.to_i, :<=, css_select("#limit").text.to_i
      page_ids << css_select("#ids").text.presence

      if css_select("#count").text == css_select("#limit").text
        link = css_select("a#link").first
        link_uri = URI(link["href"])
        link_params = Rack::Utils.parse_nested_query(link_uri.query)
        assert_includes link["class"], "someclass"
        assert_equal path, link_uri.path
        assert_equal (page + 1).to_s, link_params["page"]
        refute_includes link_params, "page_acc"
        assert_equal app_params, link_params.slice(*app_params.keys)
      else
        assert_empty css_select("#link")
      end
    end

    total_limit = moar_increments.sum * (1 + beyond)
    expected_ids = Post.order(:id).limit(total_limit).pluck(:id).join(",")
    actual_ids = (accumulative ? page_ids.last(1 + beyond) : page_ids).compact.join(",")
    assert_equal expected_ids, actual_ids
  end

end
