-- my path
local path = minetest.get_modpath(minetest.get_current_modname())
local float2int = dofile(path .. "/float2int.lua")
local prepared_model
local fh
local pos_stack
local pos_queue

local texture_blend_types = {
	none = 0,
	alpha = 1,
	multiply = 2,
	add = 3,
	dot3 = 4,
	multiply2 = 5,
}

local material_blend_types = {
	normal = 1,
	average = 2,
	add = 3,
}

local function push(tag)
	assert(fh:write(tag))
	local pos = assert(fh:seek("cur", 4))
	table.insert(pos_stack, pos)
end

local function pop()
	local pos = table.remove(pos_stack)
	assert(pos, "Position stack underflow")
	local pos2 = assert(fh:seek())
	table.insert(pos_queue, {
		pos = pos - 4,
		value = pos2 - pos
	})
end

local function write_byte(value)
	assert(fh:write(string.char(bit.band(value, 255))))
end

local function write_short(value)
	write_byte(value)
	write_byte(bit.arshift(value, 8))
end

local function write_int(value)
	write_short(value)
	write_short(bit.arshift(value, 16))
end

local function write_float(value)
	write_int(assert(float2int(value)))
end

local function write_string(value)
	assert(fh:write(value .. "\0"))
end

local function write_node(node)
	push("NODE")
	write_string(node.name)

	if node.position ~= nil then
		if node.position.x ~= nil then
			write_float(node.position.x)
		else
			write_int(0) -- write_float(0)
		end
		if node.position.y ~= nil then
			write_float(node.position.y)
		else
			write_int(0) -- write_float(0)
		end
		if node.position.z ~= nil then
			write_float(node.position.z)
		else
			write_int(0) -- write_float(0)
		end
	else
		write_int(0) -- write_float(0)
		write_int(0) -- write_float(0)
		write_int(0) -- write_float(0)
	end

	if node.scale ~= nil then
		if node.scale.x ~= nil then
			write_float(node.scale.x)
		else
			write_int(0x3F800000) -- write_float(1)
		end
		if node.scale.y ~= nil then
			write_float(node.scale.y)
		else
			write_int(0x3F800000) -- write_float(1)
		end
		if node.scale.z ~= nil then
			write_float(node.scale.z)
		else
			write_int(0x3F800000) -- write_float(1)
		end
	else
		write_int(0x3F800000) -- write_float(1)
		write_int(0x3F800000) -- write_float(1)
		write_int(0x3F800000) -- write_float(1)
	end

	if node.rotation ~= nil then
		if node.rotation.w ~= nil then
			write_float(node.rotation.w)
		else
			write_int(0x3F800000) -- write_float(1)
		end
		if node.rotation.x ~= nil then
			write_float(node.rotation.x)
		else
			write_int(0) -- write_float(0)
		end
		if node.rotation.y ~= nil then
			write_float(node.rotation.y)
		else
			write_int(0) -- write_float(0)
		end
		if node.rotation.z ~= nil then
			write_float(node.rotation.z)
		else
			write_int(0) -- write_float(0)
		end
	else
		write_int(0x3F800000) -- write_float(1)
		write_int(0) -- write_float(0)
		write_int(0) -- write_float(0)
		write_int(0) -- write_float(0)
	end

	if node.type == "mesh" then
		push("MESH")

		if node.material ~= nil then
			write_int(node.material)
		else
			write_int(-1)
		end

		local normal = false
		local color = false
		local tex_coord_sets = 0      -- max 8
		local tex_coord_set_size = 0  -- max 4

		for k_vert, v_vert in ipairs(node.vertices) do
			if v_vert.normal ~= nil then
				normal = true
			end
			if v_vert.color ~= nil then
				color = true
			end

			if v_vert.tex_coords ~= nil then
				if #v_vert.tex_coords > tex_coord_sets then
					tex_coord_sets = #v_vert.tex_coords
				end

				for k_coord, v_coord in ipairs(v_vert.tex_coords) do
					if #v_coord > tex_coord_set_size then
						tex_coord_set_size = #v_coord
					end
				end
			end
		end

		local flags = 0

		if normal then
			flags = flags + 1
		end
		if color then
			flags = flags + 2
		end

		push("VRTS")
		write_int(flags)
		write_int(tex_coord_sets)
		write_int(tex_coord_set_size)

		local tex_coord_empty = tex_coord_sets * tex_coord_set_size

		tex_coord_sets = tex_coord_sets - 1
		tex_coord_set_size = tex_coord_set_size - 1

		for k_vert, v_vert in ipairs(node.vertices) do
			write_float(v_vert.position.x)
			write_float(v_vert.position.y)
			write_float(v_vert.position.z)

			if normal then
				if v_vert.normal ~= nil then
					write_float(v_vert.normal.x)
					write_float(v_vert.normal.y)
					write_float(v_vert.normal.z)
				else
					write_int(0) -- write_float(0)
					write_int(0) -- write_float(0)
					write_int(0) -- write_float(0)
				end
			end

			if color then
				if v_vert.color ~= nil then
					write_float(v_vert.color.red)
					write_float(v_vert.color.green)
					write_float(v_vert.color.blue)

					if v_vert.color.alpha ~= nil then
						write_float(v_vert.color.alpha)
					else
						write_int(0x3F800000) -- write_float(1)
					end
				else
					write_int(0x3F800000) -- write_float(1)
					write_int(0x3F800000) -- write_float(1)
					write_int(0x3F800000) -- write_float(1)
					write_int(0x3F800000) -- write_float(1)
				end
			end

			if v_vert.tex_coords ~= nil then
				for k_coord, v_coord in ipairs(v_vert.tex_coords) do
					for k, v in ipairs(v_coord) do
						write_float(v)
					end

					for i = #v_coord, tex_coord_set_size do
						write_float(0)
					end
				end

				for i = #v_vert.tex_coords, tex_coord_sets do
					write_float(0)
				end
			else
				for i = 1, tex_coord_empty do
					write_int(0)
				end
			end
		end

		pop()

		if node.triangles ~= nil then
			for k_tris, v_tris in ipairs(node.triangles) do
				push("TRIS")
				if v_tris.material ~= nil then
					write_int(v_tris.material)
				else
					write_int(-1)
				end
				for k_tri, v_tri in ipairs(v_tris.triangles) do
					for k_vert, v_vert in ipairs(v_tri) do
						write_int(v_vert)
					end
				end
				pop()
			end
		end

		pop()
	elseif node.type == "bone" then
		push("BONE")
		if node.vertices ~= nil then
			for k_vert, v_vert in ipairs(node.vertices) do
				write_int(v_vert.vertex)

				if v_vert.weight ~= nil then
					write_float(v_vert.weight)
				else
					write_int(0x3F800000) -- write_float(1)
				end
			end
		end
		pop()
	end

	if node.animation ~= nil then
		push("ANIM")
		write_int(0) -- flags, unused
		write_int(node.animation.frames)

		if node.animation.fps ~= nil then
			write_float(node.animation.fps)
		else
			write_int(0x42700000) -- write_float(60)
		end

		pop()
	end

	if node.keys ~= nil then
		for k_keys, v_keys in pairs(node.keys) do
			local position = false
			local scale = false
			local rotation = false

			for k_key, v_key in pairs(v_keys) do
				if v_key.position ~= nil then
					position = true
				end
				if v_key.scale ~= nil then
					scale = true
				end
				if v_key.rotation ~= nil then
					rotation = true
				end
			end

			local flags = 0

			if position then
				flags = flags + 1
			end
			if scale then
				flags = flags + 2
			end
			if rotation then
				flags = flags + 4
			end

			push("KEYS")
			write_int(flags)

			for k_key, v_key in pairs(v_keys) do
				write_int(v_key.frame)

				if position then
					if v_key.position ~= nil then
						if v_key.position.x ~= nil then
							write_float(v_key.position.x)
						else
							write_int(0) -- write_float(0)
						end
						if v_key.position.y ~= nil then
							write_float(v_key.position.y)
						else
							write_int(0) -- write_float(0)
						end
						if v_key.position.z ~= nil then
							write_float(v_key.position.z)
						else
							write_int(0) -- write_float(0)
						end
					else
						write_int(0) -- write_float(0)
						write_int(0) -- write_float(0)
						write_int(0) -- write_float(0)
					end
				end

				if scale then
					if v_key.scale ~= nil then
						if v_key.scale.x ~= nil then
							write_float(v_key.scale.x)
						else
							write_int(0x3F800000) -- write_float(1)
						end
						if v_key.scale.y ~= nil then
							write_float(v_key.scale.y)
						else
							write_int(0x3F800000) -- write_float(1)
						end
						if v_key.scale.z ~= nil then
							write_float(v_key.scale.z)
						else
							write_int(0x3F800000) -- write_float(1)
						end
					else
						write_int(0x3F800000) -- write_float(1)
						write_int(0x3F800000) -- write_float(1)
						write_int(0x3F800000) -- write_float(1)
					end
				end

				if rotation then
					if v_key.rotation ~= nil then
						if v_key.rotation.w ~= nil then
							write_float(v_key.rotation.w)
						else
							write_int(0x3F800000) -- write_float(1)
						end
						if v_key.rotation.x ~= nil then
							write_float(v_key.rotation.x)
						else
							write_int(0) -- write_float(0)
						end
						if v_key.rotation.y ~= nil then
							write_float(v_key.rotation.y)
						else
							write_int(0) -- write_float(0)
						end
						if v_key.rotation.z ~= nil then
							write_float(v_key.rotation.z)
						else
							write_int(0)
						end
					else
						write_int(0x3F800000) -- write_float(1)
						write_int(0) -- write_float(0)
						write_int(0) -- write_float(0)
						write_int(0) -- write_float(0)
					end
				end
			end

			pop()
		end
	end

	if node.nodes ~= nil then
		for _, subnode in ipairs(node.nodes) do
			write_node(subnode)
		end
	end

	pop()
