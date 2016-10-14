require "simple_hl7"

module SimpleHL7
  describe Message do
    describe "#to_hl7" do
      it "generates an hl7 message" do
        msg = Message.new
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][2] = "Test"
        msg.to_hl7.should == "MSH|^~\\&||||accountid\rPID|||||User^Test"
      end

      it "generates an hl7 message with a nil field" do
        msg = Message.new
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][2] = "Test"
        msg.msh[5] = nil
        msg.to_hl7.should == "MSH|^~\\&||||accountid\rPID|||||User^Test"
      end

      it "generates a message with a non-default segment separator" do
        msg = Message.new(segment_separator: "\r\n")
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][2] = "Test"
        msg.to_hl7.should == "MSH|^~\\&||||accountid\r\nPID|||||User^Test"
      end
    end

    describe "#to_llp" do
      it "generates an llp message" do
        msg = Message.new
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][2] = "Test"
        msg.to_llp.should == "\x0bMSH|^~\\&||||accountid\rPID|||||User^Test\x1c\r"
      end

      it "generates a llp message with a non-default segment separator" do
        msg = Message.new(segment_separator: "\r\n")
        msg.msh[6] = "accountid"
        msg.pid[5] = "User"
        msg.pid[5][2] = "Test"
        msg.to_llp.should == "\x0bMSH|^~\\&||||accountid\r\nPID|||||User^Test\x1c\r"
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

    describe "#parse" do
      it "properly parses a hl7 string" do
        msg = Message.parse("MSH|^~\\&||||accountid\rPID|||||User^Test~Repeat")
        msg.msh[6].to_s.should == "accountid"
        msg.pid[5].to_s.should == "User"
        msg.pid[5][2].to_s.should == "Test"
        msg.pid[5].r(2)[1].to_s.should == "Repeat"
      end

      it "properly parses a hl7 string with nonstandard separators" do
        msg = Message.parse("MSH|^~\\&||||accountid\r\nPID|||||User^Test",
                            segment_separator: "\r\n")
        msg.msh[6].to_s.should == "accountid"
        msg.pid[5].to_s.should == "User"
        msg.pid[5][2].to_s.should == "Test"
      end
    end

    describe "#parse_llp" do
      it "properly parses a llp string" do
        msg = Message.parse_llp("\x0bMSH|^~\\&||||accountid\rPID|||||User^Test~Repeat\x1c\r")
        msg.msh[6].to_s.should == "accountid"
        msg.pid[5].to_s.should == "User"
        msg.pid[5][2].to_s.should == "Test"
        msg.pid[5].r(2)[1].to_s.should == "Repeat"
      end
    end
  end
end
