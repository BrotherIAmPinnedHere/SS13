/obj/effect/proc_holder/changeling/headcrab
	name = "Last Resort"
	desc = "We sacrifice our current body in a moment of need, placing us in control of a vessel."
	helptext = "We will be placed in control of a small, fragile creature. We may attack a corpse like this to plant an egg which will slowly mature into a new form for us."
	chemical_cost = 25
	req_human = 1

/obj/effect/proc_holder/changeling/headcrab/sting_action(mob/user)
	var/datum/mind/M = user.mind
	var/list/organs = user.getorganszone("head", 1)

	for(var/obj/item/organ/internal/I in organs)
		I.Remove(user, 1)

	explosion(get_turf(user),0,0,2,0,silent=1)
	for(var/mob/living/carbon/human/H in view(7,user))
		H << "<span class='userdanger'>You are blinded by a shower of blood!</span>"
		H.Stun(1)
		H.eye_blurry = 20
		H.eye_stat += 5
		H.confused += 3
	for(var/mob/living/silicon/S in view(7,user))
		S << "<span class='userdanger'>Your sensors are disabled by a shower of blood!</span>"
		S.Weaken(3)
	var/turf = get_turf(user)
	spawn(5) // So it's not killed in explosion
		var/mob/living/simple_animal/hostile/headcrab/crab = new(turf)
		for(var/obj/item/organ/internal/I in organs)
			I.loc = crab
		crab.origin = M
		if(crab.origin)
			crab.origin.active = 1
			crab.origin.transfer_to(crab)
			crab << "<span class='warning'>You burst out of the remains of your former body in a shower of gore!</span>"
	user.gib()
	feedback_add_details("changeling_powers","LR")
	return 1