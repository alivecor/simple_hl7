require "simple_hl7"

module SimpleHL7
  describe Subcomponent do
    describe "#to_hl7" do
      it "returns the value" do
        subf = Subcomponent.new('test')
        subf.to_hl7(SeparatorCharacters.defaults).should == 'test'
      end
    end
  end
end
