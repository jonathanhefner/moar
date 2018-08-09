module Moar
  module Controller

    def moar(relation)
      @moar = Moar::Context.new(
        Moar.config.increments,
        params[Moar.config.page_param].to_i,
        params[Moar.config.accumulation_param].present?
      )

      relation.offset(@moar.offset).limit(@moar.limit)
    end

  end
end
