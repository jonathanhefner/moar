module Moar

  class Config
    # Pagination increments used by {Moar::Controller#moar}.  Defaults
    # to +[12,24,24]+.  Controller-specific increments can also be set
    # via {Moar::Controller::ClassMethods#moar_increments}.
    #
    # @return [Array<Integer>]
    attr_accessor :increments

    # Name of query param used to indicate page number.  Defaults to
    # +:page+.
    #
    # @return [Symbol]
    attr_accessor :page_param

    # Name of query param used to indicate when paginated results are
    # accumulative.  Defaults to +:accum+.
    #
    # @return [Symbol]
    attr_accessor :accumulation_param

    def initialize
      @increments = [12, 24, 24]
      @page_param = :page
      @accumulation_param = :accum
    end
  end

  # Moar global configuration object.
  #
  # @return [Moar::Config]
  def self.config
    @config ||= Moar::Config.new
  end

  # @param c [Moar::Config]
  # @return [Moar::Config]
  def self.config=(c)
    @config = c
  end

end
