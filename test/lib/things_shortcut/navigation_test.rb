require "test_helper"

class ThingsShortcut::NavigationTest < ActiveSupport::TestCase
  test "show with id builds correct URL" do
    result = ThingsShortcut::Navigation.show(id: "inbox")
    assert_equal({ id: "inbox" }, result)
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///show"
    assert_includes @mock_shortcut_runner.executed_urls.last, "id=inbox"
  end

  test "show with query builds correct URL" do
    result = ThingsShortcut::Navigation.show(query: "groceries")
    assert_equal({ query: "groceries" }, result)
    assert_includes @mock_shortcut_runner.executed_urls.last, "query=groceries"
  end

  test "show with filter builds correct URL" do
    result = ThingsShortcut::Navigation.show(filter: "today")
    assert_equal({ filter: "today" }, result)
  end

  test "show raises ValidationError without id, query, or filter" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::Navigation.show({})
    end
  end

  test "search builds correct URL" do
    result = ThingsShortcut::Navigation.search("groceries")
    assert_equal({ query: "groceries" }, result)
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///search"
    assert_includes @mock_shortcut_runner.executed_urls.last, "query=groceries"
  end

  test "search raises ValidationError with empty query" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::Navigation.search("")
    end
  end

  test "search raises ValidationError with nil query" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::Navigation.search(nil)
    end
  end
end
