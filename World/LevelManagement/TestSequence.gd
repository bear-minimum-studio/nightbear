extends "res://World/LevelManagement/SequenceElement.gd"

func init(father_worlds: Array) -> void:
	var element_description = {
		"type": ElementType.Sequence,
		"subsequence": [
			{
				"type": ElementType.Sequence,
				"subsequence": [
					{
						"type": ElementType.Burst,
						"spawn_type": Projectile.ProjectyleType.Ally,
						"spawn_parameters": {"speed": 100.0},
						"world_indexes": [0],
						"spawn_delay": 1.0,
						"next_delay": 3.0,
						"duration": 1.0,
						"sides": [SpawnHandler.Sides.Left],
					},
					{
						"type": ElementType.Burst,
						"spawn_type": Projectile.ProjectyleType.Ennemy,
						"spawn_parameters": {"speed": 100.0},
						"world_indexes": [0, 1],
						"spawn_delay": 1.0,
						"next_delay": 1.0,
						"duration": 3.0,
						"sides": [SpawnHandler.Sides.Left],
					}
				],
			},
			{
				"type": ElementType.Sequence,
				"subsequence": [],
			},
			{
				"type": ElementType.Sequence,
				"subsequence": [
					{
						"type": ElementType.Sequence,
						"subsequence": [],
					},
					{
						"type": ElementType.Sequence,
					}
				],
			},
		],
	}
	initialize("0", element_description, null, father_worlds)

func end() -> void:
	print("Element %s stopped." % id)