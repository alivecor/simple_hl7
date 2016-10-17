# SimpleHl7

SimpleHL7 is a library that manages HL7 v2.x documents for interfacing with
health care systems.  The goal of SimpleHL7 is to make it easy to create basic
HL7 messages while also having the power to create more complex ones. SimpleHL7
is agnostic of message and segment types, it works only with the basic
structure of HL7 documents.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_hl7'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_hl7

## Usage

SimpleHL7 can be used for either message creation or parsing.

### Message Creation

A simple example:

```ruby
msg = SimpleHL7::Message.new
msg.msh[9][1] = "ADT"
msg.msh[9][2] = "A04"
msg.msh[10] = "12345678"
msg.msh[11] = "D"
msg.msh[12] = "2.5"

msg.pid[3] = "454545"
msg.pid[5][1] = "Doe"
msg.pid[5][2] = "John"

msg.pv1[2] = "O"

msg.to_hl7
```

Would generate the following HL7 string.

```
MSH|^~\&|||||||ADT^A04|12345678|D|2.5
PID|||454545||Doe^John
PV1||O
```

This is the easiest way to use SimpleHL7, however most of the methods used
above are syntactic sugar for underlying methods that are explained in detail
later.

### Adding a segment

The easiest way to add a segment to a new message is by calling its three
letter segment name as a method on the message. For example to create a PID
segment, do the following:

```ruby
msg = SimpleHL7::Message.new
msg.pid
```

Note that since the MSH segment is always required it is created automatically.
So if to_hl7 was called on the message above, the result would be

```
MSH|^~\&|
PID
```

### Repeating segments

Using the segment name is the easiest way to create a new segment, but if you
have more than one segment with the same name it won't work. The first name
method call will create a segment, but subsequent calls will just reference
that first created segment.

To create multiple segments of the same type use the underlying `add_segment`
method.

```ruby
obx1 = msg.add_segment('obx')
obx2 = msg.add_segment('obx')
```

To later retreive a certain segment use the `segment` method.

```
obx2 = msg.segment('obx', 2)
```

### Adding components, subcomponents, fields etc.

To add values to the message just specifiy the index in brackets

```ruby
msg = SimpleHL7::Message.new
msg.msh[12] = '2.5'
```

To specifiy a certain component use more brackets.

```ruby
msg = SimpleHL7::Message.new
msg.msh[9][1] = "ADT"
msg.msh[9][2] = "A04"
```

It is important to note that under the hood the the bracket syntax actually
adds the value to the first subcomponent of the first component of the first
repetition in the specified field.

This means that:

```ruby
msg.msh[9] = "ADT"
msg.msh[9][1] = "ADT"
msg.msh[9][1][1] = "ADT"
```

are all equivalent.

### Repeating fields

Since repeating fields are less common in HL7 they require a little bit of
extra work to create using SimpleHL7. Use the `r(index)` method to create
repeats.

```ruby
msg.pid[13] = '123-4567'
msg.pid[13].r(2)[1] = '876-5432'
```

Creates the following PID segment

```
PID|||||||||||||123-4567~876-5432
```

### HL7 Escaping

HL7 special characters are automatically escaped properly when generating HL7,
without doing any extra work.

```ruby
msg = SimpleHL7::Message.new
msg.nte[3] = "Testing & escaping notes"
msg.to_hl7
```

Outputs:

```
MSH|^~\&|
NTE|||Testing \T\ escaping notes
```
### Segment Separator

Some nonstandard HL7 implementations require a different segment separator
character than "\r". To make this change pass the `segment_separator` option to
the `Message` constructor.

```ruby
msg = SimpleHL7::Message.new(segment_separator: "\r\n")
msg.pid[3] = "123456"
msg.to_hl7
=> "MSH|^~\\&|\r\nPID|||123456"
```
### Transmitting via TCP/IP

The Lower Layer Protocol (LLP) is the most common mechanism for sending unencrypted HL7 via TCP/IP over a local area network. In order to be complaint with this protocol you can use `to_llp` method which wraps the HL7 message with the appropriate header and trailer.

```ruby
msg = SimpleHL7::Message.new
msg.msh[12] = '2.5'

socket = TCPSocket.open(ipaddr, port)
socket.write msg.to_llp
socket.close
```

### Parsing

To parse HL7 string use the parse method

```ruby
hl7_str = "MSH|^~\\&|||||||ADT^A04|12345678|D|2.5\rPID|||454545||Doe^John"
msg = SimpleHL7::Message.parse(hl7_str)
```

Once the message is parsed use to_s to pull out values

```ruby
msg.pid[5][1].to_s
=> "Doe"
```

If the string to be parsed contains a nonstandard segment separator then it can
be passed into the `parse` method as well:

```ruby
hl7_str = "MSH|^~\\&|||||||ADT^A04|12345678|D|2.5\r\nPID|||454545||Doe^John"
msg = SimpleHL7::Message.parse(hl7_str, segment_separator: "\r\n")
```

### Parsing LLP messages

In case you are parsing HL7 messages received over TCP/IP using the LLP protocol, use the `parse_llp` method

```ruby
llp_str = "\x0bMSH|^~\\&|||||||ADT^A04|12345678|D|2.5\rPID|||454545||Doe^John\x1c\r"
msg = SimpleHL7::Message.parse_llp(llp_str)
```

Once the message is parsed you can follow the same methods pointed above to pull out values

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
