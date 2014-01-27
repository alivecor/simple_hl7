module SimpleHL7
  class Message
    def initialize(default_msh = true)
      @segments = []
      @segments << MSHSegment.new if default_msh
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^[a-zA-Z][a-zA-Z0-9]{2}$/
        get_named_segment(meth)
      elsif meth.to_s =~ /^[a-zA-Z][a-zA-Z0-9]{2}_all$/
        seg_name = meth[0..3]
        all_segments(seg_name)
      else
        super
      end
    end

    def to_hl7
      separator_chars = get_named_segment('MSH').separator_chars
      @segments.map {|s| s.to_hl7(separator_chars)}.join("\r")
    end

    def to_a
      @segments.reduce([]) {|a, s| a << s.to_a}
    end

    def segment(name, index=1)
      all = all_segments(name)
      seg = nil
      seg = all[index - 1] if all.size >= index
      seg
    end

    def add_segment(name)
      segment = Segment.new(name)
      @segments << segment
      segment
    end

    def append_segment(segment)
      @segments << segment
      segment
    end

    private

    def all_segments(name)
      @segments.select {|seg| seg.name == name}
    end


    def get_named_segment(name)
      name_str = name.to_s.upcase
      segment = @segments.select {|seg| seg.name == name_str}.first
      unless segment
        segment = Segment.new(name_str)
        @segments << segment
      end
      segment
    end

    def self.parse(str)
      msg = new(false)
      segment_strs = str.split("\r")
      msh = MSHSegment.parse(segment_strs[0])
      msg.append_segment(msh)
      segment_strs[1, segment_strs.length].each do |seg_str|
        msg.append_segment(Segment.parse(seg_str, msh.separator_chars))
      end
      msg
    end
  end
end
