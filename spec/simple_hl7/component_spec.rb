require "simple_hl7"

module SimpleHL7
  describe Component do
    describe "#to_hl7" do
      it "generates proper hl7 for a field with subfields" do
        field = Component.new
        field[1] = "foo"
        field[2] = "bar"
        field.to_hl7(SeparatorCharacters.defaults).should == "foo&bar"
      end

      it "returns an empty string when initialized with a nil" do
        field = Component.new(nil)
        field.to_hl7(SeparatorCharacters.defaults).should == ''
      end
    end

    describe "[]" do
      it "gets the proper value" do
        field = Component.new
        field[1] = "foo"
        field[1].to_s.should == "foo"
      end
    end

    describe "#parse" do
      it "parse hl7 correctly" do
        component = Component.parse("foo&bar", SeparatorCharacters.defaults)
        component[1].to_s.should == "foo"
        component[2].to_s.should == "bar"
      end
    end
  end
end
