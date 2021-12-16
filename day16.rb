LENGTH_TYPE_BITS = 0
LENGTH_TYPE_SUBPACKETS = 1
SUBPACKETS_LENGTH_START = 7
LENGTH_TYPE_BITS_LENGTH = 15
LENGTH_TYPE_SUBPACKETS_LENGTH = 11
HEADER_LENGTH = 6

PACKET_ID_TYPE_SUM = 0
PACKET_ID_TYPE_PRODUCT = 1
PACKET_ID_TYPE_MINIMUM = 2
PACKET_ID_TYPE_MAXIMUM = 3
PACKET_ID_TYPE_LITERAL = 4
PACKET_ID_TYPE_GREATER_THAN = 5
PACKET_ID_TYPE_LESS_THAN = 6
PACKET_ID_TYPE_EQUAL = 7

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT_1 = [
  '8A004A801A8002F478',
  '620080001611562C8802118E34',
  'C0015000016115A2E0802F182340',
  'A0016C880162017C3686B18A3D4780'
]

TEST_INPUT_2 = [
  'C200B40A82',
  '04005AC33890', # this one doesn't get parsed correctly for some reason
  '880086C3E88112',
  'CE00C43D881120',
  'D8005AC2A8F0',
  'F600BC2D8F',
  '9C005AC2F8F0',
  '9C0141080250320F1802104A08'
]

REAL_INPUT = import_from_file('day16_input.txt')

def hex2bin(hex_string)
  str = hex_string.to_i(16).to_s(2)
  str = '0' + str until (str.length % 4).zero?
  str
end

def packet_version(packet)
  packet[0, 3].to_i(2)
end

def packet_type_id(packet)
  packet[3, 3].to_i(2)
end

def literal?(packet)
  packet_type_id(packet) == PACKET_ID_TYPE_LITERAL
end

def operator?(packet)
  !literal?(packet)
end

def length_type_id(packet)
  packet[6].to_i(2)
end

# assumption: packet uses appropriate length type ID
def num_subpacket_bits(packet)
  packet[SUBPACKETS_LENGTH_START, LENGTH_TYPE_BITS_LENGTH].to_i(2)
end

# assumption: packet uses appropriate length type ID
def num_subpackets(packet)
  packet[SUBPACKETS_LENGTH_START, LENGTH_TYPE_SUBPACKETS_LENGTH].to_i(2)
end

def packet_empty?(packet)
  packet.to_i(2).zero?
end

def parse_packets(packet, max_packets: nil, literal_values: [])
  if packet_empty?(packet) || max_packets == 0
    return { version_sum: 0, bits_parsed: 0, literal_values: [] }
  end

  version_sum = 0
  version_sum += packet_version(packet)
  bits_parsed = 0
  parsed = nil
  if literal?(packet)
    binary_value = ''
    pos = bits_parsed = HEADER_LENGTH
    loop do
      chunk = packet[pos, 5]
      bits_parsed += 5
      binary_value << chunk[1, 4]
      pos += 5
      break if chunk[0] == '0'
    end
    literal = binary_value.to_i(2)
    literal_values << literal
  else
    if length_type_id(packet) == LENGTH_TYPE_BITS
      nsb = num_subpacket_bits(packet)
      bits_parsed += SUBPACKETS_LENGTH_START + LENGTH_TYPE_BITS_LENGTH
      parsed = parse_packets(packet[bits_parsed, nsb])
    else
      nsp = num_subpackets(packet)
      bits_parsed += SUBPACKETS_LENGTH_START + LENGTH_TYPE_SUBPACKETS_LENGTH
      parsed = parse_packets(packet[bits_parsed...packet.length], max_packets: nsp)
    end
    version_sum += parsed[:version_sum]
    bits_parsed += parsed[:bits_parsed]
    literal_values = case packet_type_id(packet)
                     when PACKET_ID_TYPE_SUM
                       parsed[:literal_values].sum
                     when PACKET_ID_TYPE_PRODUCT
                       parsed[:literal_values].reduce(&:*)
                     when PACKET_ID_TYPE_MINIMUM
                       parsed[:literal_values].min
                     when PACKET_ID_TYPE_MAXIMUM
                       parsed[:literal_values].max
                     when PACKET_ID_TYPE_GREATER_THAN
                       lv = parsed[:literal_values]
                       lv[0] > lv[1] ? 1 : 0
                     when PACKET_ID_TYPE_LESS_THAN
                       lv = parsed[:literal_values]
                       lv[1] > lv[0] ? 1 : 0
                     when PACKET_ID_TYPE_EQUAL
                       lv = parsed[:literal_values]
                       lv[0] == lv[1] ? 1 : 0
                     end
  end
  parsed = if max_packets
             parse_packets(packet[bits_parsed...packet.length], max_packets: max_packets - 1)
           else
             parse_packets(packet[bits_parsed...packet.length])
           end
  version_sum += parsed[:version_sum]
  bits_parsed += parsed[:bits_parsed]
  literal_values = Array(literal_values) + Array(parsed[:literal_values])
  {
    version_sum: version_sum,
    bits_parsed: bits_parsed,
    literal_values: literal_values
  }
end

def part_one(input)
  packet = hex2bin(input)
  parse_packets(packet)[0]
end

def part_two(input)
  packet = hex2bin(input)
  parse_packets(packet)[:literal_values]
end

TEST_INPUT_1.each do |input|
  p part_one(input) # should be 16, 12, 23, 31
end

p part_one(REAL_INPUT)

TEST_INPUT_2.each do |input|
  p part_two(input) # should be 3, 54, 7, 9, 1, 0, 0, 1
end

p part_two(REAL_INPUT)
