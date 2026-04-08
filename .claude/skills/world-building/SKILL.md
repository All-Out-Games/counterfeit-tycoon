---
name: world-building
description: You MUST reference this before placing, arranging, or decorating anything in the scene
---

# World Building

## Workflow
1. Orient (`scene_hierarchy`, `scene_camera (action: "get")`, `editor_scene_screenshot`)
2. Discover assets
3. Instantiate assets
4. Screenshotting regularly verifying world scale is as expected relative to the player and there are no gaps between terrain etc... 

## Asset Discovery
Check local assets if there are any before searching the catalog! 

```
asset_local_search (query: "tree")
asset_remote_search (query: "oak tree")
get_remote_assets_that_work_well_with (catalogId: "abc123")  // critical to use when assets need to fit together well (road pieces, tiles, fences, etc...) also great for ideas to fill in gaps! 
asset_remote_download (catalogIds: ["abc123", "def456"])     // batch download
```

## Placing Assets — `instantiate_assets`

```json
instantiate_assets (assets: [
  {"asset_id": "terrain/grass.png", "position": [0, 0], "name": "Grass_1", "scale": [1.05, 1.05], "layer": -10},
  {"asset_id": "environment/tree.png", "position": [5, 3], "name": "Tree_1", "scale": [1.2, 1.2], "layer": 0},
  {"asset_id": "environment/bush.png", "position": [-2, 1], "scale": [-1, 1], "layer": 10}
])
```

`layer` cheat sheet:
-10: backgrounds, terrain, bases/plots 
0: most things you want to layer with the player (trees, characters, etc)
10: always on top of the player (clouds, hiding bushes etc)

The response includes `visual_size: [w, h]` per item — the entity's world-space dimensions accounting for texture size, pixels-per-unit, and scale. Use this to plan layouts.

### Tiling Workflow
When tiling terrain, grass, roads, etc:
1. Check `worldSize` from the search result to know the tile's default size at scale 1.
2. Compare to the viewport size (`scene_camera (action: "get")` returns `orthographic_size` — viewport is ~2x that tall).
3. Compute the scale needed: e.g. if tile `worldSize` is `[1, 1]` and you need 5-unit tiles, use `scale: [5, 5]`.
4. Use `relative_to` with `direction` to chain tiles without manually computing positions.
5. Slightly overlap tiles (scale up ~5%) to eliminate seam gaps between tiles.

### Relative Positioning
Items in the batch can reference earlier items by name with `relative_to`. Useful for tiling. 

```json
instantiate_assets (assets: [
  {"asset_id": "environment/road.png", "position": [0, 0], "name": "Road_1"},
  {"asset_id": "environment/road.png", "relative_to": "Road_1", "direction": "right", "name": "Road_2"},
  {"asset_id": "props/crate.png", "relative_to": "Crate_1", "direction": "above", "name": "Crate_2"},
  {"asset_id": "nature/tree.png", "relative_to": "Tree_1", "direction": "right", "gap": 1.5, "name": "Tree_2"}
])
```

- `relative_to` — name of the anchor entity (reference earlier items in the same batch and omit position)
- `direction` — `"right"`, `"left"`, `"above"`, or `"below"`
- `gap` — extra spacing in world units (default 0)

## `modify_scene`
Used for parenting, setting component properties, batch changes.

```json
{
  "operations": [
    {
      "kind": "set_component_properties",
      "entity_name": "Tree_1",
      "component_type": "Sprite_Renderer",
      "properties": { "layer": 5 }
    },
    { "kind": "set_parent", "entity_name": "Tree_1", "parent_name": "Forest_Left" },
    { "kind": "create_entity", "name": "Forest_Left" },
    { "kind": "create_entity", "name": "Tree_1", "parent_name": "Forest_Left", "position": [-5, 3] }
  ]
}
```

### `bulk_transform` — batch transform by name query
Rescale, reposition, or rotate many entities at once using fuzzy name matching.

```json
{
  "operations": [{
    "kind": "bulk_transform",
    "targets": { "mode": "name_query", "query": "Grass" },
    "scale_x": { "mode": "set", "value": 5.5 },
    "scale_y": { "mode": "set", "value": 5.5 }
  }]
}
```

Target modes: `name_query` (fuzzy match entity names), `selected` (currently selected entities), `aoids` (explicit AOID list as `[{a:num,b:num}]`).  
Channel modes: `set` (absolute), `delta` (add to current), `random` (add random in `min`..`max` range).  
Available channels: `position_x`, `position_y`, `rotation`, `scale_x`, `scale_y`.

## Verify After Placement

```
scene_camera (action: "focus_area", min: [-10, -5], max: [10, 5])
editor_scene_screenshot
```

When you think you're done, spawn a subagent to give feedback on your work, paying special attention to scale relative to the player and any sublte gaps or misalignments. Often you'll need to slightly scale up tile assets like grass or roads to avoid subtle gaps!! 

You don't want the player to ever see the blue grid editor background! 