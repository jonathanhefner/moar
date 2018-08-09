#require "rails/generators/base"

module Moar
  # @!visibility private
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def inject_javascript
        inside do
          manifest = Dir["app/assets/javascripts/application.js{,.coffee}"].first
          raise Thor::Error.new("Could not find application.js") unless manifest

          before, eq = File.read(manifest).match(%r"^(//=|\s*\*=|#=) require_tree.*").to_a
          raise Thor::Error.new("Unable to inject `require moar` into #{manifest}") unless before

          inject_into_file manifest, "#{eq} require moar\n", before: before
        end
      end

      def copy_initializer
        template "config/initializers/moar.rb"
      end
    end
  end
end
