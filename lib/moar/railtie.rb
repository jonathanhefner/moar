module Moar
  # @!visibility private
  class Railtie < ::Rails::Railtie
    initializer "moar" do |app|
      ActiveSupport.on_load :action_controller do
        include Moar::Controller
      end
    end
  end
end
