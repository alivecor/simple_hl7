require "simple_hl7"

module SimpleHL7
  describe MSHSegment do
    describe "#parse" do
      it "parses a hl7 string correctly" do
        msh = MSHSegment.parse('MSH|^~\\&|||test')
        msh.separator_chars.field.should == '|'
        msh[5].to_s.should == 'test'
      end
    end
  end
end
