extends Node


func play_click():
	$Click.play()

func play_enter():
	$Shimmer.play()

func play_swish():
	$Swoosh.play()
	
func play_oh_yeah():
	$Yeah.play()
	
func play_pow():
	$Boom.play()
	
func play_heal():
	$Heal.play()
	
func play_powerup():
	$Powerup.play()
	
func play_wind():
	$Wind.play()
	
func play_hit_spawn():
	$HitSpawn.play()
	
func play_danger():
	$Danger.play()
	
func play_cheer():
	$Cheer.play()
	
func play_chaching():
	$ChaChing.play()
	
func play_error():
	$Error.play()

func play_critter_attack(critter_type):
	match critter_type:
		Critter.Critters.RATLER, Critter.Critters.MOUSLE, Critter.Critters.RATOCOPTER:
			$Squeak.play()
		Critter.Critters.PIDGE_PODGE, Critter.Critters.GULLMEYER, Critter.Critters.BAGGO:
			$Flap.play()
		Critter.Critters.COFFEENY, Critter.Critters.PIZZALING, Critter.Critters.ROACHMEISER:
			$Squish.play()
		Critter.Critters.FERROTH, Critter.Critters.CEO:
			$Angel.play()
		Critter.Critters.DEMOGATOR, Critter.Critters.SECURIBULL, Critter.Critters.CEO:
			$Fire.play()
