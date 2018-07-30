require "test_helper"
require "moar"

PostsController.class_eval do
  def index
    @posts = moar(Post).where("id <= ?", params[:max_id])

    render inline: "<main><%= @posts.count %></main>"
  end
end

class ControllerTest < ActionDispatch::IntegrationTest

  fixtures "posts"

  def test_page_sizes
    moar_increments = Moar::Controller::PAGE_SIZES
    max_page_size = moar_increments.sum

    set_sizes = (0..moar_increments.length).map{|n| moar_increments.take(n).sum }.
      flat_map{|set_size| [set_size, set_size + 1] } + [Post.count]

    set_sizes.each do |set_size|
      page_sizes = get_page_sizes(set_size)

      page_sizes[0...-1].zip(moar_increments).each do |actual, expected|
        assert_equal(expected || max_page_size, actual)
      end

      max_last_size = moar_increments[page_sizes.length - 1] || max_page_size
      assert_operator page_sizes.last, :<=, max_last_size

      assert_equal set_size, page_sizes.sum
    end
  end

  private

  def get_page_sizes(set_size)
    assert_operator set_size, :<=, Post.count # sanity check
    max_id = Post.order(:id).limit(set_size).pluck(:id).last || -1
    page_sizes = []

    while page_sizes.last != 0
      get posts_path, params: {
        max_id: max_id,
        page: (page_sizes.length + 1 unless page_sizes.empty?),
      }.compact

      page_sizes << css_select("main").text.to_i
    end
    page_sizes.pop unless page_sizes.length == 1

    page_sizes
  end

end
