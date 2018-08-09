module Moar

  class Config
    attr_accessor :increments

    def initialize
      @increments = [12, 24, 24]
    end
  end

  def self.config
    @config ||= Moar::Config.new
  end

  def self.config=(c)
    @config = c
  end

end
