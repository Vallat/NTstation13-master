mob
    see_invisible = 1 //please keep this variable here you will really need it to make the demo work

obj
	roof //the roof itself, you can also make different kinds of roofs to go along as well
		icon = 'roof.dmi' //the icon for the roof
		invisibility = 1 //keep this HERE or when you enter the building it will not work!
		layer = 100 //also keep this here as well
		name = " " //if you want to keep the name of the roof blank then thats allright.
area
    house //the house area
        Entered(mob/M) //when you enter the house you will not see the roof any more
            if(ismob(M)) //if your a mob
                M.see_invisible = 0 //keep these variables here or this will not work
        Exited(mob/M) //when you exit the house you will see the roof
            if(ismob(M)) //if your a mob
                M.see_invisible = 1 //keep these variables here or this will not work


obj
	roof
		icon = 'roof.dmi'
		invisibility = 1
		layer = 100