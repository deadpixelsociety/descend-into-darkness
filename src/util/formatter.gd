class_name Formatter


static func format_float(number: float, precision: int = 0) -> String:
	return ("%." + str(precision) + "f") % number
