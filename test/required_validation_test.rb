require 'test_helper'

class RequireValidationTest < ActiveSupport::TestCase

  test "As a user I want to insist that a value is present" do
    astronaut_schema = EasyJSONMatcher::SchemaGenerator.new { |s|
      s.has_attribute key: :has_oxygen, opts: {type: :boolean, required: true}
      s.has_attribute key: :name, opts: {type: :string}
    }.generate_node

    valid_astronaut = {
      has_oxygen: true,
      name: 'Buzz Aldrin'
    }.to_json

    assert(astronaut_schema.valid?(valid_astronaut), "#{valid_astronaut} should be a valid object")

    invalid_astronaut = {
      name: 'Neil Armstrong'
    }.to_json

    assert_not(astronaut_schema.valid?(invalid_astronaut), "#{invalid_astronaut} should not be a valid object")
  end

  test "As a user I want validations to pass if the value is not present and I have not required it to be there" do
    astronaut_schema = EasyJSONMatcher::SchemaGenerator.new { |s|
      s.has_attribute key: :has_oxygen, opts: {type: :boolean}
      s.has_attribute key: :name, opts: {type: :string}
    }.generate_node

    valid_astronaut = {
      name: 'Buzz Aldrin'
    }.to_json

    assert(astronaut_schema.valid?(valid_astronaut), "#{valid_astronaut} should be valid since :has_oxygen is not required")
  end
end
