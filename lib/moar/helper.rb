module Moar
  module Helper

    # Generates an anchor element that links to more paginated results.
    # If JavaScript is active, and the current page number is less than
    # the number of pagination increments (see {Moar::Config#increments}
    # or {Moar::Controller::ClassMethods#moar_increments}), the link
    # will use Ajax to fetch the results and inject them into the
    # element matching the CSS selector specified by +target+.
    # Otherwise, the link will behave normally and navigate to the next
    # page of results.
    #
    # The text of the link is determined via I18n using translation key
    # +:"moar.more"+.  A +results_name+ interpolation argument is
    # provided containing the humanized translated pluralized downcased
    # name of the relevant model.  For example, if the translation
    # string is <code>"Need more %{results_name}!"</code> and +results+
    # is an array of +CowBell+ models, the link text will be "Need more
    # cow bells!".
    #
    # This helper method accepts an +html_options+ Hash, and passes it
    # to Rails' +ActionView::Helpers::UrlHelper#link_to+.  See its
    # documentation for information about available options.
    #
    # If no more results are available, this helper method will return
    # nil so that no link is rendered.  Whether there are more results
    # is estimated by comparing +results.length+ with the limit applied
    # by {Moar::Controller#moar}.  This technique eliminates the need
    # for an extra database query, but can result in a false positive
    # (i.e. rendering a link to an empty page) when the actual last page
    # of results is also a full page.  This is deemed an acceptable
    # trade-off because with a large number of pages and a large total
    # number of results per page it is an unlikely occurrence, and
    # because an extra database query cannot entirely prevent a link to
    # an empty page, in the case where records are deleted before the
    # user can click through to the final page.
    #
    # @param results [ActiveRecord::Relation, Array<ActiveModel::Naming>]
    # @param target [String]
    # @param html_options [Hash]
    # @return [String, nil]
    # @raise [RuntimeError]
    #   if controller action did not invoke {Moar::Controller#moar}
    def link_to_more(results, target, html_options = {})
      raise "#{controller.class}##{action_name} did not invoke #moar" unless defined?(@moar)

      unless results.length < @moar.limit
        params = request.query_parameters.except(Moar.config.accumulation_param.to_s)
        params[Moar.config.page_param.to_s] = @moar.page + 1

        options = { controller: controller_path, action: action_name, params: params }

        i18n_options = {
          results_name: results.first.model_name.human(
            count: 2, default: results.first.model_name.human.pluralize(I18n.locale)
          ).downcase,
        }

        html_options = html_options.dup
        html_options["data-paginates"] = target
        if @moar.page < @moar.increments.length
          html_options["data-accumulation-param"] = Moar.config.accumulation_param.to_s
          html_options["data-remote"] = true
          html_options["data-type"] = "html"
          html_options["data-disable-with"] = I18n.t(:"moar.loading", i18n_options)
        end

        link_to I18n.t(:"moar.more", i18n_options), options, html_options
      end
    end

  end
end
