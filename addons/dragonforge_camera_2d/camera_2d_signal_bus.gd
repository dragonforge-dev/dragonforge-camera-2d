#Camera2DSignalBus Autoload
extends Node

## Any camera listening can take the passed TimeMapLayer to update itself
## So that nothing outside the used map tiles will be shown.
signal update_camera_boundaries(tile_map_layer: TileMapLayer)
