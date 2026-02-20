13
326417514497
1534831395279271 1771539847573848300
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
  "previous_sibling": "1534831395292348:1771539847573854500",
  "next_sibling": "1534831395265842:1771539847573841900",
  "parent": "1534831395158124:1771539847573791400"
},
{
  "cid": 1,
  "aoid": "1534831398681025:1771539847575459000",
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
    "spine_entity": "1534831395286105:1771539847573851500"
  }
},
{
  "cid": 2,
  "aoid": "1534831398687193:1771539847575461900",
  "component_type": "Internal_Component",
  "internal_component_type": "Movement_Agent",
  "data": {
    "lock_to_navmesh": true
  }
},
{
  "cid": 3,
  "aoid": "1534831398692194:1771539847575464300",
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
