Moar.config.tap do |config|
  # Default pagination increments.  Controller-specific increments can
  # also be set via the `moar_increments` controller class method.
  config.increments = [12, 24, 24]

  # Name of query param used to indicate page number.
  config.page_param = :page

  # Name of query param used to indicate when paginated results are
  # accumulative.
  config.accumulation_param = :accum
end
