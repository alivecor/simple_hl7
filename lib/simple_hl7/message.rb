module SimpleHL7
  class Message
    def initialize
      @segments = []
      @segments << MSHSegment.new
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^[a-zA-Z][a-zA-Z0-9]{2}$/
        get_named_segment(meth)
      else
        super
      end
    end

    def to_hl7
      separator_chars = get_named_segment('MSH').separator_chars
      @segments.map {|s| s.to_hl7(separator_chars)}.join("\n")
    end

    private

    def get_named_segment(name)
      name_str = name.to_s.upcase
      segment = @segments.select {|seg| seg.name == name_str}.first
      unless segment
        segment = Segment.new(name_str)
        @segments << segment
      end
      segment
    end
  end
end
