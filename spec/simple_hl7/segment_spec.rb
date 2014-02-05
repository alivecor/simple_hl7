require "pry"
require "simple_hl7"

module SimpleHL7
  describe Segment do
    describe "#initialize" do
      it "is not case sensitive to the segment name" do
        seg = Segment.new('pId')
        seg.name.should == 'PID'
      end
    end

    describe "#to_hl7" do
      it "generates a message using the specified separator chars" do
        sep_chars = SeparatorCharacters.defaults
        seg = Segment.new('PID')
        seg[5] = 'test'
        seg.to_hl7(sep_chars).should == 'PID|||||test'
      end
    end

    describe "#parse" do
      it "parses a hl7 string correctly" do
        sep_chars = SeparatorCharacters.defaults
        seg = Segment.parse('PID|||||test', sep_chars)
        seg[5].to_s.should == 'test'
      end
    end
  end
end
