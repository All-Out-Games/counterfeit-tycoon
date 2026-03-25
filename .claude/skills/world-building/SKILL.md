---
name: world-building
description: You MUST reference this before placing, arranging, or decorating anything in the scene
---

# World Building

## Workflow

Orient first (`scene_hierarchy`, `scene_camera (action: "get")`, `scene_screenshot`), then discover assets, then build, screenshotting after each placement to verify.

## Asset Discovery — Local First, Catalog Second

Always exhaust local assets before searching the catalog.

```
asset_local_search (query: "tree")
asset_remote_search (query: "oak tree")        // only for gaps
asset_remote_download (ids: ["id_1", "id_2"])  // batch download
```

## Placing Assets — `instantiate_asset`

Automatically creates the right entity type (Sprite_Renderer for textures, prefab instantiation for prefabs, Spine_Animator for spine rigs).

```
instantiate_asset (asset_id: "environment/tree.png", position: [5, 3], name: "Tree_1", scale: [1.2, 1.2])
instantiate_asset (asset_id: "environment/bush.png", position: [-2, 1], scale: [-1, 1])  // flipped horizontally via negative X scale
```

The response includes `visual_size: [w, h]` — the entity's world-space dimensions accounting for texture size, pixels-per-unit, and scale. Use this to plan layouts.

### Relative Positioning

Place entities edge-to-edge using an anchor entity. The tool calculates exact positions from both entities' visual sizes for seamless tiling.

```
instantiate_asset (asset_id: "environment/road.png", position: [0, 0], name: "Road_1")
instantiate_asset (asset_id: "environment/road.png", relative_to: "Road_1", direction: "right", name: "Road_2")
instantiate_asset (asset_id: "props/crate.png", relative_to: "Crate_1", direction: "above", name: "Crate_2")
instantiate_asset (asset_id: "nature/tree.png", relative_to: "Tree_1", direction: "right", gap: 1.5, name: "Tree_2")
```

- `relative_to` — name of the anchor entity
- `direction` — `"right"`, `"left"`, `"above"`, or `"below"`
- `gap` — extra spacing in world units (default 0)
- When `relative_to` is used, omit `position`.

## Batch Operations — `modify_scene`

Use for complex ops: parenting, setting component properties, multiple changes at once.

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

## Key Sprite_Renderer Fields

- `texture` — asset path
- `layer` — integer draw order (higher renders on top)
- `tint` — `[r, g, b, a]` values 0-1

## Layer Convention

- Ground/terrain: **-10**
- Ground details (grass, flowers): **0**
- Foreground overlaps: **10**

## Verify After Placement

```
scene_camera (action: "focus_area", min: [-10, -5], max: [10, 5])
scene_screenshot
```

When you think you're done, spawn a subagent to give feedback on your work, paying special attention to scale relative to the player and any sublte gaps or misalignments. 