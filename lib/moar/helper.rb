module Moar
  module Helper

    def link_to_more(records, target, html_options = {})
      unless records.length < @moar.limit
        params = request.query_parameters.except("page_acc")
        params["page"] = @moar.page + 1

        options = { controller: controller_path, action: action_name, params: params }

        html_options = html_options.dup
        html_options["data-remote"] = @moar.page < @moar.increments.length
        html_options["data-type"] = "html"
        html_options["data-disable-with"] = "Loading..."
        html_options["data-paginates"] = target
        html_options["data-accumulation-param"] = "page_acc"

        link_to "More", options, html_options
      end
    end

  end
end
