module Moar
  module Controller
    extend ActiveSupport::Concern

    # Paginates +relation+, returning an +ActiveRecord::Relation+ with
    # an offset and limit applied.  The offset and limit are calculated
    # based on pagination increments (as specified by either
    # {Moar::Controller::ClassMethods#moar_increments} or
    # {Moar::Config#increments}), and the current page number (parsed
    # from the request query param specified by
    # {Moar::Config#page_param}).
    #
    # If the current page number is less than or equal to the number of
    # pagination increments, the limit will be the pagination increment
    # corresponding to the current page number.  Otherwise, the limit
    # will be the sum of all increments.  For example, if the pagination
    # increments are +[15,20,25]+, the offsets and limits are:
    #
    # * page 1: offset 0, limit 15
    # * page 2: offset 15, limit 20
    # * page 3: offset 35, limit 25
    # * page 4: offset 60, limit 60
    # * page 5: offset 120, limit 60
    # * page 6: offset 180, limit 60
    # * ...
    #
    # @param relation [ActiveRecord::Relation]
    # @return [ActiveRecord::Relation]
    def moar(relation)
      @moar = Moar::Context.new(
        _moar_increments || Moar.config.increments,
        params[Moar.config.page_param].to_i,
        params[Moar.config.accumulation_param].present?
      )

      relation.offset(@moar.offset).limit(@moar.limit)
    end

    included do
      # @!visibility private
      class_attribute :_moar_increments
    end

    module ClassMethods
      # Sets controller-specific pagination increments to be used by
      # {Moar::Controller#moar}.  Pagination increments set this way
      # take precedence over {Moar::Config#increments}.
      #
      # @param increments [Array<Integer>]
      def moar_increments(increments)
        self._moar_increments = increments
      end
    end
  end
end
