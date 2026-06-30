---
name: world-building
description: You MUST reference this before placing, arranging, or decorating anything in the scene
---
1. Discover assets (Check local assets if there are any before searching the catalog)
2. Instantiate assets
3. Screenshot regularly verifying world scale is as expected relative to the player and there are no gaps between terrain

```
asset_local_search (query: "tree")
asset_remote_search (query: "oak tree")
get_remote_assets_that_work_well_with (catalogId: "abc123")  // critical to use when assets need to fit together well (road pieces, tiles, fences, etc...)
asset_remote_download (catalogIds: ["abc123", "def456"])
```

## Placing Assets
```json
instantiate_assets (assets: [
  {"assetPath": "terrain/grass.png", "position": [0, 0], "name": "Grass_1", "scale": [5, 5], "tile": true, "layer": -10}, // tile:true repeats over the scale
  {"assetPath": "environment/tree.png", "position": [5, 3], "name": "Tree_1", "scale": [1.5, 1.5], "layer": 0},
  {"assetPath": "environment/bench-and-other-world-props.png", "position": [5, 3], "name": "Bench_1etc", "scale": [1.2, 1.2], "layer": 0},
])
```

For mass placement (e.g. forests of trees, dozens of items) write a script that calls this (or modify_scene) MCP tool programmatically instead of invoking it yourself with every individual item. 

`layer` cheat sheet:
-10: all backgrounds, terrain, bases/plots, tower platforms
0: everything else

The response includes `worldSize: [w, h]` accounting for texture size, pixels-per-unit, and scale. Use this to plan layouts.

### Tiling Workflow
When tiling terrain, grass, roads, etc:
1. Check `worldSize` from the search result to know the tile's default size at scale 1.
2. Compare to the viewport size (`scene_camera (action: "get")` returns `orthographicSize` — viewport is ~2x that tall).
3. For large continuous surfaces, place one texture entity with `tile: true` and scale it to cover the whole area. `tile: true` repeats over the scale. Note $AO/ assets do not support tiling. 
4. Compute the scale needed: If tile `worldSize` is `[1, 1]` and you need a 12x8-unit grass field, use `scale: [12, 8]` with `tile: true`.
5. Use `relativeTo` with `direction` only when placing separate modular pieces that must touch each other, like road segments, fence pieces, or platforms.
6. Slightly overlap separate adjacent entities only when screenshots show gaps; for a single scaled `tile: true` surface, overlap is not needed.

### Relative Positioning
Reference earlier items by name with `relativeTo`. Useful for modular pieces and prop layout, not usually needed for one large tiled terrain surface.

```json
instantiate_assets (assets: [
  {"assetPath": "terrain/grass.png", "position": [0, 0], "scale": [12, 8], "tile": true, "name": "Grass_Field"},
  {"assetPath": "environment/road.png", "position": [0, 0], "scale": [4, 1], "tile": true, "name": "Road_1"},
  {"assetPath": "environment/road.png", "relativeTo": "Road_1", "direction": "right", "scale": [4, 1], "tile": true, "name": "Road_2"},
  {"assetPath": "props/crate.png", "relativeTo": "Crate_1", "direction": "above", "name": "Crate_2"},
  {"assetPath": "nature/tree.png", "relativeTo": "Tree_1", "direction": "right", "gap": 1.5, "name": "Tree_2"}
])
```

`relativeTo` — name of the anchor entity
`direction` — `"right"`, `"left"`, `"above"`, or `"below"`
`gap` — extra spacing in world units (default 0)

## `modify_scene`
Parenting, setting component properties, batch changes.

Editor JSON component properties use the native/editor names returned by `get_available_components`. In CSL scripts, use the CSL API names instead; for example `Sprite_Renderer.color`, not `Sprite_Renderer.tint`.

```json
{
  "operations": [
    {
      "kind": "setComponentProperties",
      "entityName": "Tree_1",
      "componentType": "Sprite_Renderer",
      "properties": { "layer": 0 }
    },
    { "kind": "setParent", "entityName": "Tree_1", "parentName": "Forest_Left" },
    { "kind": "createEntity", "name": "Forest_Left" },
    { "kind": "createEntity", "name": "Tree_1", "parentName": "Forest_Left", "position": [-5, 3] }
  ]
}
```

### `bulkTransform`
```json
{
  "operations": [{
    "kind": "bulkTransform",
    "targets": { "mode": "nameQuery", "query": "Grass" },
    "scaleX": { "mode": "set", "value": 5.5 },
    "scaleY": { "mode": "set", "value": 5.5 }
  }]
}
```

Target modes: `nameQuery` (fuzzy match entity names), `selected` (currently selected entities), `aoids` (explicit AOID list as `[{a:num,b:num}]`).  
Channel modes: `set`, `delta`, `random` (add random in `min`..`max` range).  
Available channels: `positionX`, `positionY`, `rotation`, `scaleX`, `scaleY`.

## `scene_camera`
```
scene_camera (action: "get")
scene_camera (action: "moveTo", position: [5, 0], orthographicSize: 8)
scene_camera (action: "focusEntity", entityName: "Tree_1")
scene_camera (action: "focusArea", min: [-10, -5], max: [10, 5])
```


## You Must Verify After Every Placement
```
scene_camera (action: "focusArea", min: [-10, -5], max: [10, 5])
editor_scene_screenshot (includePlayerForScale: true)
```
Note: If you take screenshots and see big colored triangle overlays you probably need to disable navmesh debug on an entity.  

After each placement ask yourself:
- Is this object in an appropriate place? Don't place trees on water, don't place tower defense towers on the path enemies will walk on. Look CAREFULLY. 
- Is this object an appropriate size relative to other objects of that type and to the player? 
- Is this object set to the correct layer given its role in the game? 
- Is this object oriented correctly? Be careful about flipping signs or objects and make sure nothing is upside down or facing the wrong way.  

When you think you're done, spawn a subagent to give feedback on your work, paying special attention to scale relative to the player and any subtle gaps or misalignments.

DO NOT scatter random assets across the scene to "make it look polished". Every entity must serve a clear purpose and be cohesive with the rest of the scene. Prefer adding large, clear landmarks. 
