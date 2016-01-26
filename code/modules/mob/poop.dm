//poo code


/obj/item/weapon/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "yep, it's poo"
	icon = 'poop.dmi'
	icon_state = "poo"
	New()
		..()
		reagents.add_reagent("poo", 10)
		bitesize = 2
		icon_state = pick("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
	throw_impact(atom/hit_atom)
		if(istype(hit_atom, /turf/simulated/wall) || istype(hit_atom, /obj/structure/window))
			step_to(src,usr) // for some reason it made poop inside walls without this
		new /obj/effect/decal/cleanable/poo(hit_atom) // what, flinging poo is mandatory //deadsnipe
		src.visible_message("\red The turd splatters messily!","\red You hear a splat. You smell " + pick("something awful", "baystation", "dead babies", "candles", "the fine scent of an erotic roleplayer, with just a little extra dash of low functioning autism", "the scent of a thousand heavy roleplayers"))
		playsound(loc, 'fart.ogg', 50, 1, -5)
		del(src)


///obj/item/weapon/reagent_containers/food/snacks/poo/Crossed(AM as mob|obj)
/obj/effect/decal/cleanable/poo/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon) && isslippery)
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slip on the poo pile!"
		M.Stun(2)
		M.Weaken(1)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
//		new /obj/effect/decal/cleanable/poo(src.loc)
//		del(src)

/obj/item/weapon/reagent_containers/food/snacks/poo/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the stinking log!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.Stun(2)
		M.Weaken(1)
		new /obj/effect/decal/cleanable/poo(src.loc)
		del(src)

/obj/effect/decal/cleanable/poo
	name = "poo"
	desc = "It's brown and disgusting."
	gender = PLURAL
	density = 0
	anchored = 1
	var/isslippery = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "poo1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")

	New()
		spawn(400)
			isslippery = 0
		..()

/datum/reagent/poo
	name = "Feces"
	id = "poo"
	description = "What's brown and sticky? This."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0

/datum/reagent/poo/reaction_turf(turf/T, reac_volume)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/poo/D = locate() in T.contents
		if(!D)
			new /obj/effect/decal/cleanable/poo(T)


