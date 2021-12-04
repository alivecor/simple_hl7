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
        msg.has_segment?("al1").should be_falsey
      end

    end

    describe "repeating segments accessed by calling method with segment name followed by '_all' e.g. al1_all for allergy segments" do
      it "provides access to repeating segments" do
        hl7_msg = File.read("#{File.expand_path File.dirname(__FILE__)}/sample_message_with_repeating_segments.hl7")
        msg = Message.parse(hl7_msg, segment_separator: "\n")
        msg.al1_all.size.should == 3
        msg.al1_all[1][3][2].to_s.match(/Nitrostat/).should be_truthy
        msg.al1_all[2][3][2].to_s.match(/iodine/).should be_truthy
        msg.al1[3][2].to_s.match(/nitroglycerin/).should be_truthy
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

      it "raise an error on NON llp messages" do
        expect {
          Message.parse_llp("MSH|^~\\&||||accountid\rPID|||||User^Test~Repeat")
        }.to raise_error(ArgumentError, /Invalid LLP message/)
      end
    end
  end
end
