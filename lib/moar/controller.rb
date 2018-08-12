module Moar
  module Controller
    extend ActiveSupport::Concern

    def moar(relation)
      @moar = Moar::Context.new(
        _moar_increments || Moar.config.increments,
        params[Moar.config.page_param].to_i,
        params[Moar.config.accumulation_param].present?
      )

      relation.offset(@moar.offset).limit(@moar.limit)
    end

    included do
      class_attribute :_moar_increments
    end

    module ClassMethods
      def moar_increments(increments)
        self._moar_increments = increments
      end
    end
  end
end
