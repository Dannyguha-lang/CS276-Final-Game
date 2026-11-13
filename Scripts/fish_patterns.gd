class_name FishPatterns
extends RefCounted

class Base:
	var label := "Base"
	var period := 2.5                   # seconds for one full cycle
	var radius := Vector2(140, 90)      # half-width / half-height of the path
 
	func get_position(_t: float) -> Vector2:
		return Vector2.ZERO
 
	# Phase in radians, 0..TAU over one period
	func phase(t: float) -> float:
		return t * TAU / period
 
 
	#Randomise Variables
	func randomised(variation := 0.15) -> Base:
		period *= randf_range(1.0 - variation, 1.0 + variation)
		radius *= randf_range(1.0 - variation, 1.0)
		return self

class Circle extends Base:
	func get_position(t: float) -> Vector2:
		var a := phase(t)
		var r: float = minf(radius.x, radius.y)
		return Vector2(cos(a), sin(a)) * r

class Ellipse extends Base:
	func get_position(t: float) -> Vector2:
		var a := t * TAU / period
		return Vector2(sin(a) * radius.x, cos(a) * radius.y)

class Line extends Base:
	var angle := 0.0
	func get_position(t: float) -> Vector2:
		var dir := Vector2.from_angle(deg_to_rad(angle))
		return dir * sin(t * TAU / period) * radius.x
	func randomised(variation := 0.15) -> Base:
		period *= randf_range(1.0 - variation, 1.0 + variation)
		radius *= randf_range(1.0 - variation, 1.0)
		angle = randf_range(0,90)
		return self

class Lissajous extends Base:
	var freq := Vector2(2, 3)
	var phase_offset := 1.0
 
	func get_position(t: float) -> Vector2:
		var a := phase(t)
		return Vector2(sin(a * freq.x) * radius.x,
					   sin(a * freq.y + phase_offset) * radius.y)
 
