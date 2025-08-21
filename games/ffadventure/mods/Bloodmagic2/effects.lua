playereffects.register_effect_type(
	"bm2:blood_poisoning", 
	"Septicemia", 
	"bm2_poisoned_blood.png", 
	{poison=1,curable=1}, 
	function(player) player:set_hp(player:get_hp()-1) end, 
	nil, 
	false, 
	true, 
	5
)

playereffects.register_effect_type(
	"bm2:floating", 
	"Antimeteoric", 
	"bm2_floating.png", 
	{poison=1,curable=0}, 
	function(player)
		
	end, 
	nil, 
	false, 
	true, 
	1
)