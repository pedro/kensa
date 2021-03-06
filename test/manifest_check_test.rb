require 'test/helper'

class ManifestCheckTest < Test::Unit::TestCase
  include Heroku::Kensa

  def check ; ManifestCheck ; end

  setup { @data = Manifest.new.skeleton }

  test "is valid if no errors" do
    assert_valid
  end

  test "has an id" do
    @data.delete("id")
    assert_invalid
  end

  test "api key exists" do
    @data.delete("api")
    assert_invalid
  end

  test "api is a Hash" do
    @data["api"] = ""
    assert_invalid
  end

  test "api has a password" do
    @data["api"].delete("password")
    assert_invalid
  end

  test "api contains test" do
    @data["api"].delete("test")
    assert_invalid
  end

  test "api contains production" do
    @data["api"].delete("production")
    assert_invalid
  end

  test "api contains production of https" do
    @data["api"]["production"] = "http://foo.com"
    assert_invalid
  end

  test "api contains config_vars array" do
    @data["api"]["config_vars"] = "test"
    assert_invalid
  end

  test "api contains at least one config var" do
    @data["api"]["config_vars"].clear
    assert_invalid
  end

  test "all config vars are in upper case" do
    @data["api"]["config_vars"] << 'MYADDON_invalid_var'
    assert_invalid
  end

  test "assert config var prefixes match addon id" do
    @data["api"]["config_vars"] << 'MONGO_URL'
    assert_invalid
  end

  test "replaces dashes for underscores on the config var check" do
    @data["id"] = "MY-ADDON"
    @data["api"]["config_vars"] = ["MY_ADDON_URL"]
    assert_valid
  end

  test "username is deprecated" do
    @data["api"]["username"] = "heroku"
    assert_invalid
  end
end
