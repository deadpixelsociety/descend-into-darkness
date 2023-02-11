class_name Guid

const MODULO_8_BIT = 256
const HEX = "%02x"
const GUID_FORMAT = HEX + HEX + HEX + HEX + "-"\
	+ HEX + HEX + "-"\
	+ HEX + HEX + "-"\
	+ HEX + HEX + "-"\
	+ HEX + HEX + HEX + HEX + HEX + HEX


static func generate() -> String:
	return Guid.new().v4()


func v4() -> String:
	var b = _generate_bytes()
	
	return GUID_FORMAT % [
		b[0], b[1], b[2], b[3],
		b[4], b[5],
		b[6], b[7],
		b[8], b[9],
		b[10], b[11], b[12], b[13], b[14], b[15]
	]


func _get_int() -> int:
	randomize()
	return randi() % MODULO_8_BIT


func _generate_bytes() -> Array[int]:
	return [
		_get_int(), _get_int(), _get_int(), _get_int(),
		_get_int(), _get_int(), ((_get_int()) & 0x0f) | 0x40, _get_int(),
		((_get_int()) & 0x3f) | 0x80, _get_int(), _get_int(), _get_int(),
		_get_int(), _get_int(), _get_int(), _get_int(),
	]
