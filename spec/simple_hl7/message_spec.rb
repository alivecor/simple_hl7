require "simple_hl7"

module SimpleHL7
  describe Segment do
    describe "#to_hl7" do
      it "generates an hl7 message" do
        msg = Message.new
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][1][2] = "Test"
        msg.to_hl7.should == "MSH|^~\\&||||accountid\nPID|||||User^Test"
      end
    end
  end
end
