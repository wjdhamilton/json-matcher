require 'test_helper'

class ErrorMessagesTest < ActiveSupport::TestCase

  test "As a user I want to know why my json was not valid" do

    test_schema = EasyJSONMatcher::SchemaGenerator.new { |schema|
      schema.has_string key: :oops
      schema.has_value key: :ok
      schema.contains_node(key: :nested_oops) do |node|
        node.has_value key: :ok
        node.has_string key: :bigger_oops
      end
    }.generate_schema

    # This JSON only reflects the structure of the above, it's validity is rendered
    # irrelevant by the monkey-patch of Validator
    has_errors = {
      oops: 1,
      ok: 'ok',
      nested_oops: {
        ok: 'ok',
        bigger_oops: 2, opts: {required: true}
      }
    }.to_json

    # The resulting error object should show an error for oops, and an error in the
    # :nested_oops object for :bigger_oops. It should not show any errors for either
    # of the :oks.

    # Generate error messages. Better test that the thing is definitely invalid too...
    assert_not(test_schema.valid? has_errors)

    assert_match(/.*is not a String/, test_schema.get_errors[:oops][0])
    assert_match( /.*is not a String/, test_schema.get_errors[:nested_oops][:bigger_oops][0])
  end

  test "As a user, given that I have specified that an array should be mapped to a key and that the actual value
        is not an array, I want to know that the value is not an array" do

    test_schema = EasyJSONMatcher::SchemaGenerator.new do |s|
      s.contains_array(key: :arr, opts: {required: true})
    end.generate_schema

    wrong_type = {
      arr: "This not an array"
    }

    #As above just check that the validator is actually behaving itself
    assert_not(test_schema.valid? wrong_type)

    assert_match(/.*is not an Array/, test_schema.get_errors[:arr][0])
  end
end
