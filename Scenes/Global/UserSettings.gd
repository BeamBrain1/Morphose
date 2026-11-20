extends Node


const BUS_VOLUME_MIN: int = 0
const BUS_VOLUME_MAX: int = 10
const BUS_VOLUME_DEFAULT: int = 10

var bus_volume_music: int = BUS_VOLUME_DEFAULT
var bus_volume_sfx: int = BUS_VOLUME_DEFAULT
var bus_volume_ui: int = BUS_VOLUME_DEFAULT

const SCREEN_RESOLUTION_MULTIPLIER_MINIMUM: int = 1
const SCREEN_RESOLUTION_MULTIPLIER_DEFAULT: int = 3


func setBusVolume(bus: String, volume: int) -> void:
	var new_volume: int = clampi(volume, BUS_VOLUME_MIN, BUS_VOLUME_MAX)
	var bus_index: int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_linear(bus_index, float(new_volume) / float(BUS_VOLUME_MAX))


func setBusVolumeMusic(volume: int) -> void:
	setBusVolume("Music", volume)


func setScreenResolution(multiplier: int) -> void:
	DisplayServer.window_set_size(GlobalProgramData.NATIVE_RESOLUTION * maxi(multiplier, SCREEN_RESOLUTION_MULTIPLIER_MINIMUM))


func getCurrentScreenResolutionMultiplier() -> int:
	var window_size_x: int = DisplayServer.window_get_size().x
	var result: int = 1
	while result * GlobalProgramData.NATIVE_RESOLUTION.x < window_size_x:
		result += 1
	return result


func getMaxScreenResolutionMultiplier() -> int:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var result = SCREEN_RESOLUTION_MULTIPLIER_MINIMUM
	while (result + 1) * GlobalProgramData.NATIVE_RESOLUTION.x < screen_size.x and (result + 1) * GlobalProgramData.NATIVE_RESOLUTION.y < screen_size.y:
		result += 1
	return 10
