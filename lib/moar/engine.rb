module Moar
  # @!visibility private
  class Engine < ::Rails::Engine
    initializer "moar" do |app|
      ActiveSupport.on_load :action_controller do
        include Moar::Controller
      end

      ActiveSupport.on_load :action_view do
        include Moar::Helper
      end
    end
  end
end
