@tool
extends EditorPlugin

func psudeoretroodebumpscositify():
   EditorInterface.set_plugin_enabled("ibs", false)
   EditorInterface.restart_editor()

var _targs:Array[Node] = []
var _playa:AudioStreamPlayer = null
const _TREAMS:= [preload("res://addons/ibs/short-fart-185140.mp3"), preload("res://addons/ibs/fart-5-228245.mp3"), preload("res://addons/ibs/fart-6-228246.mp3"), preload("res://addons/ibs/fart-83471.mp3"), preload("res://addons/ibs/fart-91011.mp3"), preload("res://addons/ibs/furtz22-198542.mp3")]

func _tfill():
   _targs = get_editor_interface().get_base_control().find_children("*", "CanvasItem", true, false)
   _targs.append_array(get_editor_interface().get_base_control().find_children("*", "Node3D", true, false))
   _targs = _targs.filter(func (n): return not(n == null or n is CodeEdit or (get_editor_interface().get_edited_scene_root() != null and get_editor_interface().get_edited_scene_root().is_ancestor_of(n))))

func _process(delta: float):
   if EditorInterface.is_plugin_enabled("ibs"):
      for _ign in range(int(ceilf(delta))):
         randomize()
         if randi_range(0, 15) < 14 or (_playa != null and _playa.playing and _playa.get_playback_position() < 0.1):
            return
         if _targs.is_empty():
            _tfill()
         if _playa == null:
            _playa = AudioStreamPlayer.new()
            get_editor_interface().get_base_control().add_child(_playa)
            _playa.stream = AudioStreamRandomizer.new()
            _playa.stream.playback_mode - AudioStreamRandomizer.PLAYBACK_RANDOM_NO_REPEATS
            for i in range(_TREAMS.size()):
               _playa.stream.add_stream(i, _TREAMS[i])
            _playa.max_polyphony = 8
            _playa.play()
            _playa.stream_paused = false
         var n:Node = _targs.filter(func (n): return n != null and "visible" in n and n.visible).pick_random()
         if n == null:
            n = _targs.pick_random()
         if n is CanvasItem:
            n.material = ShaderMaterial.new()
            n.material.shader = preload("res://addons//ibs//ibs_canvas.tres")
            _playa.play()
         elif n is GeometryInstance3D:
            n.material_override = ShaderMaterial.new()
            n.material_override.shader = preload("res://addons//ibs//ibs_canvas.tres")
            _playa.play()
         elif n is Camera3D:
            n.environment = Environment.new()
            n.environment.glow = true
            n.environment.glow_bloom = 1.25
            _playa.play()
         if n is not LineEdit and n is not TextEdit and not get_editor_interface().get_inspector().is_ancestor_of(n) and "text" in n and n.text is String:
            n.text = n.text.replace("s", "z")
         _targs.erase(n)


func _enter_tree() -> void:
   if EditorInterface.is_plugin_enabled("ibs"):
      _enable_plugin()

func _enable_plugin() -> void:
   add_tool_menu_item("Psudeoretroodebumpscositify", psudeoretroodebumpscositify)
   if _playa != null:
      _playa.stream_paused = false
   _tfill()

func _disable_plugin() -> void:
   remove_tool_menu_item("Psudeoretroodebumpscositify")
   if _playa != null:
      _playa.stream_paused = true