module Moar
  module Helper

    def link_to_more(records, target, html_options = {})
      unless records.length < @moar.limit
        params = request.query_parameters.except(Moar.config.accumulation_param.to_s)
        params[Moar.config.page_param.to_s] = @moar.page + 1

        options = { controller: controller_path, action: action_name, params: params }

        i18n_options = {
          results_name: records.first.model_name.human(
            count: 2, default: records.first.model_name.human.pluralize(I18n.locale)
          ).downcase,
        }

        html_options = html_options.dup
        html_options["data-remote"] = @moar.page < @moar.increments.length
        html_options["data-type"] = "html"
        html_options["data-disable-with"] = I18n.t(:"moar.loading", i18n_options)
        html_options["data-paginates"] = target
        html_options["data-accumulation-param"] = Moar.config.accumulation_param.to_s

        link_to I18n.t(:"moar.more", i18n_options), options, html_options
      end
    end

  end
end
