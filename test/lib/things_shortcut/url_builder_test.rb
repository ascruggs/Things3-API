require "test_helper"

class ThingsShortcut::UrlBuilderTest < ActiveSupport::TestCase
  test "builds simple URL without params" do
    url = ThingsShortcut::UrlBuilder.build("version")
    assert_equal "things:///version", url
  end

  test "builds URL with single param" do
    url = ThingsShortcut::UrlBuilder.build("add", title: "Buy milk")
    assert_equal "things:///add?title=Buy+milk", url
  end

  test "builds URL with multiple params" do
    url = ThingsShortcut::UrlBuilder.build("add", title: "Task", notes: "Details")
    assert_includes url, "title=Task"
    assert_includes url, "notes=Details"
    assert_includes url, "&"
  end

  test "maps snake_case keys to hyphenated" do
    url = ThingsShortcut::UrlBuilder.build("add", checklist_items: "item1")
    assert_includes url, "checklist-items=item1"
  end

  test "maps list_id to list-id" do
    url = ThingsShortcut::UrlBuilder.build("add", list_id: "abc")
    assert_includes url, "list-id=abc"
  end

  test "maps auth_token to auth-token" do
    url = ThingsShortcut::UrlBuilder.build("update", auth_token: "tok")
    assert_includes url, "auth-token=tok"
  end

  test "percent-encodes special characters" do
    url = ThingsShortcut::UrlBuilder.build("add", title: "Hello & World")
    assert_includes url, "Hello+%26+World"
  end
end
