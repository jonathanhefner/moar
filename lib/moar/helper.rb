module Moar
  module Helper

    def link_to_more(records, html_options = {})
      unless records.length < @moar.limit
        params = request.query_parameters.except("page_acc")
        params["page"] = @moar.page + 1

        options = { controller: controller_path, action: action_name, params: params }

        link_to "More", options, html_options
      end
    end

  end
end
