module Moar
  module Controller

    PAGE_SIZES = [12, 12, 24]

    def moar(relation)
      @moar = Moar::Context.new(
        PAGE_SIZES,
        params[:page].to_i,
        params[:page_acc].present?
      )

      relation.offset(@moar.offset).limit(@moar.limit)
    end

  end
end
