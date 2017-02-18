require "simple_hl7"

module SimpleHL7
  describe Subcomponent do
    describe "#initialize" do
      it "changes a nil value to an empty string" do
        subc = Subcomponent.new(nil)
        subc.value.should == ''
      end

      it "changes a no argument to an empty string" do
        subc = Subcomponent.new
        subc.value.should == ''
      end

      it "initializes with a value" do
        subc = Subcomponent.new('test')
        subc.value.should == 'test'
      end
    end
    describe "#to_hl7" do
      it "returns the value" do
        subf = Subcomponent.new('test')
        subf.to_hl7(SeparatorCharacters.defaults).should == 'test'
      end

      it "escapes special characters in a string" do
        subc = Subcomponent.new('peas&carrots')
        subc.to_hl7(SeparatorCharacters.defaults).should == 'peas\T\carrots'
      end

      it "escapes all special characters" do
        subc = Subcomponent.new('\\&^~|')
        default_chars = SeparatorCharacters.defaults
        subc.to_hl7(default_chars).should == "\\E\\\\T\\\\S\\\\R\\\\F\\"
      end

      it "doesn't mutate the subcomponent" do
        subc = Subcomponent.new('peas&carrots')
        subc.to_hl7(SeparatorCharacters.defaults)
        subc.value.should == 'peas&carrots'
      end

      context "when initialized with an empty string" do
        it "returns an empty string" do
          subc = Subcomponent.new(nil)
          subc.to_hl7(SeparatorCharacters.defaults).should == ''
        end
      end
    end

    describe "#parse" do
      it "should unescape the special characters" do
        str = "\\E\\\\T\\\\S\\\\R\\\\F\\"
        default_chars = SeparatorCharacters.defaults
        parsed = Subcomponent.parse(str, default_chars)
        parsed.to_s.should == '\\&^~|'
      end
    end
  end
end
