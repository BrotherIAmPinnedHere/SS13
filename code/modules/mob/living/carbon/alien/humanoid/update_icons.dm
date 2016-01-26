
/mob/living/carbon/alien/humanoid/update_icons()
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	for(var/image/I in overlays_standing)
		overlays += I

	if(stat == DEAD)
		//If we mostly took damage from fire
		if(fireloss > 125)
			icon_state = "alien[caste]_husked"
		else
			icon_state = "alien[caste]_dead"

	else if((stat == UNCONSCIOUS && !sleeping) || weakened)
		icon_state = "alien[caste]_unconscious"
	else if(leap_on_click)
		icon_state = "alien[caste]_pounce"

	else if(lying || resting || sleeping)
		icon_state = "alien[caste]_sleep"
	else if(m_intent == "run")
		icon_state = "alien[caste]_running"
	else
		icon_state = "alien[caste]_s"

	if(leaping)
		if(alt_icon == initial(alt_icon))
			var/old_icon = icon
			icon = alt_icon
			alt_icon = old_icon
		icon_state = "alien[caste]_leap"
		pixel_x = -32
		pixel_y = -32
	else
		if(alt_icon != initial(alt_icon))
			var/old_icon = icon
			icon = alt_icon
			alt_icon = old_icon
		pixel_x = get_standard_pixel_x_offset(lying)
		pixel_y = get_standard_pixel_y_offset(lying)

/mob/living/carbon/alien/humanoid/regenerate_icons()
	if(!..())
		update_hud()
	//	update_icons() //Handled in update_transform(), leaving this here as a reminder
		update_transform()

/mob/living/carbon/alien/humanoid/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	if(lying > 0)
		lying = 90 //Anything else looks retarded
	..()
	update_icons()


/mob/living/carbon/alien/humanoid/queen/large/update_icons()
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	if(stat == DEAD)
		icon_state = "queen_dead"
	else if((stat == UNCONSCIOUS && !sleeping) || weakened)
		icon_state = "queen_l"
	else if(sleeping || lying || resting)
		icon_state = "queen_sleep"
	else
		icon_state = "queen_s"
	for(var/image/I in overlays_standing)
		overlays += I

/mob/living/carbon/alien/humanoid/queen/large/update_inv_l_hand()
	remove_overlay(L_HAND_LAYER)
	if(handcuffed)
		drop_l_hand()

/mob/living/carbon/alien/humanoid/queen/large/update_inv_r_hand()
	remove_overlay(R_HAND_LAYER)
	if(handcuffed)
		drop_r_hand()