end

local function write_model()

	if false then
		fh:write(dump(prepared_model))
		return
	end

	---

	pos_stack = {}
	pos_queue = {}

	push("BB3D")
	write_int(1) -- version

	-- START --

	if prepared_model.textures ~= nil then
		push("TEXS")

		for k_tex, v_tex in ipairs(prepared_model.textures) do
			write_string(v_tex.file)
			write_int(v_tex.flags)

			if v_tex.blend ~= nil then
				write_int(v_tex.blend)
			else
				write_int(2)
			end

			if v_tex.position ~= nil then
				if v_tex.position.x ~= nil then
					write_float(v_tex.position.x)
				else
					write_int(0) -- write_float(0)
				end
				if v_tex.position.y ~= nil then
					write_float(v_tex.position.y)
				else
					write_int(0) -- write_float(0)
				end
			else
				write_int(0) -- write_float(0)
				write_int(0) -- write_float(0)
			end

			if v_tex.scale ~= nil then
				if v_tex.scale.x ~= nil then
					write_float(v_tex.scale.x)
				else
					write_int(0x3F800000) -- write_float(1)
				end
				if v_tex.scale.y ~= nil then
					write_float(v_tex.scale.y)
				else
					write_int(0x3F800000) -- write_float(1)
				end
			else
				write_int(0x3F800000) -- write_float(1)
				write_int(0x3F800000) -- write_float(1)
			end

			if v_tex.rotation ~= nil then
				write_float(v_tex.rotation)
			else
				write_int(0) -- write_float(0)
			end
		end

		pop()
	end

	if prepared_model.materials ~= nil then
		push("BRUS")

		local max_textures = 0

		for k_mat, v_mat in ipairs(prepared_model.materials) do
			if v_mat.textures ~= nil then
				if #v_mat.textures > max_textures then
					max_textures = #v_mat.textures
				end
			end
		end

		write_int(max_textures)

		max_textures = max_textures - 1

		for k_mat, v_mat in ipairs(prepared_model.materials) do
			write_string(v_mat.name)

			if v_mat.color ~= nil then
				write_float(v_mat.color.red)
				write_float(v_mat.color.green)
				write_float(v_mat.color.blue)
				if v_mat.color.alpha ~= nil then
					write_float(v_mat.color.alpha)
				else
					write_int(0x3F800000) -- write_float(1)
				end
			else
				write_int(0x3F800000) -- write_float(1)
				write_int(0x3F800000) -- write_float(1)
				write_int(0x3F800000) -- write_float(1)
				write_int(0x3F800000) -- write_float(1)
			end

			if v_mat.shiness ~= nil then
				write_float(v_mat.shiness)
			else
				write_int(0)
			end

			if v_mat.blend ~= nil then
				write_int(v_mat.blend)
			else
				write_int(1)
			end

			write_int(v_mat.flags)

			if v_mat.textures ~= nil then
				for k_tex, v_tex in ipairs(v_mat.textures) do
					write_int(v_tex)
				end

				for i = #v_mat.textures, max_textures do
					write_int(-1)
				end
			else
				for i = 0, max_textures do
					write_int(-1)
				end
			end
		end

		pop()
	end

	if prepared_model.nodes ~= nil then
		for k_node, v_node in ipairs(prepared_model.nodes) do
			write_node(v_node)
		end
	end
	-- FINISH --

	pop()

	if #pos_stack ~= 0 then
		error("Position stack still contains elements")
	end

	table.sort(pos_queue, function(a, b)
		return a.pos < b.pos
	end)

	for _, v in ipairs(pos_queue) do
		assert(fh:seek("set", v.pos))
		write_int(v.value)
	end
