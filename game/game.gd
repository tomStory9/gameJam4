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
  "texture": preload("res://artwork/assets/sprites/arrow_up_note.png")
 },
 38: {
  "key": "ui_down",
  "button": get_node("Button/DownButton"),
  "texture": preload("res://artwork/assets/sprites/arrow_down_note.png")
 },
 40: {
  "key": "ui_left",
  "button": get_node("Button/LeftButton"),
  "texture": preload("res://artwork/assets/sprites/arrow_left_note.png")
 },
 42: {
  "key": "ui_right",
  "button": get_node("Button/RightButton"),
  "texture": preload("res://artwork/assets/sprites/arrow_right_note.png")
 }
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
 pass # Replace with function body.
 $MidiPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
 delta_sum += delta


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
 if event.type == SMF.MIDIEventType.note_on:
  var note_data: Dictionary = notes.get(event.note)
  
  if note_data:
   var note = NOTE_SCENE.instantiate()

   note.global_position = note_data["button"].global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
   note.texture = note_data["texture"]
   note.speed = NOTE_Y_OFFSET * FALLING_SPEED_SCALE
   $NotesContainer.add_child(note)
