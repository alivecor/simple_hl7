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
    end

    describe "[]" do
      it "gets the proper value" do
        field = Component.new
        field[1] = "foo"
        field[1].to_s.should == "foo"
      end
    end
  end
end
