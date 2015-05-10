-- WARNING: Creeper has incorrect orientation (wrong coordinates used).
-- Poor example at all (no texture coordinates, no bones etc.)

-- Creeper's view
local front_left_leg = {
	x1 = 0, y1 = -3/8, z1 = 0,
	x2 = 2/8, y2 = -1/8, z2 = 3/8
}
local front_right_leg = {
	x1 = -2/8, y1 = -3/8, z1 = 0,
	x2 = 0, y2 = -1/8, z2 = 3/8
}
local back_left_leg = {
	x1 = 0, y1 = 1/8, z1 = 0,
	x2 = 2/8, y2 = 3/8, z2 = 3/8
}
local back_right_leg = {
	x1 = -2/8, y1 = 1/8, z1 = 0,
	x2 = 0, y2 = 3/8, z2 = 3/8
}
local body = {
	x1 = -2/8, y1 = -1/8, z1 = 3/8,
	x2 = 2/8, y2 = 1/8, z2 = 9/8,
}
local head = {
	x1 = -2/8, y1 = -2/8, z1 = 9/8,
	x2 = 2/8, y2 = 2/8, z2 = 13/8
}

return {
--   textures = {
--     default = {
--       file = "creeper.png",
--     },
--   },
--   materials = {
--     default = {
--       textures = {"default"},
--     },
--   },
	root = {
		name = "Cube",
		type = "mesh",
		-- material = "default",
		vertices = {
			front_left_leg_1 = {
				position = {
					x = front_left_leg.x2,
					y = front_left_leg.y2,
					z = front_left_leg.z2,
				},
			},
			front_left_leg_2 = {
				position = {
					x = front_left_leg.x1,
					y = front_left_leg.y2,
					z = front_left_leg.z2,
				},
			},
			front_left_leg_3 = {
				position = {
					x = front_left_leg.x2,
					y = front_left_leg.y1,
					z = front_left_leg.z2,
				},
			},
			front_left_leg_4 = {
				position = {
					x = front_left_leg.x1,
					y = front_left_leg.y1,
					z = front_left_leg.z2,
				},
			},
			front_left_leg_5 = {
				position = {
					x = front_left_leg.x2,
					y = front_left_leg.y2,
					z = front_left_leg.z1,
				},
			},
			front_left_leg_6 = {
				position = {
					x = front_left_leg.x1,
					y = front_left_leg.y2,
					z = front_left_leg.z1,
				},
			},
			front_left_leg_7 = {
				position = {
					x = front_left_leg.x2,
					y = front_left_leg.y1,
					z = front_left_leg.z1,
				},
			},
			front_left_leg_8 = {
				position = {
					x = front_left_leg.x1,
					y = front_left_leg.y1,
					z = front_left_leg.z1,
				},
			},
			front_right_leg_1 = {
				position = {
					x = front_right_leg.x2,
					y = front_right_leg.y2,
					z = front_right_leg.z2,
				},
			},
			front_right_leg_2 = {
				position = {
					x = front_right_leg.x1,
					y = front_right_leg.y2,
					z = front_right_leg.z2,
				},
			},
			front_right_leg_3 = {
				position = {
					x = front_right_leg.x2,
					y = front_right_leg.y1,
					z = front_right_leg.z2,
				},
			},
			front_right_leg_4 = {
				position = {
					x = front_right_leg.x1,
					y = front_right_leg.y1,
					z = front_right_leg.z2,
				},
			},
			front_right_leg_5 = {
				position = {
					x = front_right_leg.x2,
					y = front_right_leg.y2,
					z = front_right_leg.z1,
				},
			},
			front_right_leg_6 = {
				position = {
					x = front_right_leg.x1,
					y = front_right_leg.y2,
					z = front_right_leg.z1,
				},
			},
			front_right_leg_7 = {
				position = {
					x = front_right_leg.x2,
					y = front_right_leg.y1,
					z = front_right_leg.z1,
				},
			},
			front_right_leg_8 = {
				position = {
					x = front_right_leg.x1,
					y = front_right_leg.y1,
					z = front_right_leg.z1,
				},
			},
			back_left_leg_1 = {
				position = {
					x = back_left_leg.x2,
					y = back_left_leg.y2,
					z = back_left_leg.z2,
				},
			},
			back_left_leg_2 = {
				position = {
					x = back_left_leg.x1,
					y = back_left_leg.y2,
					z = back_left_leg.z2,
				},
			},
			back_left_leg_3 = {
				position = {
					x = back_left_leg.x2,
					y = back_left_leg.y1,
					z = back_left_leg.z2,
				},
			},
			back_left_leg_4 = {
				position = {
					x = back_left_leg.x1,
					y = back_left_leg.y1,
					z = back_left_leg.z2,
				},
			},
			back_left_leg_5 = {
				position = {
					x = back_left_leg.x2,
					y = back_left_leg.y2,
					z = back_left_leg.z1,
				},
			},
			back_left_leg_6 = {
				position = {
					x = back_left_leg.x1,
					y = back_left_leg.y2,
					z = back_left_leg.z1,
				},
			},
			back_left_leg_7 = {
				position = {
					x = back_left_leg.x2,
					y = back_left_leg.y1,
					z = back_left_leg.z1,
				},
			},
			back_left_leg_8 = {
				position = {
					x = back_left_leg.x1,
					y = back_left_leg.y1,
					z = back_left_leg.z1,
				},
			},
			back_right_leg_1 = {
				position = {
					x = back_right_leg.x2,
					y = back_right_leg.y2,
					z = back_right_leg.z2,
				},
			},
			back_right_leg_2 = {
				position = {
					x = back_right_leg.x1,
					y = back_right_leg.y2,
					z = back_right_leg.z2,
				},
			},
			back_right_leg_3 = {
				position = {
					x = back_right_leg.x2,
					y = back_right_leg.y1,
					z = back_right_leg.z2,
				},
			},
			back_right_leg_4 = {
				position = {
					x = back_right_leg.x1,
					y = back_right_leg.y1,
					z = back_right_leg.z2,
				},
			},
			back_right_leg_5 = {
				position = {
					x = back_right_leg.x2,
					y = back_right_leg.y2,
					z = back_right_leg.z1,
				},
			},
			back_right_leg_6 = {
				position = {
					x = back_right_leg.x1,
					y = back_right_leg.y2,
					z = back_right_leg.z1,
				},
			},
			back_right_leg_7 = {
				position = {
					x = back_right_leg.x2,
					y = back_right_leg.y1,
					z = back_right_leg.z1,
				},
			},
			back_right_leg_8 = {
				position = {
					x = back_right_leg.x1,
					y = back_right_leg.y1,
					z = back_right_leg.z1,
				},
			},
			body_1 = {
				position = {
					x = body.x2,
					y = body.y2,
					z = body.z2,
				},
			},
			body_2 = {
				position = {
					x = body.x1,
					y = body.y2,
					z = body.z2,
				},
			},
			body_3 = {
				position = {
					x = body.x2,
					y = body.y1,
					z = body.z2,
				},
			},
			body_4 = {
				position = {
					x = body.x1,
					y = body.y1,
					z = body.z2,
				},
			},
			body_5 = {
				position = {
					x = body.x2,
					y = body.y2,
					z = body.z1,
				},
			},
			body_6 = {
				position = {
					x = body.x1,
					y = body.y2,
					z = body.z1,
				},
			},
			body_7 = {
				position = {
					x = body.x2,
					y = body.y1,
					z = body.z1,
				},
			},
			body_8 = {
				position = {
					x = body.x1,
					y = body.y1,
					z = body.z1,
				},
			},
			head_1 = {
				position = {
					x = head.x2,
					y = head.y2,
					z = head.z2,
				},
			},
			head_2 = {
				position = {
					x = head.x1,
					y = head.y2,
					z = head.z2,
				},
			},
			head_3 = {
				position = {
					x = head.x2,
					y = head.y1,
					z = head.z2,
				},
			},
			head_4 = {
				position = {
					x = head.x1,
					y = head.y1,
					z = head.z2,
				},
			},
			head_5 = {
				position = {
					x = head.x2,
					y = head.y2,
					z = head.z1,
				},
			},
			head_6 = {
				position = {
					x = head.x1,
					y = head.y2,
					z = head.z1,
				},
			},
			head_7 = {
				position = {
					x = head.x2,
					y = head.y1,
					z = head.z1,
				},
			},
			head_8 = {
				position = {
					x = head.x1,
					y = head.y1,
					z = head.z1,
				},
			},
		},
		-- this is a table of tables of triangles
		triangles = {{
			-- material = "default",
			triangles = {
				{
					"front_left_leg_1",
					"front_left_leg_2",
					"front_left_leg_4",
					"front_left_leg_3",
				},
				{
					"front_left_leg_1",
					"front_left_leg_3",
					"front_left_leg_7",
					"front_left_leg_5",
				},
				{
					"front_left_leg_1",
					"front_left_leg_5",
					"front_left_leg_6",
					"front_left_leg_2",
				},
				{
					"front_left_leg_8",
					"front_left_leg_6",
					"front_left_leg_5",
					"front_left_leg_7",
				},
				{
					"front_left_leg_8",
					"front_left_leg_7",
					"front_left_leg_3",
					"front_left_leg_4",
				},
				{
					"front_left_leg_8",
					"front_left_leg_4",
					"front_left_leg_2",
					"front_left_leg_6",
				},
				{
					"front_right_leg_1",
					"front_right_leg_2",
					"front_right_leg_4",
					"front_right_leg_3",
				},
				{
					"front_right_leg_1",
					"front_right_leg_3",
					"front_right_leg_7",
					"front_right_leg_5",
				},
				{
					"front_right_leg_1",
					"front_right_leg_5",
					"front_right_leg_6",
					"front_right_leg_2",
				},
				{
					"front_right_leg_8",
					"front_right_leg_6",
					"front_right_leg_5",
					"front_right_leg_7",
				},
				{
					"front_right_leg_8",
					"front_right_leg_7",
					"front_right_leg_3",
					"front_right_leg_4",
				},
				{
					"front_right_leg_8",
					"front_right_leg_4",
					"front_right_leg_2",
					"front_right_leg_6",
				},
				{
					"back_left_leg_1",
					"back_left_leg_2",
					"back_left_leg_4",
					"back_left_leg_3",
				},
				{
					"back_left_leg_1",
					"back_left_leg_3",
					"back_left_leg_7",
					"back_left_leg_5",
				},
				{
					"back_left_leg_1",
					"back_left_leg_5",
					"back_left_leg_6",
					"back_left_leg_2",
				},
				{
					"back_left_leg_8",
					"back_left_leg_6",
					"back_left_leg_5",
					"back_left_leg_7",
				},
				{
					"back_left_leg_8",
					"back_left_leg_7",
					"back_left_leg_3",
					"back_left_leg_4",
				},
				{
					"back_left_leg_8",
					"back_left_leg_4",
					"back_left_leg_2",
					"back_left_leg_6",
				},
				{
					"back_right_leg_1",
					"back_right_leg_2",
					"back_right_leg_4",
					"back_right_leg_3",
				},
				{
					"back_right_leg_1",
					"back_right_leg_3",
					"back_right_leg_7",
					"back_right_leg_5",
				},
				{
					"back_right_leg_1",
					"back_right_leg_5",
					"back_right_leg_6",
					"back_right_leg_2",
				},
				{
					"back_right_leg_8",
					"back_right_leg_6",
					"back_right_leg_5",
					"back_right_leg_7",
				},
				{
					"back_right_leg_8",
					"back_right_leg_7",
					"back_right_leg_3",
					"back_right_leg_4",
				},
				{
					"back_right_leg_8",
					"back_right_leg_4",
					"back_right_leg_2",
					"back_right_leg_6",
				},
				{
					"body_1",
					"body_2",
					"body_4",
					"body_3",
				},
				{
					"body_1",
					"body_3",
					"body_7",
					"body_5",
				},
				{
					"body_1",
					"body_5",
					"body_6",
					"body_2",
				},
				{
					"body_8",
					"body_6",
					"body_5",
					"body_7",
				},
				{
					"body_8",
					"body_7",
					"body_3",
					"body_4",
				},
				{
					"body_8",
					"body_4",
					"body_2",
					"body_6",
				},
				{
					"head_1",
					"head_2",
					"head_4",
					"head_3",
				},
				{
					"head_1",
					"head_3",
					"head_7",
					"head_5",
				},
				{
					"head_1",
					"head_5",
					"head_6",
					"head_2",
				},
				{
					"head_8",
					"head_6",
					"head_5",
					"head_7",
				},
				{
					"head_8",
					"head_7",
					"head_3",
					"head_4",
				},
				{
					"head_8",
					"head_4",
					"head_2",
					"head_6",
				},
			},
		}},
	},
}
