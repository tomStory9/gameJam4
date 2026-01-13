extends Sprite2D


const SCREEN_BOTTOM := 600
const TIME_TOLERANCE := {
 "PERFECT": 0.02,
 "GOOD": 0.05,
 "OK": 0.08
}

var speed: float = 100.0
var expected_time: float = 0.0


func _process(delta: float) -> void:
 global_position.y += speed * delta
 
 if global_position.y >= SCREEN_BOTTOM:
  queue_free()

func test_hit(time: float) -> bool:
 return abs(expected_time - time) <= TIME_TOLERANCE.OK

func hit(time: float) -> void:
 var time_difference: float = abs(expected_time - time)
 
 if time_difference < TIME_TOLERANCE.PERFECT:
  Highscore.update_points(Highscore.TimingJudgement.PERFECT)
 elif time_difference < TIME_TOLERANCE.GOOD:
  Highscore.update_points(Highscore.TimingJudgement.GOOD)
 else:
  Highscore.update_points(Highscore.TimingJudgement.OK)
 
 queue_free()

func test_miss(time: float) -> bool:
 return time > expected_time + TIME_TOLERANCE.OK
 
func miss() -> void:
 Highscore.update_points(Highscore.TimingJudgement.MISS)
