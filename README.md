# moar [![Build Status](https://travis-ci.org/jonathanhefner/moar.svg?branch=master)](https://travis-ci.org/jonathanhefner/moar)

More-style pagination for Rails.  As an example, consider the following
story:

* There are 175 posts in the database.
* User visits the posts index page; the first 10 posts are listed.
* User clicks a "More posts" link; the next 20 posts are appended to the
  list (30 total) without refreshing the page.
* User clicks the "More posts" link again; the next 30 posts are
  appended to the list (60 total) without refreshing the page.
* User clicks the "More posts" link again; the browser navigates to a
  new page listing the next 60 posts.
* User clicks a "More posts" link; the browser navigates to a new page
  listing the final 55 posts.  No "More posts" link is rendered.
* At any point the user can manually refresh the page, and the same set
  of posts will be shown.  Likewise, the page can navigated away from
  and back to, or bookmarked and returned to later, and the same set of
  posts will be shown.  (Assuming the database remains unchanged.)
* If JavaScript is disabled, the first and second "More posts" links
  will simply navigate to a new page listing only the posts that would
  have been fetched via Ajax.

With *moar*, this story can be realized using the following code:

```ruby
## app/controllers/posts_controller.rb

class PostsController < ApplicationController
  # Step 1 (optional): set controller-specific pagination increments
  moar_increments [10, 20, 30]

  def index
    # Step 2: apply pagination increments
    @posts = moar(Post).order(:created_at)
  end
end
```

```html+erb
<!-- app/views/posts/index.html.erb -->

<h1>Posts</h1>
<ul id="list-of-posts">
<% @posts.each do |post| %>
  <li><%= link_to post.title, post %></li>
<% end %>
</ul>

<!-- Step 3: render pagination link -->
<%= link_to_more @posts, "#list-of-posts" %>
```

A few things to note:

* No special code is required to perform the fetch and render of
  incremental paginated results via Ajax.
* The maximum number of results per page (60, in this example) is the
  sum of all pagination increments (10 + 20 + 30).
* The `link_to_more` helper automatically infers the link text ("More
  posts") from the paginated results.  This can be configured; see the
  [Configuration](#configuration) section below.
* The second argument of the `link_to_more` helper is a CSS selector
  which points to the paginated results container element.  Results
  fetched via Ajax are appended directly to that element, so the
  selector must point to the rendered results' immediate container.  For
  example, if the paginated results are rendered as rows in a table, the
  selector should point to the `<tbody>` element rather than the
  `<table>` element.
* The `link_to_more` helper will render nothing when there are no more
  paginated results &mdash; no `if` required.

For complete usage details, see the documentation for
[`moar_increments`](https://www.rubydoc.info/gems/moar/Moar/Controller/ClassMethods:moar_increments),
[`moar`](https://www.rubydoc.info/gems/moar/Moar/Controller:moar), and
[`link_to_more`](https://www.rubydoc.info/gems/moar/Moar/Helper:link_to_more).


## Configuration

The *moar* install generator will create two configuration files in your
project directory: "config/initializers/moar.rb" and
"config/locales/moar.en.yml".

"config/initializers/moar.rb" can be edited to change the default
pagination increments used when `moar_increments` is not called, and to
change the query param used to indicate page number.

"config/locales/moar.en.yml" can be edited to change the link text
rendered by `link_to_more`.  Translations listed in this file are
provided a `results_name` interpolation argument which contains the
humanized translated pluralized downcased name of the relevant model.
For example, if the translation string is `"Need more %{results_name}!"`
and the paginated results consist of `CowBell` models, the rendered text
will be "Need more cow bells!".

## Installation

Add this line to your application's Gemfile:

```ruby
gem "moar"
```

Then execute:

```bash
$ bundle install
```

And finally, run the installation generator:

```bash
$ rails generate moar:install
```


## Contributing

Run `rake test` to run the tests.


## License

[MIT License](MIT-LICENSE)
