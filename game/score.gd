extends Node2D


func _process(delta: float) -> void:
 pass
 $ScoreLabel.text = str(Highscore.displayed_points)
