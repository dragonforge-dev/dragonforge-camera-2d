[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.6.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/dragonforge-dev/dragonforge-camera-3d?logo=mit)](https://github.com/dragonforge-dev/dragonforge-camera-3d/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/dragonforge-dev/dragonforge-camera-3d/latest)](https://github.com/dragonforge-dev/dragonforge-camera-3d/releases/latest)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-camera-3d)](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-camera-3d)

# Dragonforge Camera 2D <img src="/assets/textures/icons/readme_icon.svg" width="32" alt="Camera 2D Project Icon"/>
Godot Camera2D components to add basic features to cameras.
- **Camera2DLimit** - Limit the **Camera2D** to the boundaries of a **TileMapLayer**'s used tiles or a **Rect2i**.
- **Camera2DZoom** - Allow a player to zoom a **Camera2D** using the mouse, keyboard, or controller.
- **Camera2DShake** - Shakes a **Camera2D** (and optionally a controller) when directed.
- **Camera2DPan** - Allow a player to pan a **Camera2D** using the mouse, keyboard, controller, or touch screen.
- **Camera2DPinchZoom** - Allow a player to zoom a **Camera2D** using pinch zoom on a touch screen.

# Version 0.1
For use with **Godot 4.6.stable** and later.

# Installation Instructions
1. Copy the `dragonforge_camera_2d` folder from the `addons` folder into your project's `addons` folder.
2. Ignore any errors (they are appearing because the component is not yet enabled.)
3. In your project go to **Project -> Project Settings...**
4. Select the **Plugins** tab.
5. Check the **On checkbox** under **Enabled** for **Dragonforge Camera 2D**
6. Press the **Close** button.
7. Save your project.
8. In your project go to **Project -> Reload Current Project**.
9. Wait for the project to reload.

**NOTE:** It's important to reload the project after running the plugin because it creates multiple camera actions for zooming and panning. Once you reboot, you can edit this action as you wish, but disabling and re-enabling this plugin will reset them because disabling the plugin will remove the action.

# Usage Instructions
1. On a **Camera2D** node click **+ Add Child Node...**.
2. In the **Search** box type "camera".
3. Under **Camera2DComponent**, select a component to add. (Click on each one for a description or check out the Readme.)
4. Repeat as desired.

# Class Descriptions
## Camera2DLimit <img src="/addons/dragonforge_camera_2d/assets/textures/icons/limit.svg" width="32" alt="Camera 2D Limit Icon"/>
Adding this component to a [Camera2D] restricts it to the to the used area of a [TileMapLayer] or [Rect2i].

### Usage
1. On a **Camera2D** node click **+ Add Child Node...**.
2. Select **Camera2DLimit** and click the **Create** button.
3. Select the new **Camera2DLimit** node.
4. In the **Inspector** find the **Tile Map Layer** property.
5. Click the **Assign** button.
6. Select the **TileMapLayer** you want to affect the **Camera2D**.

### Updating the Camera2DLimit via Signal
During gameplay, you can update the camera **Camera2DLimit** node's **Tile Map Layer**. You may want to do this because you have multiple levels of different sizes. The easiest way is just to add this code to your level's `_ready()` function. (Alternately, you would want to add this to your level switching code if the level is already loaded in memory.)

```
# Change this to point at your actual TileMapLayer
@onready var tile_map_layer: TimeMapLayer = $TimeMapLayer

func _ready() -> void:
	Camera2DSignalBus.update_camera_boundaries.emit(tile_map_layer)
```

### Export Variables
- `@export var tile_map_layer: TileMapLayer` The [TileMapLayer] to use to restrict the atttached [Camera2D]'s limits.

### Public Functions
- `func set_limit(limit: Rect2i) -> void` Sets the attached camera's boundaries to be that of the passed [Rect2i] [param limit].
- `set_tile_map_layer_limit(tile_map_layer: TileMapLayer) -> void` Sets the attached camera's boundaries to be that of the used tiles on the passed [param tile_map_layer]. [b]NOTE:[/b] It is recommended to use [signal Camera2DSignalBus.update_camera_boundaries] to trigger this functionality.


## Camera2DZoom <img src="/addons/dragonforge_camera_2d/assets/textures/icons/zoom.svg" width="32" alt="Cameras Zoom Icon"/>
Adding this component to a [Camera2D] allows the user to zoom in and out using the mouse wheel, keyboard, or controller. For pinch zoom support, see the [Camera2DPinchZoom] component..

### Usage
1. On a **Camera2D** node click **+ Add Child Node...**.
2. Select **Camera2DZoom** and click the **Create** button.
3. Select the new **Camera2DZoom** node.
4. In the **Inspector** modify the zoom properties as you desire.

### Constants
- `ZOOM_IN = "zoom_in"` Remap the "zoom_in" [Action] to change the controls to zoom in.
- `ZOOM_OUT = "zoom_out"` Remap the "zoom_out" [Action] to change the controls to zoom out.
- `MOUSE_WHEEL_ZOOM_IN = "mouse_wheel_zoom_in"` Zoom in [Action] only used by the wheel mouse.
- `MOUSE_WHEEL_ZOOM_OUT = "mouse_wheel_zoom_out"` Zoom out [Action] only used by the wheel mouse.

### Export Variables
- `@export_range(1.0, 5.0, 0.01) zoom_in_max := 1.0` The amount the player can zoom in. 1.0 means they cannot zoom in, and anything higher allows zooming in.
- `@export_range(0.001, 1.0, 0.01) zoom_out_max := 0.5` The amount the player can zoom out. 1.0 means they cannot zoom out, and anything lower allows zooming out.
- `controller_zoom_speed: float = 1.0` The speed at which the controller (and keyboard keys) adjust the zoom level.
- `mouse_zoom_step: float = 0.2` The amount the zoom level is changed for every click of the wheel mouse.
- `mouse_zoom_speed: float = 0.1` The amount of time it takes for the mouse wheel zoom animation to play for each zoom step.


## Camera2DShake <img src="/addons/dragonforge_camera_2d/assets/textures/icons/shake.svg" width="32" alt="Cameras Shake Icon"/>
Adding this component to a [Camera2D] allows the user to shake the camera and controller using the component.

### Usage
1. On a **Camera2D** node click **+ Add Child Node...**.
2. Select **Camera2DShake** and click the **Create** button.
3. Select the new **Camera2DShake** node.
4. In the **Inspector** modify the shake properties as you desire.

### Export Variables
- `duration: float = 0.5` The duration in seconds for the screen shake and controller vibration.
- `interval: float = 0.5` The duration in seconds the screen shake stops before starting again when [member is_shaking] is set to `true`.
- `intensity: float = 1.0` The instenseity of the screen shake.
- `@export_range(0.0, 1.0, 0.01) controller_weak_vibration: float = 0.5` The intensity of the controller vibration with the weak motors. (Typically located at the top of the controller.) A value of 0.0 is off. (Hard-coded to only shake the first connected controller.)
- `@export_range(0.0, 1.0, 0.01)  controller_strong_vibration: float = 0.5` The intensity of the controller vibration with the strong motors. (Typically located at the bottom of the controller.) A value of 0.0 is off. (Hard-coded to only shake the first connected controller.)

### Public Functions
- `shake() -> void` Shakes the screen once and vibrates the default controller.
- `start() -> void` Starts continuous shaking.
- `stop() -> void` Stops continuous shaking.
- `shake_screen() -> void` Shakes the screen for the set [member duration] at the [member intensity] set.
- `vibrate_controller(device: int = 0) -> void` Vibrates the connected [member device] (default to the first connected device) for the set [member duration] at the intensity set by [member controller_weak_vibration] and [member controller_strong_vibration]. (Typically controlling the top and bottom vibration motors respectively.)


## Camera2DPan <img src="/addons/dragonforge_camera_2d/assets/textures/icons/pan.svg" width="32" alt="Cameras Shake Icon"/>
Adding this component to a [Camera2D] allows the user to pan the camera using the mouse with edge detection (moving the mouse to the edge of the screen), keyboard, controller, or touch screen.

### Usage
1. On a **Camera2D** node click **+ Add Child Node...**.
2. Select **Camera2DPan** and click the **Create** button.
3. Select the new **Camera2DPan** node.
4. In the **Inspector** modify the panning properties as you desire.

### Export Variables
- `pan_speed := 60.0` The speed of keyboard and controller panning mesured in pixels.
- `touch_pan_speed := 1.0` The speed at which the screen pans when the user drags the screen.
- `edge_scroll_margin := 50.0` The number of pixels at the edge of the acreen that trigger edge scrolling.
- `edge_scroll_speed := 800.0` The number of pixels panned by edge scrolling per second.


## Camera2DPinchZoom <img src="/addons/dragonforge_camera_2d/assets/textures/icons/pinch.svg" width="32" alt="Cameras Zoom Icon"/>
Adding this component to a [Camera2D] allows the user to zoom in and out on a touch screen using pinch zoom. For zoom support with other input methods (mouse wheel, keyboard, or controller), see the [Camera2DZoom] component.

### Usage
1. On a **Camera2D** node click **+ Add Child Node...**.
2. Select **Camera2DPinchZoom** and click the **Create** button.
3. Select the new **Camera2DPinchZoom** node.
4. In the **Inspector** modify the zoom properties as you desire.

### Export Variables
- `@export_range(1.0, 5.0, 0.01) zoom_in_max := 1.0` The amount the player can zoom in. 1.0 means they cannot zoom in, and anything higher allows zooming in.
- `@export_range(0.001, 1.0, 0.01) zoom_out_max := 0.5` The amount the player can zoom out. 1.0 means they cannot zoom out, and anything lower allows zooming out.


# Credits

## Icons
https://www.svgrepo.com/svg/486767/pan
https://www.svgrepo.com/svg/364977/vibrate-fill
https://www.svgrepo.com/svg/501433/add
https://www.svgrepo.com/svg/407206/pinching-hand
https://www.svgrepo.com/svg/479560/zoom-1
https://www.svgrepo.com/svg/513024/video-camera-round-964
