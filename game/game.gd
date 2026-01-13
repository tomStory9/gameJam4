extends Node2D

const NOTE_SCENE: PackedScene = preload("res://game/note.tscn")
const BUTTON_SPAWN_OFFSET := Vector2(16, 16)
const NOTE_Y_OFFSET := 400
const FALLING_SPEED_SCALE := 0.5
var delta_sum := 0.0
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)
@onready var notes: Dictionary = {
 36: {
  "key": "ui_up",
  "button": get_node("Button/UpButton"),
  "texture": preload("res://artwork/assets/sprites/aasiff.jpg"),
"queue":[]
 },
 38: {
  "key": "ui_down",
  "button": get_node("Button/DownButton"),
  "texture": preload("res://artwork/assets/sprites/chalencon.jpg"),
"queue":[]
 },
 40: {
  "key": "ui_left",
  "button": get_node("Button/LeftButton"),
  "texture": preload("res://artwork/assets/sprites/nourrit.jpg"),
"queue":[]
 },
 42: {
  "key": "ui_right",
  "button": get_node("Button/RightButton"),
  "texture": preload("res://artwork/assets/sprites/aasiff.jpg"),
  "queue":[]
 }
}

func _ready() -> void:
 pass # Replace with function body.
 $MidiPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
 delta_sum += delta
 
 if delta_sum >= TIMING_OFFSET and not $AudioStreamPlayer.playing:
  $AudioStreamPlayer.play()
  
 _check_input()
 _check_missed_notes()

func _check_input() -> void:
 for note_data in notes.values():
  if Input.is_action_just_pressed(note_data["key"]):
   _check_note_hit(note_data)

func _check_note_hit(note_data: Dictionary) -> void:
 if not note_data["queue"].is_empty():
  var next_note: Node2D = note_data["queue"].front()
  if next_note.test_hit(delta_sum):
   note_data["queue"].pop_front().hit(delta_sum)
  else:
   # too early
   Highscore.update_points(Highscore.TimingJudgement.WHAT)
 else:
  # no notes in the queue
  Highscore.update_points(Highscore.TimingJudgement.WHAT)


func _check_missed_notes() -> void:
 for note_data in notes.values():
  if not note_data["queue"].is_empty():
   if note_data["queue"].front().test_miss(delta_sum):
    note_data["queue"].pop_front().miss()
    
func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
 if event.type == SMF.MIDIEventType.note_on:
  var note_data: Dictionary = notes.get(event.note)
  
  if note_data:
   var note = NOTE_SCENE.instantiate()
   note.global_position = note_data["button"].global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
   note.texture = note_data["texture"]
   note.speed = NOTE_Y_OFFSET * FALLING_SPEED_SCALE
   note.expected_time = delta_sum + TIMING_OFFSET
   $NotesContainer.add_child(note)
   # add to queue
   note_data["queue"].push_back(note)


func _on_up_button_pressed() -> void:
 _check_note_hit(notes[36])
func _on_down_button_pressed() -> void:
 _check_note_hit(notes[38])
func _on_right_button_pressed() -> void:
 _check_note_hit(notes[42])
func _on_left_button_pressed() -> void:
 _check_note_hit(notes[40])
