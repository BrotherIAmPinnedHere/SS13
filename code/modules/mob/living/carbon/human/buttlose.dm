// experimental not sure if this is going to work please lynch me if i break everything

/mob/living/carbon/human/proc/losebutt()
	var/obj/item/organ/internal/butt/B = locate() in src.internal_organs
	for(var/obj/item/O in B.contents)
		O.loc = get_turf(src)
		B.contents -= O
		B.stored -= O.itemstorevalue
	B.Remove(src)
	B.loc = get_turf(src)
	B.name = "[src]'s " + pick("despicable", "delectable", "smelly", "rotten", "busted", "poo smeared", "double-jointed", "gaping", "pimply", "filthy", "ruined", "severed", "wrecked") + " " + pick("butt", "arse", "Duke Pookem", "behind", "bottom", "rear", "ass", "hindpart")
	new /obj/effect/decal/cleanable/blood(src.loc)
	src.nutrition -= rand(15, 30)
	visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")