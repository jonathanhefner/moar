require "test_helper"
require "moar"

AMBIENT_PARAMS = { "foo" => "foooo", "bar" => { "baz" => "baaaaz" } }

ApplicationController.class_eval do
  def index(model_class)
    @results = moar(model_class).order(:id)

    render layout: true, inline: <<~ERB
      <p id="ambient_params">#{params.to_unsafe_h.slice(*AMBIENT_PARAMS.keys)}</p>
      <p id="page"><%= @moar.page %></p>
      <% if @results.empty? %>
        <p id="empty">,</p>
      <% else %>
        <p id="ids"><%= @results.map(&:id).join(",") %>,</p>
      <% end %>

      <%= link_to_more @results, "#ids", id: "link", class: "someclass" %>
      <%= link_to_more @results, "#ids" %><!-- try without html_options -->
      <%= link_to_more @results, "#eyedees", id: "broken" %>
    ERB
  end
end

PostsController.class_eval do
  def index
    super(Post)
  end
end

Namespaced::ThingsController.class_eval do
  def index
    super(Namespaced::Thing)
  end
end

class SystemTestCase < ActionDispatch::SystemTestCase

  def setup
    # HACK trigger I18n initialization, otherwise translation stored
    # before initialization via `I18n.backend.store_translations` will
    # be overwritten
    I18n.t(:"moar.more")
  end

  def teardown
    Moar.config = Moar::Config.new
    I18n.reload!
    PostsController.moar_increments nil
  end

  protected

  def iterate_and_verify(model_class, increments: Moar.config.increments, javascript: false)
    from_remote = false
    visit polymorphic_path(model_class, AMBIENT_PARAMS)
    (1..increments.length + 1).each do |page_number|
      # tested in tests/context_test.rb, so assume behavior is correct
      context = Moar::Context.new(increments, page_number, javascript)

      link = verify_page_contents(model_class, context)
      if from_remote
        assert_empty page.driver.browser.manage.logs.get(:browser)
        visit current_url # refresh
        link = verify_page_contents(model_class, context) # verify refresh
      end
      break unless link
      from_remote = javascript && link["data-remote"] == "true"
      link.click
    end
  end

  def verify_page_contents(model_class, context)
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
    assert_equal expected, find("#ids, #empty").text
  end

  def verify_link(model_class, context)
    selector = "a#link.someclass"
    if model_class.count >= context.offset + context.limit
      link = find selector
      assert_equal "#ids", link["data-paginates"]
      if context.page < context.increments.length
        assert_equal Moar.config.accumulation_param.to_s, link["data-accumulation-param"]
        assert_equal "true", link["data-remote"]
        refute_nil link["data-disable-with"]
      else
        assert_nil link["data-remote"]
        assert_nil link["data-disable-with"]
      end
      assert_equal current_path, URI(link["href"]).path
      assert_match %r"\b#{Moar.config.page_param}=", URI(link["href"]).query
      link
    else
      refute_selector selector
      nil
    end
  end

end
