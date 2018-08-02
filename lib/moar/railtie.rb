module Moar
  # @!visibility private
  class Railtie < ::Rails::Railtie
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
