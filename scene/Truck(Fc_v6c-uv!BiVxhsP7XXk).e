13
438086664193
1534832239967151 1771539847973795300
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
  "previous_sibling": "1534832239979416:1771539847973801100",
  "next_sibling": "1534832239954521:1771539847973789200",
  "parent": "1534832239858748:1771539847973744400"
},
{
  "cid": 1,
  "aoid": "1534832240265933:1771539847973936700",
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
    "spine_entity": "1534832239973228:1771539847973798200"
  }
},
{
  "cid": 2,
  "aoid": "1534832240271790:1771539847973939500",
  "component_type": "Internal_Component",
  "internal_component_type": "Movement_Agent",
  "data": {
    "lock_to_navmesh": true
  }
},
{
  "cid": 3,
  "aoid": "1534832240276412:1771539847973941700",
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
