local path = minetest.get_modpath(minetest.get_current_modname())

minetest.register_entity("b3d_test:creeper", {
	hp_max = 1,
	physical = true,
	weight = 5,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = b3d.compile("creeper"),
	-- textures = {"creeper.png"},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = true,
})
