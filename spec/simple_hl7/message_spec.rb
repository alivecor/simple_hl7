require "simple_hl7"

module SimpleHL7
  describe Message do
    describe "#to_hl7" do
      it "generates an hl7 message" do
        msg = Message.new
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][1][2] = "Test"
        msg.to_hl7.should == "MSH|^~\\&||||accountid\nPID|||||User^Test"
      end
    end

    describe "#add_segment" do
      it "adds segments properly" do
        msg = Message.new
        obx_1 = msg.add_segment('OBX')
        obx_1[1] = "1"
        obx_2 = msg.add_segment('OBX')
        obx_2[1] = "2"
        msg.segment('OBX', 1)[1].to_s.should == "1"
        msg.segment('OBX', 2)[1].to_s.should == "2"
      end
    end
  end
end
