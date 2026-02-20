13
541165879297
1534833190220060 1771539848423725800
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
  "previous_sibling": "1534833190261509:1771539848423745400",
  "next_sibling": "1534833190208224:1771539848423720200",
  "parent": "1534833190116004:1771539848423677000"
},
{
  "cid": 1,
  "aoid": "1534833190621108:1771539848423915700",
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
    "spine_entity": "1534833190226103:1771539848423728700"
  }
},
{
  "cid": 2,
  "aoid": "1534833190628443:1771539848423919100",
  "component_type": "Internal_Component",
  "internal_component_type": "Movement_Agent",
  "data": {
    "lock_to_navmesh": true
  }
},
{
  "cid": 3,
  "aoid": "1534833190633118:1771539848423921300",
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
