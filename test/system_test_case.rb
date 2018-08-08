require "test_helper"
require "moar"

AMBIENT_PARAMS = { "foo" => "foooo", "bar" => { "baz" => "baaaaz" } }

PostsController.class_eval do
  def index
    @posts = moar(Post).order(:id)

    render layout: true, inline: <<~ERB
      <p id="ambient_params">#{params.to_unsafe_h.slice(*AMBIENT_PARAMS.keys)}</p>
      <p id="page"><%= @moar.page %></p>
      <p id="ids"><%= @posts.map(&:id).join(",") %>,</p>

      <%= link_to_more @posts, "#ids", id: "link", class: "someclass" %>
      <%= link_to_more @posts, "#ids" %><!-- try without html_options -->
    ERB
  end
end

class SystemTestCase < ActionDispatch::SystemTestCase

  fixtures "posts"

  protected

  def iterate_and_verify(model_class, javascript)
    from_remote = false
    visit polymorphic_path(model_class, AMBIENT_PARAMS)
    (1..Moar::Controller::PAGE_SIZES.length + 1).each do |page|
      link = verify_page_contents(model_class, page, javascript)
      if from_remote
        visit current_url # refresh
        link = verify_page_contents(model_class, page, javascript) # verify refresh
      end
      break unless link
      from_remote = javascript && link["data-remote"] == "true"
      link.click
    end
  end

  def verify_page_contents(model_class, page, accumulative)
    # tested in tests/context_test.rb, so assume behavior is correct
    context = Moar::Context.new(Moar::Controller::PAGE_SIZES, page, accumulative)

    verify_ambient_params
    verify_ids(model_class, context)
    verify_link(model_class, context)
  end

  def verify_ambient_params
    assert_equal AMBIENT_PARAMS.to_s, find("#ambient_params").text
  end

  def verify_ids(model_class, context)
    expected = model_class.order(:id).offset(context.offset).limit(context.limit).
      pluck(:id).join(",") + ","
    assert_equal expected, find("#ids").text
  end

  def verify_link(model_class, context)
    selector = "a#link.someclass"
    if model_class.count >= context.offset + context.limit
      link = find selector
      data_remote = context.page < context.increments.length
      assert_equal data_remote.to_s, link["data-remote"]
      assert_equal "Loading...", link["data-disable-with"]
      assert_equal "#ids", link["data-paginates"]
      assert_equal "page_acc", link["data-accumulation-param"]
      assert_equal current_path, URI(link["href"]).path
      link
    else
      refute_selector selector
      nil
    end
  end

end
