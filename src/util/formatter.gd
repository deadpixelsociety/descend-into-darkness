class_name Formatter


static func format_float(
	number: float, 
	precision: int = 0, 
	truncate_zeroes: bool = false
) -> String:
	return get_format(number, precision, truncate_zeroes) % number


static func get_format(
	number: float, 
	precision: int = 0, 
	truncate_zeroes: bool = false
) -> String:
	if truncate_zeroes:
		var remainder = fmod(number, roundf(number))
		if remainder == 0.0:
			precision = 0
	return ("%." + str(precision) + "f")
