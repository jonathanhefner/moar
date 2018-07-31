module Moar
  module Controller

    PAGE_SIZES = [12, 12, 24]

    def moar(relation)
      page = [params[:page].to_i, 1].max

      limit = PAGE_SIZES[page - 1] || PAGE_SIZES.sum
      offset = PAGE_SIZES.take(page - 1).sum * [page - PAGE_SIZES.length, 1].max

      if params[:page_acc].present?
        limit = [limit + offset, PAGE_SIZES.sum].min
        offset = page <= PAGE_SIZES.length ? 0 : offset
      end

      relation.offset(offset).limit(limit)
    end

  end
end
