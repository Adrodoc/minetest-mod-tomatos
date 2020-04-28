local path = minetest.get_modpath(minetest.get_current_modname())

minetest.register_craftitem('tomatos:tomato_seeds', {
  description = 'Tomato Seeds',
  inventory_image = 'tomatoseedItem.png',
  node_placement_prediction = 'tomatos:tomato_crop_0',
  on_place = function(itemstack, placer, pointed_thing)
    local tomato_crop = ItemStack({name="tomatos:tomato_crop_0", count=itemstack:get_count(), wear=0, metadata=""})
    local result = minetest.item_place(tomato_crop, placer, pointed_thing)
    local result_count = result:get_count()
    itemstack:set_count(result_count)
    return itemstack
  end,
})

minetest.register_craftitem('tomatos:tomato', {
  description = 'Tomato',
  inventory_image = 'tomatoItem.png',
})

minetest.register_craft({
  type = 'shapeless',
  output = 'tomatos:tomato_seeds',
  recipe = {
    'tomatos:tomato',
  },
})

for i=0,3 do
  local node_table = {
    groups = {
      attached_node = 1,
      dig_immediate = 3,
      flammable = 1,
    },
    drawtype = 'plantlike',
    paramtype = 'light',
    tiles = {'tomatocrop_'..i..'.png'},
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    floodable = true,
    waving = 1,
  }
  if i < 3 then
    node_table.drop = 'tomatos:tomato_seeds'
    node_table.on_construct = function(pos)
      minetest.get_node_timer(pos):start(math.random(20,40))
    end
    node_table.on_timer = function(pos, elapsed)
      minetest.add_node(pos, {name = 'tomatos:tomato_crop_'..(i+1)})
    end
  else
    node_table.drop = 'tomatos:tomato'
    node_table.after_destruct = function(pos)
      minetest.add_node(pos, {name = 'tomatos:tomato_crop_'..(i-1)})
    end
  end
  minetest.register_node('tomatos:tomato_crop_'..i, node_table)
end
