require "test_helper"
require "easy_json_matcher/array_validator"

module EasyJSONMatcher

  describe ArrayValidator do

    before do
      @subject = ArrayValidator.new verify_content_as: [:string]
    end

    describe "Validating Array Types" do

      it "should return valid for empty arrays" do
        @subject.call(value: []).must_be :empty?
      end

      it "should return errors for any other object" do
        @subject.call(value: 1).wont_be :empty?
      end

      it "should call all the content is of a particular type" do
        @subject.call(value: [1, 2, 3]).wont_be :empty?
      end
    end
  end
end