end

b3d = {
	load = function (name)
		return b3d.compile(name, true)
	end,

	compile = function (name, noforce)
		-- caller path
		local path = minetest.get_modpath(minetest.get_current_modname()) .. '/models/' .. name

		if not file_exists(path .. '.b3d') or not noforce then
			local model = dofile(path .. '.lua')

			assert(type(model) == "table") -- model must be a table

			prepared_model = {}

			-- name-to-index mappings
			local id_textures = {}
			local id_materials = {}
			local id

			if model.textures ~= nil then
				assert(type(model.textures) == "table")

				prepared_model.textures = {}

				id = 0

				for k_tex, v_tex in pairs(model.textures) do
					assert(type(v_tex) == "table")
					assert(type(v_tex.file) == "string")

					id_textures[k_tex] = id
					id = id + 1

					local texture = {
						file = v_tex.file,
						flags = 1,
					}

					if v_tex.color ~= nil then
						assert(type(v_tex.color) == "boolean")
						if not v_tex.color then
							texture.flags = texture.flags - 1
						end
					end

					if v_tex.alpha ~= nil then
						assert(type(v_tex.alpha) == "boolean")
						if v_tex.alpha then
							texture.flags = texture.flags + 2
						end
					end

					if v_tex.masked ~= nil then
						assert(type(v_tex.masked) == "boolean")
						if v_tex.masked then
							texture.flags = texture.flags + 4
						end
					end

					if v_tex.create_mipmaps ~= nil then
						assert(type(v_tex.create_mipmaps) == "boolean")
						if v_tex.create_mipmaps then
							texture.flags = texture.flags + 8
						end
					end

					if v_tex.clamp_u ~= nil then
						assert(type(v_tex.clamp_u) == "boolean")
						if v_tex.clamp_u then
							texture.flags = texture.flags + 16
						end
					end

					if v_tex.clamp_v ~= nil then
						assert(type(v_tex.clamp_v) == "boolean")
						if v_tex.clamp_v then
							texture.flags = texture.flags + 32
						end
					end

					if v_tex.spherical_env_map ~= nil then
						assert(type(v_tex.spherical_env_map) == "boolean")
						if v_tex.spherical_env_map then
							texture.flags = texture.flags + 64
						end
					end

					if v_tex.cubic_env_map ~= nil then
						assert(type(v_tex.cubic_env_map) == "boolean")
						if v_tex.cubic_env_map then
							texture.flags = texture.flags + 128
						end
					end

					if v_tex.store_in_vram ~= nil then
						assert(type(v_tex.store_in_vram) == "boolean")
						if v_tex.store_in_vram then
							texture.flags = texture.flags + 256
						end
					end

					if v_tex.force_high_color ~= nil then
						assert(type(v_tex.force_high_color) == "boolean")
						if v_tex.force_high_color then
							texture.flags = texture.flags + 512
						end
					end

					if v_tex.use_secondary_uv ~= nil then
						assert(type(v_tex.use_secondary_uv) == "boolean")
						if v_tex.use_secondary_uv then
							texture.flags = texture.flags + 65536
						end
					end

					if v_tex.blend ~= nil then
						local t = type(v_tex.blend)
						if t == "string" then
							texture.blend = texture_blend_types[v_tex.blend]
							if texture.blend == nil then
								error("Unknown TextureBlend: " .. v_tex.blend)
							end
						elseif t == "number" then
							texture.blend = v_tex.blend
						else
							error("String or number expected")
						end
					end

					if v_tex.position ~= nil then
						assert(type(v_tex.position) == "table")
						if v_tex.position.x ~= nil then
							assert(type(v_tex.position.x) == "number")
						end
						if v_tex.position.y ~= nil then
							assert(type(v_tex.position.y) == "number")
						end
						texture.position = v_tex.position
					end

					if v_tex.scale ~= nil then
						assert(type(v_tex.scale) == "table")
						if v_tex.scale.x ~= nil then
							assert(type(v_tex.scale.x) == "number")
						end
						if v_tex.scale.y ~= nil then
							assert(type(v_tex.scale.y) == "number")
						end
						texture.scale = v_tex.scale
					end

					if v_tex.rotation ~= nil then
						assert(type(v_tex.rotation) == "number")
						texture.rotation = v_tex.rotation
					end

					table.insert(prepared_model.textures, texture)
				end
			end

			if model.materials ~= nil then
				assert(type(model.materials) == "table")

				prepared_model.materials = {}

				id = 0

				for k_mat, v_mat in pairs(model.materials) do
					assert(type(v_mat) == "table")

					id_materials[k_mat] = id
					id = id + 1

					local material = {
						flags = 0,
					}

					if v_mat.name ~= nil then
						assert(type(v_mat.name) == "string")
						material.name = v_mat.name
					else
						material.name = k_mat
					end

					if v_mat.color ~= nil then
						assert(type(v_mat.color) == "table")
						assert(type(v_mat.color.red) == "number")
						assert(type(v_mat.color.green) == "number")
						assert(type(v_mat.color.blue) == "number")

						if v_mat.color.alpha ~= nil then
							assert(type(v_mat.color.alpha) == "number")
						end

						material.color = v_mat.color
					end

					if v_mat.shiness ~= nil then
						assert(type(v_mat.shiness) == "number")
						material.shiness = v_mat.shiness
					end

					if v_mat.blend ~= nil then
						local t = type(v_mat.blend)
						if t == "string" then
							material.blend = material_blend_types[v_mat.blend]
							if material.blend == nil then
								error("Unknown BrushBlend: " .. v_mat.blend)
							end
						elseif t == "number" then
							material.blend = v_mat.blend
						else
							error("String or number expected")
						end
					end

					if v_mat.full_bright ~= nil then
						assert(type(v_mat.full_bright) == "boolean")
						if v_mat.full_bright then
							material.flags = material.flags + 1
						end
					end

					if v_mat.use_vertex_colors ~= nil then
						assert(type(v_mat.use_vertex_colors) == "boolean")
						if v_mat.use_vertex_colors then
							material.flags = material.flags + 2
						end
					end

					if v_mat.flat_shaded ~= nil then
						assert(type(v_mat.flat_shaded) == "boolean")
						if v_mat.flat_shaded then
							material.flags = material.flags + 4
						end
					end

					if v_mat.disable_fog_effect ~= nil then
						assert(type(v_mat.disable_fog_effect) == "boolean")
						if v_mat.disable_fog_effect then
							material.flags = material.flags + 8
						end
					end

					if v_mat.disable_backface_culling ~= nil then
						assert(type(v_mat.disable_backface_culling) == "boolean")
						if v_mat.disable_backface_culling then
							material.flags = material.flags + 16
						end
					end

					if v_mat.force_vertex_alpha_blend ~= nil then
						assert(type(v_mat.force_vertex_alpha_blend) == "boolean")
						if v_mat.force_vertex_alpha_blend then
							material.flags = material.flags + 32
						end
					end

					if v_mat.textures ~= nil then
						assert(type(v_mat.textures) == "table")
						material.textures = {}
						for k_tex, v_tex in pairs(v_mat.textures) do
							local t = type(v_tex)
							local texture

							if t == "string" then
								texture = id_textures[v_tex]
								if texture == nil then
									error("Texture not registered: " .. v_tex)
								end
							elseif t == "number" then
								texture = v_tex
							else
								error("String or number expected")
							end

							table.insert(material.textures, texture)
						end
					end

					table.insert(prepared_model.materials, material)
				end
			end

			if model.root ~= nil then
				prepared_model.nodes = {}

				local stack = {}
				local current = {input = {model.root}, output = prepared_model.nodes}

				repeat
					assert(type(current.input) == "table")

					for k_node, v_node in pairs(current.input) do
						assert(type(v_node) == "table")
						assert(type(v_node.type) == "string")
						assert(v_node.type == "mesh" or v_node.type == "bone")

						local node = {type = v_node.type}

						if v_node.name ~= nil then
							assert(type(v_node.name) == "string")
							node.name = v_node.name
						else
							node.name = k_node
						end

						if v_node.position ~= nil then
							assert(type(v_node.position) == "table")
							node.position = {}
							if v_node.position.x ~= nil then
								assert(type(v_node.position.x) == "number")
							end
							if v_node.position.y ~= nil then
								assert(type(v_node.position.y) == "number")
							end
							if v_node.position.z ~= nil then
								assert(type(v_node.position.z) == "number")
							end
							node.position = v_node.position
						end

						if v_node.scale ~= nil then
							assert(type(v_node.scale) == "table")
							if v_node.scale.x ~= nil then
								assert(type(v_node.scale.x) == "number")
							end
							if v_node.scale.y ~= nil then
								assert(type(v_node.scale.y) == "number")
							end
							if v_node.scale.z ~= nil then
								assert(type(v_node.scale.z) == "number")
							end
							node.scale = v_node.scale
						end

						if v_node.rotation ~= nil then
							assert(type(v_node.rotation) == "table")
							if v_node.rotation.w ~= nil then
								assert(type(v_node.rotation.w) == "number")
							end
							if v_node.rotation.x ~= nil then
								assert(type(v_node.rotation.x) == "number")
							end
							if v_node.rotation.y ~= nil then
								assert(type(v_node.rotation.y) == "number")
							end
							if v_node.rotation.z ~= nil then
								assert(type(v_node.rotation.z) == "number")
							end
							node.rotation = v_node.rotation
						end

						local id_vertices = current.vertices

						if v_node.type == "mesh" then
							if v_node.material ~= nil then
								local t = type(v_node.material)
								if t == "string" then
									node.material = id_materials[v_node.material]
									if node.material == nil then
										error("Material not registered: " .. v_node.material)
									end
								elseif t == "number" then
									node.material = v_node.material
								else
									error("String or number expected")
								end
							end

							assert(type(v_node.vertices) == "table")

							node.vertices = {}

							id_vertices = {}

							id = 0

							for k_vert, v_vert in pairs(v_node.vertices) do
								assert(type(v_vert) == "table")
								assert(type(v_vert.position) == "table")
								assert(type(v_vert.position.x) == "number")
								assert(type(v_vert.position.y) == "number")
								assert(type(v_vert.position.z) == "number")

								if v_vert.normal ~= nil then
									assert(type(v_vert.normal) == "table")
									assert(type(v_vert.normal.x) == "number")
									assert(type(v_vert.normal.y) == "number")
									assert(type(v_vert.normal.z) == "number")
								end

								if v_vert.color ~= nil then
									assert(type(v_vert.color) == "table")
									assert(type(v_vert.color.red) == "number")
									assert(type(v_vert.color.green) == "number")
									assert(type(v_vert.color.blue) == "number")

									if v_vert.color.alpha ~= nil then
										assert(type(v_vert.color.alpha) == "number")
									end
								end

								if v_vert.tex_coords ~= nil then
									assert(type(v_vert.tex_coords) == "table")

									for k_coord, v_coord in pairs(v_vert.tex_coords) do
										assert(type(v_coord) == "table")

										for k, v in pairs(v_coord) do
											assert(type(v) == "number")
										end
									end
								end

								table.insert(node.vertices, v_vert)

								id_vertices[k_vert] = id
								id = id + 1
							end

							if v_node.triangles ~= nil then
								assert(type(v_node.triangles) == "table")

								node.triangles = {}

								for k_tris, v_tris in pairs(v_node.triangles) do
									local tris = {}

									if v_tris.material ~= nil then
										local t = type(v_tris.material)

										if t == "string" then
											tris.material = id_materials[v_tris.material]
											if tris.material == nil then
												error("Material not registered: " .. v_tris.material)
											end
										elseif t == "number" then
											tris.material = v_tris.material
										else
											error("String or number expected")
										end
									end

									if v_tris.triangles ~= nil then
										assert(type(v_tris.triangles) == "table")

										tris.triangles = {}

										for k_tri, v_tri in pairs(v_tris.triangles) do
											assert(type(v_tri) == "table")

											local main
											local last

											for k_vert, v_vert in ipairs(v_tri) do
												local t = type(v_vert)
												local vert

												if t == "string" then
													vert = id_vertices[v_vert]
													if vert == nil then
														error("Vertex not registered: " .. v_vert)
													end
												elseif t == "number" then
													vert = v_vert
												else
													error("String or number expected")
												end

												if last ~= nil then
													table.insert(tris.triangles, {main, last, vert})
													last = vert
												elseif main ~= nil then
													last = vert
												else
													main = vert
												end
											end

											assert(#tris.triangles)
										end
									end

									table.insert(node.triangles, tris)
								end
							end
						elseif v_node.type == "bone" then
							if v_node.vertices ~= nil then
								assert(type(v_node.vertices) == "table")

								node.vertices = {}

								for k_vert, v_vert in pairs(v_node.vertices) do
									assert(type(v_vert) == "table")

									local vert = {}

									if v_vert.vertex ~= nil then
										local t = type(v_vert.vertex)
										if t == "string" then
											vert.vertex = id_vertices[v_vert.vertex]
											if vert.vertex == nil then
												error("Vertex not recognized: " .. v_vert.vertex)
											end
										elseif t == "number" then
											vert.vertex = v_vert.vertex
										else
											error("String or number expected")
										end
									else
										vert.vertex = id_vertices[k_vert]
										if vert.vertex == nil then
											error("Vertex not recognized: " .. k_vert)
										end
									end

									if v_vert.weight ~= nil then
										assert(type(v_vert.weight) == "number")
										vert.weight = v_vert.weight
									end

									table.insert(node.vertices, vert)
								end
							end
						end

						if v_node.animation ~= nil then
							assert(type(v_node.animation) == "table")
							assert(type(v_node.animation.frames) == "number")

							node.animation = {frames = v_node.animation.frames}

							if v_node.animation.fps ~= nil then
								assert(type(v_node.animation.fps) == "number")
								node.animation.fps = v_node.animation.fps
							end
						end

						if v_node.keys ~= nil then
							assert(type(v_node.keys) == "table")

							for k_keys, v_keys in pairs(v_node.keys) do
								assert(type(v_keys) == "table")

								for k_key, v_key in pairs(v_keys) do
									assert(type(v_key) == "table")
									assert(type(v_key.frame) == "number")

									if v_key.position ~= nil then
										assert(type(v_key.position) == "table")

										if v_key.position.x ~= nil then
											assert(type(v_key.position.x) == "number")
										end

										if v_key.position.y ~= nil then
											assert(type(v_key.position.y) == "number")
										end

										if v_key.position.z ~= nil then
											assert(type(v_key.position.z) == "number")
										end
									end

									if v_key.scale ~= nil then
										assert(type(v_key.scale) == "table")

										if v_key.scale.x ~= nil then
											assert(type(v_key.scale.x) == "number")
										end

										if v_key.scale.y ~= nil then
											assert(type(v_key.scale.y) == "number")
										end

										if v_key.scale.z ~= nil then
											assert(type(v_key.scale.z) == "number")
										end
									end

									if v_key.rotation ~= nil then
										assert(type(v_key.rotation) == "table")

										if v_key.rotation.w ~= nil then
											assert(type(v_key.rotation.w) == "number")
										end

										if v_key.rotation.x ~= nil then
											assert(type(v_key.rotation.x) == "number")
										end

										if v_key.rotation.y ~= nil then
											assert(type(v_key.rotation.y) == "number")
										end

										if v_key.rotation.z ~= nil then
											assert(type(v_key.rotation.z) == "number")
										end
									end
								end
							end

							node.keys = v_node.keys
						end

						table.insert(current.output, node)

						if v_node.nodes ~= nil then
							node.nodes = {}
							table.insert(stack, {input = v_node.nodes, output = node.nodes, vertices = id_vertices})
						end
					end -- for k_node, v_node = pairs(current.input) do

					current = table.remove(stack)
				until current == nil -- repeat
			end -- if model.nodes ~= nil then

			fh = assert(io.open(path .. '.b3d', 'wb'))

			-- try
				local status, err = pcall(write_model)
			-- finally
				fh:close()
				fh = nil
				prepared_model = nil
				pos_stack = nil
				pos_queue = nil
			-- catch
				if not status then
					os.remove(path .. '.b3d')
					error(err)
				end
			-- end try
		end

		return name .. '.b3d'
	end
}
