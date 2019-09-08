module Moar
  # @!visibility private
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def copy_initializer
        template "config/initializers/moar.rb"
      end

      def copy_locales
        copy_file "config/locales/moar.en.yml"
      end

      def inject_javascript
        inside do
          manifest = Dir["app/assets/javascripts/application.js{,.coffee}"].first
          before, eq = File.read(manifest).match(%r"^(//=|\s*\*=|#=) require_tree.*").to_a if manifest

          if before
            inject_into_file manifest, "#{eq} require moar\n", before: before
          else
            manifest ||= "app/assets/javascripts/application.js"
            say "WARNING: Failed to inject `require moar` into #{manifest}.  " \
              "You must manually require moar.js to enable Ajax behavior."
          end
        end
      end
    end
  end
end
