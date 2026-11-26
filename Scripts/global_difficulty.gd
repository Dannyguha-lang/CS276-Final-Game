extends Node
var difficulty = "Easy"
var attack_plots = false
var repair_plots = true
var maximum_mobs_multiplier = 1.0
var mob_health_multiplier = 1.0
var mob_damage_multiplier = 1.0
var mob_speed_multiplier = 1.0
var mob_spawn_rate_multiplier = 1.0


func setDifficulty(new_dif):
	match new_dif:
		"Easy":
			difficulty = "Easy"
			attack_plots = false
			repair_plots = true
			maximum_mobs_multiplier = 1.0
			mob_health_multiplier = 1.0
			mob_damage_multiplier = 1.0
			mob_speed_multiplier = 1.0
			mob_spawn_rate_multiplier = 1.0
			return true
		"Normal":
			difficulty = "Normal"
			attack_plots = false
			repair_plots = true
			maximum_mobs_multiplier = 1.2
			mob_health_multiplier = 1.2
			mob_damage_multiplier = 1.2
			mob_speed_multiplier = 1.2
			mob_spawn_rate_multiplier = 1.2
			return true
		"Hard":
			difficulty = "Hard"
			attack_plots = true
			repair_plots = true
			maximum_mobs_multiplier = 1.5
			mob_health_multiplier = 1.5
			mob_damage_multiplier = 1.5
			mob_speed_multiplier = 1.5
			mob_spawn_rate_multiplier = 1.5
			return true
		"Hardcore":
			difficulty = "Hardcore"
			attack_plots = true
			repair_plots = false
			maximum_mobs_multiplier = 2.0
			mob_health_multiplier = 2.0
			mob_damage_multiplier = 2.0
			mob_speed_multiplier = 2.0
			mob_spawn_rate_multiplier = 2.0
			return true
	return false
			
