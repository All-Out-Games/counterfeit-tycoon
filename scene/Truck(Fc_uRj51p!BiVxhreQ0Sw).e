13
210453397505
1534830480170345 1771539847140558000
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
  "previous_sibling": "1534830480181796:1771539847140563400",
  "next_sibling": "1534830480158569:1771539847140552400",
  "parent": "1534830480038930:1771539847140496400"
},
{
  "cid": 1,
  "aoid": "1534830482965896:1771539847141881600",
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
    "spine_entity": "1534830480176300:1771539847140560800"
  }
},
{
  "cid": 2,
  "aoid": "1534830482972111:1771539847141884600",
  "component_type": "Internal_Component",
  "internal_component_type": "Movement_Agent",
  "data": {
    "lock_to_navmesh": true
  }
},
{
  "cid": 3,
  "aoid": "1534830482977281:1771539847141887000",
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
