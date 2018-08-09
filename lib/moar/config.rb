module Moar

  class Config
    attr_accessor :increments, :page_param, :accumulation_param

    def initialize
      @increments = [12, 24, 24]
      @page_param = :page
      @accumulation_param = :accum
    end
  end

  def self.config
    @config ||= Moar::Config.new
  end

  def self.config=(c)
    @config = c
  end

end
