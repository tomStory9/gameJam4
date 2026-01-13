extends Node

var points = 0;
var displayed_points = 0;
enum TimingJudgement {MISS, WHAT, OK, GOOD, PERFECT}

func _process(delta: float) -> void:
 update_displayed_points()

func update_points(type: TimingJudgement):
 match(type):
  TimingJudgement.MISS:
   points -= 100;
  TimingJudgement.WHAT:
   points -= 100;
  TimingJudgement.OK:
   points += 200
  TimingJudgement.GOOD:
   points += 500;
  TimingJudgement.PERFECT:
   points += 1000;

func update_displayed_points() -> void:
 var difference = abs(points - displayed_points)
 var step = max(1, difference * 0.2)
 if displayed_points < points:
  displayed_points =  min(displayed_points + step, points);
 elif displayed_points > points:
  displayed_points = max(displayed_points - step,points)
  
 displayed_points = int(displayed_points)
