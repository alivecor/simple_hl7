require "simple_hl7"

module SimpleHL7
  describe ComponentContainer do
    describe "#to_hl7" do
      it "generates proper hl7 for a field with subfields" do
        container = ComponentContainer.new
        container[1] = "foo"
        container[2] = "bar"
        container.to_hl7(SeparatorCharacters.defaults).should == "foo^bar"
      end

      it "generates proper hl7 for a field with components and subfields" do
        container = ComponentContainer.new
        container[1] = "foo"
        container[1][2] = "bar"
        container[2] = "baz"
        container.to_hl7(SeparatorCharacters.defaults).should == "foo&bar^baz"
      end
    end
  end
end
