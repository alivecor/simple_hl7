require "simple_hl7"

module SimpleHL7
  describe Segment do
    describe "#to_hl7" do
      it "generates a message using the specified separator chars" do
        sep_chars = SeparatorCharacters.defaults
        seg = Segment.new('PID')
        seg[5] = 'test'
        seg.to_hl7(sep_chars).should == 'PID|||||test'
      end
    end
  end
end
