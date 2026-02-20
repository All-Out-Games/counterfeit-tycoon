13
644245094401
1534834140979123 1771539848873895900
{
  "name": "Truck",
  "local_enabled": true,
  "local_position": {
    "Y": -8.5000000000000000
  },
  "local_rotation": 0,
  "local_scale": {
    "X": 1,
    "Y": 1
  },
  "previous_sibling": "1534834140994603:1771539848873903200",
  "next_sibling": "1534834140962146:1771539848873887900",
  "parent": "1534834140835860:1771539848873828500"
},
{
  "cid": 1,
  "aoid": "1534834141420971:1771539848874105100",
  "component_type": "Internal_Component",
  "internal_component_type": "Truck",
  "data": {
    "text": "Deliver To Bank",
    "radius": 1.5000000000000000,
    "required_hold_time": 0.5000000000000000,
    "prompt_offset": {
      "Y": 1
    },
    "move_speed": 200,
    "arrive_radius": 0.0500000007450581,
    "spine_entity": "1534834140987410:1771539848873899800"
  }
},
{
  "cid": 2,
  "aoid": "1534834141430353:1771539848874109500",
  "component_type": "Internal_Component",
  "internal_component_type": "Movement_Agent",
  "data": {
    "lock_to_navmesh": true
  }
},
{
  "cid": 3,
  "aoid": "1534834141438120:1771539848874113200",
  "component_type": "Internal_Component",
  "internal_component_type": "Circle_Collider",
  "data": {
    "is_trigger": true,
    "size": 1,
    "offset": {
      "Y": 0.2500000000000000
    }
  }
}
