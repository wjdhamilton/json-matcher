require "test_helper"

Validator = EasyJSONMatcher::Validator

describe Validator do

  describe "#valid?" do

    before do
      @v_step = Minitest::Mock.new
      @subject = Validator.new(options: { validate_with: @v_step})
    end


    it "should use a ValidationStep chain to verify candidates" do
      @v_step.expect(:check, {}, [Hash])
      @subject.valid? candidate: String.new
      @v_step.verify
    end

    it "should return false if any errors are generated" do
      @v_step.expect(:check,{a: 1,b: 2,c: 3}, [Hash])
      @subject.valid?(candidate: String.new).must_be :==, false
    end

    it "should return true if no errors are generated" do
      @v_step.expect(:check, {}, [Hash])
      @subject.valid?(candidate: String.new).must_be :==, true
    end
  end

  describe "#validate" do

    before do
      @v_step = Minitest::Mock.new
      @subject = Validator.new(options: { validate_with: @v_step })
    end

    it "should call check on its verifier" do
      @v_step.expect(:check, Hash.new, [Hash])
      test_value = { a: 1, b: 2, c: 3 }.to_json
      @subject.validate(candidate: test_value)
    end
  end
end
