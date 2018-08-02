module Moar
  class Context

    attr_reader :increments, :page, :accumulative, :offset, :limit

    def initialize(increments, page, accumulative)
      @increments = increments
      @page = [page, 1].max
      @accumulative = accumulative

      if @page <= @increments.length
        @limit = @increments[@page - 1]
        @offset = @increments.take(@page - 1).sum
        if @accumulative
          @limit += @offset
          @offset = 0
        end
      else
        @limit = @increments.sum
        @offset = @limit * (@page - @increments.length)
      end
    end

  end
end
