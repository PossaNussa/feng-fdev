-------------------------------------------------------------------------------
-- allows mobs to use furniture for sitting/lying on them
-------------------------------------------------------------------------------
-- * recognizes bences, chairs, armchairs and toilets as things to sit on (from cottages, 3dforniture and homedecor)
-- * acceptable beds come from cottages, papyrus_bed, beds and colouredbeds



mob_sitting = {}

-- let the entity entity sleep on the bed at position t_pos (rotated according to pos.p2 or node.param2)
mob_sitting.sleep_on_bed = function( self, pos )
end



-- TODO: better place that in a more general mod...
mob_sitting.set_animation = function( entity, anim )
	local a = 0;   -- startframe of animation
	local b = 79;  -- endframe of animation
	local speed = 30; 
	if( anim=='stand' ) then
		a = 0;
		b = 79;
	elseif( anim=='sit' ) then
		a = 81;
		b = 148;
	elseif( anim=='sleep' ) then
		a = 164;
		b = 164;
	end
	entity.object:set_animation({x=a, y=b}, speed)
end
