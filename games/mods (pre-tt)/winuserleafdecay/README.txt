Since there is still no way for Windows users to convert schematics without having the problem of standard param2 = 1 for placed leaves, I made this little mod to have an alternate leafdecay.

With this mod, all trees in my mods have a working leafdecay function. If you are a windows user and have no option to change param2 =1 to param2 =0 in schematic files, you can modify my mod to create 
your own lefdecay, or you can contact me on Minetest Forum or github and I can support your mod, if you send me the needed list of leaves and trunks, for example:

winuserleafdecay.register_winleafdecay({
	trunks = {"nameofyourmod:yourbiome_yourtree_trunk"},
	leaves = {"nameofyourmod:yourbiome_yourtree_leaves", nameofyourmod:yourbiome_yourtree_fruit"},
	radius = 3
})

To activate the Winuser Leafedecay, you have to add two things to your leaves and other tree objects that are falling down when the trunk is chopped(fruits, nuts) code:

For leaves that should decay you have to add under groups: winleafdecay = 3
For fruits, tree mushrooms or nuts that should fall down: winleafdecay_drop = 1, winleafdecay = 3