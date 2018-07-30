module Moar
  module Controller

    PAGE_SIZES = [12, 12, 24]

    def moar(relation)
      page = [params[:page].to_i, 1].max
      limit = PAGE_SIZES[page - 1] || PAGE_SIZES.sum
      offset = PAGE_SIZES.take(page - 1).sum * [page - PAGE_SIZES.length, 1].max

      relation.offset(offset).limit(limit)
    end

  end
end
