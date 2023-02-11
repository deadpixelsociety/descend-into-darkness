class_name RandUtil


static func rand_vector2() -> Vector2:
	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)


static func randfn_range(
	min_value: float, 
	max_value: float,
	mean: float = 0.5,
	deviation: float = 0.2
) -> float:
	var f = clampf(randfn(mean, deviation), 0.0, 1.0)
	return min_value + (max_value - min_value) * f


static func rand_weighted(weights: Dictionary):
	if weights.size() == 0:
		return null
	var sum = 0.0
	for w in weights.values():
		sum += w
	var r = randf() * sum
	for k in weights.keys():
		var w = weights[k]
		r -= w
		if r < 0:
			return k
	return weights[weights.keys().back()]
