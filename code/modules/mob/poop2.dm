/datum/reagent/poo
	name = "Feces"
	id = "poo"
	description = "Looks like shit... smells like shit... tastes like shit... I think it's shit.."
	reagent_state = LIQUID
	color = "#633300"

/datum/reagent/poo/reaction_turf(turf/T, reac_volume)
    if(reac_volume <= 8)
    return
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/poo/D = locate() in T.contents
		if(!D)
			new /obj/effect/decal/cleanable/poo(T)
