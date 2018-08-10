require "test_helper"
require "generators/moar/install/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Moar::Generators::InstallGenerator
  destination File.join(__dir__, "tmp")

  setup do
    prepare_destination

    @script_manifest = File.expand_path("app/assets/javascripts/application.js",
      destination_root)
    FileUtils.mkdir_p(File.dirname(@script_manifest))
    File.write(@script_manifest, "//= require_tree .\n")
  end

  def test_injects_javascript
    run_generator_and_verify_script_manifest <<~CONTENTS
      // comment 1
      // comment 2
      //= require a
      //= require b
      //= require moar
      //= require_tree c
      //= require_tree .
    CONTENTS
  end

  def test_injects_javascript_only_once
    run_generator
    run_generator
    assert_equal 1, File.read(@script_manifest).scan("require moar").length
  end

  def test_injects_javascript_multiline
    run_generator_and_verify_script_manifest <<~CONTENTS
      /*
       *= require moar
       *= require_tree .
       */
    CONTENTS
  end

  def test_injects_coffeescript
    File.delete(@script_manifest)
    @script_manifest += ".coffee"

    run_generator_and_verify_script_manifest <<~CONTENTS
      #= require moar
      #= require_tree .
    CONTENTS
  end

  def test_copies_initializer
    run_generator
    assert_file "config/initializers/moar.rb"
  end

  def test_copies_locales
    run_generator
    assert_file "config/locales/moar.en.yml"
  end

  private

  def run_generator_and_verify_script_manifest(contents)
    File.write(@script_manifest, contents.gsub(/^.*moar\n/, ""))
    run_generator
    assert_file @script_manifest, contents
  end

end
