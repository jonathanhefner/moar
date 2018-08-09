module Moar
  module Controller

    def moar(relation)
      @moar = Moar::Context.new(
        Moar.config.increments,
        params[:page].to_i,
        params[:page_acc].present?
      )

      relation.offset(@moar.offset).limit(@moar.limit)
    end

  end
end
