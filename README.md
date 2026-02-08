[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.5.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/dragonforge-dev/dragonforge-camera-3d?logo=mit)](https://github.com/dragonforge-dev/dragonforge-camera-3d/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/dragonforge-dev/dragonforge-camera-3d/latest)](https://github.com/dragonforge-dev/dragonforge-camera-3d/releases/latest)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-camera-3d)](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-camera-3d)


# Dragonforge Camera 2D <img src="/assets/textures/icons/readme_icon.svg" width="32" alt="Camera 2D Project Icon"/>
Godot Camera2D components to add basic features to cameras.

# Version 0.1
For use with **Godot 4.5.stable** and later.

## Dependencies
The following dependencies are included in the addons folder and are required for the template to function.
- [Dragonforge Controller 0.12.1](https://github.com/dragonforge-dev/dragonforge-controller)
# Installation Instructions
1. Copy the `dragonforge_controller` folder from the `addons` folder into your project's `addons` folder.
2. Ignore the following errors (they are appearing because the component is not yet enabled):
  * ERROR: res://addons/dragonforge_controller/controller.gd:54 - Parse Error: Identifier "Keyboard" not declared in the current scope.
  * ERROR: res://addons/dragonforge_controller/controller.gd:56 - Parse Error: Identifier "Mouse" not declared in the current scope.
  * ERROR: res://addons/dragonforge_controller/controller.gd:59 - Parse Error: Identifier "Gamepad" not declared in the current scope.
  * ERROR: modules/gdscript/gdscript.cpp:3022 - Failed to load script "res://addons/dragonforge_controller/controller.gd" with error "Parse error".
11. Copy the `dragonforge_camera` folder from the `addons` folder into your project's `addons` folder.
3. In your project go to **Project -> Project Settings...**
4. Select the **Plugins** tab.
5. Check the **On checkbox** under **Enabled** for **Dragonforge Controller**
5. Check the **On checkbox** under **Enabled** for **Dragonforge Camera 3D**
10. Press the **Close** button.
11. Save your project.
12. In your project go to **Project -> Reload Current Project**.
13. Wait for the project to reload.

**NOTE:** It's important to reload the project after running the plugin because it creates the `change_camera` action. Once you reboot, you can edit this action as you wish, but disabling and re-enabling this plugin will reset them because disabling the plugin will remove the action.

# Usage Instructions
1. On your **CharacterBody3D** node click **+ Add Child Node...** and select a **Cameras** node.
2. On your **Cameras** node click **+ Add Child Node...** and add as many **Camera3D** nodes as you like. Configure them however you like. The player will be able to rotate through them at will.
## First-Person View Camera
1. If you haven't already, on your **CharacterBody3D** node click **+ Add Child Node...** and select a **Cameras** node.
2. On your **Cameras** node click **+ Add Child Node...** and add a **CameraMount3D** node.
3. Change the **Upwards Rotation Limit** to **-15**.
4. Change the **Downwards Rotation Limit** to **40**.
5. Check the **First Person** box.
6. Add the following code to your **CharacterBody3D**:

```
class_name Player extends Character


## Your character model
@export var rig: Node3D
## The speed at which the player turns.
@export var turn_speed: float = 20.0
##
@export var speed = 5.0


#A reference to your Cameras object
@onready var cameras: Cameras = $Cameras


var direction := Vector3.ZERO


func _physics_process(delta: float) -> void:
	direction = get_input_direction()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if velocity.length() > 1.0 and direction != Vector3.ZERO:
		look_toward_direction(delta)
	
	move_and_slide()
	

func get_input_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	return cameras.get_facing(input_vector, character.transform.basis)


func look_toward_direction(delta: float) -> void:
	var target := rig.global_transform.looking_at(rig.global_position + direction, Vector3.UP)
	rig.global_transform = rig.global_transform.interpolate_with(target, 1.0 - exp(-turn_speed * delta))
```

# Class Descriptions
## Cameras <img src="/addons/dragonforge_camera/assets/textures/icons/video-camera-round.svg" width="32" alt="Cameras Icon"/>
A list of cameras. If you want a first-person or third-person camera, attach a **CameraMount3D** node as a child of this one (you can add as many as you want.) If you want to add a static camera, you can do that too.
### OnReady Variables
- `available_cameras: Array[Node3D]` The cameras available to the player. Pressing the change_camera button will switch to the next camera in the list. The list is constructed when this object is first created, and is made of all the child nodes one level down that are either **Camera3D** of **CameraMount3D** nodes.
- `active_camera_iterator` Iterator
- `active_camera: Node3D = get_first_camera()` A reference to the currently active camera. This currently ONLY tracks cameras the player has control over (by switching). Any cutscene cameras, etc. will not be assigned to this variable.
### Public Functions
Note that while all these functions are available, as long as the `change_camera` action is mapped, the played can cycle through all the available cameras without any additional coding. These functions are primarily for switching between player cameras and cutscene cameras.
- `next_camera() -> void` Activates the next camera in the list.
- `get_first_camera() -> Node3D` Return the first Camera3D or CameraMount3D found that is a child of this node.
- `inititalize_cameras() -> Array[Node3D]` Return a list of all Camera3D and CameraMount3D nodes that are children of this node.
- `change_camera(camera: Node3D) -> void` Makes the passed camera the active camera.
- `get_facing(input_vector: Vector3, character_transform_basis: Basis) -> Vector3` Returns the direction for a [CharacterBody3D] based on the passed input vector and the [member Characterbody.transform.basis]. If the active camera is 1st person, 3rd person free look or 3rd person follow, the player will point in the direction of the camera. If the camera is a 3rd person fixed, ISO or birds eye view camera, it will just reflect the actual direction the input is moving the player.

## CameraMount3D <img src="/addons/dragonforge_camera/assets/textures/icons/video-camera-mount.svg" width="32" alt="Cameras Mount 3D Icon"/>
Intended if you want a first person or third person camera attached to the player. If you want this to be a first person camera, set `first_person` to true.
### Export Variables
- `upwards_rotation_limit: float = 0.0` How far up the camera will rotate in degrees.
- `downwards_rotation_limit: float = 0.0` How far down the camera will rotate in degrees.
- `first_person: bool = false` If true, camera is a first-person camera. Otherwise, third-person.
### Public Functions
- `make_current() -> void` Make the attached camera the current camera and reset the rotation.

# Credits

## Icons
https://www.svgrepo.com/svg/486767/pan
https://www.svgrepo.com/svg/364977/vibrate-fill
https://www.svgrepo.com/svg/501433/add
https://www.svgrepo.com/svg/407206/pinching-hand
https://www.svgrepo.com/svg/479560/zoom-1
https://www.svgrepo.com/svg/513024/video-camera-round-964
