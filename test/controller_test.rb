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

  def test_incremental_page_sizes
    max_page_size = moar_increments.sum

    each_set_size do |set_size|
      page_sizes = get_page_sizes(set_size)

      (0...page_sizes.length).each do |i|
        expected = moar_increments[i] || max_page_size
        assert_operator page_sizes[i], (i < page_sizes.length - 1 ? :== : :<=), expected
      end

      assert_equal set_size, page_sizes.sum
    end
  end

  def test_accumulative_page_sizes
    each_set_size do |set_size|
      page_sizes = get_page_sizes(set_size, accumulative: true)

      (0...page_sizes.length).each do |i|
        expected = [moar_increments.take(i + 1).sum, set_size].min
        assert_operator page_sizes[i], (i < page_sizes.length - 1 ? :== : :<=), expected
      end

      assert_operator page_sizes.length, :>=, (set_size.zero? ? 0 : moar_increments.length)
      assert_equal set_size, page_sizes.drop(moar_increments.length - 1).sum
    end
  end

  private

  def moar_increments
    Moar::Controller::PAGE_SIZES
  end

  def each_set_size
    set_sizes = (0..moar_increments.length).map{|n| moar_increments.take(n).sum }.
      flat_map{|set_size| [set_size, set_size + 1] } + [Post.count]

    assert_operator set_sizes.max, :<=, Post.count # sanity check

    set_sizes.each{|set_size| yield set_size }
  end

  def get_page_sizes(set_size, accumulative: false)
    max_id = Post.order(:id).limit(set_size).pluck(:id).last || -1
    page_sizes = []

    while page_sizes.last != 0
      get posts_path, params: {
        max_id: max_id,
        page: (page_sizes.length + 1 unless page_sizes.empty?),
        page_acc: accumulative.presence,
      }.compact

      page_sizes << css_select("main").text.to_i
    end

    page_sizes[0...-1]
  end

end
