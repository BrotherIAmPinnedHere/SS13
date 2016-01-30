/mob/living/carbon/human/emote(act,m_type=1,message = null)
	var/param = null
	var/delay = 5
	var/exception = null
	if(src.spam_flag == 1)
		return
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)


	var/muzzled = is_muzzled()
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his hands ANGRILY! NO GRIFFING!!! REEEEEE!!!"
				m_type = 2

		if ("choke","chokes")
			if (miming)
				message = "<B>[src]</B> clutches \his throat desperately!"
			else
				..(act)

		if ("chuckle","chuckles")
			if(miming)
				message = "<B>[src]</B> appears to chuckle."
			else
				..(act)

		if ("clap","claps")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2

		if ("collapse","collapses")
			Paralyse(2)
			adjustStaminaLoss(100) // Hampers abuse against simple mobs, but still leaves it a viable option.
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if ("cough","coughs")
			if (miming)
				message = "<B>[src]</B> appears to cough!"
			else
				if (!muzzled)
					var/sound = pick('sound/misc/cough1.ogg', 'sound/misc/cough2.ogg', 'sound/misc/cough3.ogg', 'sound/misc/cough4.ogg')
					if(gender == FEMALE)
						sound = pick('sound/misc/cough_f1.ogg', 'sound/misc/cough_f2.ogg', 'sound/misc/cough_f3.ogg')
					playsound(src.loc, sound, 50, 1, 5)
					if(nearcrit)
						message = "<B>[src]</B> coughs up blood!"
					else
						message = "<B>[src]</B> coughs!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("cry","crys","cries") //I feel bad if people put s at the end of cry. -Sum99
			if (miming)
				message = "<B>[src]</B> cries."
			else
				if (!muzzled)
					message = "<B>[src]</B> cries."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise. \He frowns."
					m_type = 2

		if ("custom")
			if(jobban_isbanned(src, "emote"))
				src << "You cannot send custom emotes (banned)"
				return
			if(src.client)
				if(client.prefs.muted & MUTE_IC)
					src << "You cannot send IC messages (muted)."
					return
			if((src.lashed>=1))
				src << "You're too ashamed to do that..."
				return
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

		if ("dap","daps")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("fart")
			exception = 1
			var/obj/item/organ/internal/butt/B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			var/lose_butt = prob(4)
			message = "<B>[src]</B> [pick(
				  "rears up and lets loose a fart of tremendous magnitude!",
				  "farts!",
				  "just fucking farted, what a mongoloid!", // do not re-add those messages, trashman does not want unneccessary drama, the social justice one is fine and not directed directly at the sjw sperg we all hate
				  "does a post-modern statement on social justice", //^ a faggot lol, but pleae don't re add them.
				  "toots.",
				  "harvests methane from uranus at mach 3!",
				  "assists global warming!",
				  "farts and waves their hand dismissively.",
				  "farts and pretends nothing happened.",
				  "is a <b>farting</b> motherfucker!",
				  "expels intestinal gas!",
				  "is silent, but deadly!",
				  "farts and fondles their buttocks.",
				  "queefs from their mouth! Double trouble!",
				  "farts <font color='red'>FOR THE MOTHERAND!</font>",
				  "farts <font color='blue'>FOR THE REICH!</font>",
				  "burps! It's a fart from the mouth!",
				  "farts! It reminds you of your grandmother's queefs.",
				  "farts very, very quietly.... \red THE STENCH IS OVERPOWERING!",
				  "does the George Melons salute!",
				  "farts and fondles YOUR buttocks! ",
				  "farts! The fart is dead, long live the fart!",
				  "sings the song of the Fartisans.",
				  "is a flatulent whore.",
				  "fills the room with the scent of George Melons' perfume!",
				  "tests a North Korean nuke in their pants!",
				  "toolboxes the assistants living in their colon!",
				  "allows you to sample a large array of anal scents.",
				  "queefs from their ass!",
				  "farts loudly! Now the room smells like dead babies.",
				  "farts loudly! Now the room smells like Fidel Castro's unwashed testicles.",
				  "farts loudly! Now the room feels like an extremely unoriginal fart message.",
				  "farts loudly! Now the room smells like a Baystation12 admin's basement.",
				  "groans and moans, farting like the world depended on it.",
				  "releases funeral fog from their blackened pit of demons! How very kvlt and nekro!",
				  "gasses their pantjews. Heil Fartler!",
				  "farts loud enough to make George Melons blush!",
				  "farts with much force, barely avoiding making a roleplay in their pants!",
				  "puts the art back into farting with their custom tailored farts! Hey, <B>[src]</B>, you're fuckin' good.",
				  "directs a griefer's symphony!",
				  "breaks wind.",
				  "farts in their mouth. A shameful [src].",
				  "grunts and strains, tainting the air with toxic anal gasses.",
				  "hath farteth.",
				  "<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>")]"
			spawn(0)
				spawn(1)
					for(var/obj/item/weapon/storage/book/bible/Y in range(0))
						var/obj/effect/lightning/L = new /obj/effect/lightning(get_turf(src.loc))
						L.layer = 16
						L.start()
						playsound(Y,'sound/effects/thunder.ogg', 90, 1)

						spawn(10)
							src.gib()
						break //This is to prevent multi-gibbening
				B = locate() in src.internal_organs
				if(B.contents.len)
					var/obj/item/O = pick(B.contents)
					var/turf/location = get_turf(B)
					if(istype(O, /obj/item/weapon/lighter))
						var/obj/item/weapon/lighter/G = O
						if(G.lit && location)
							new/obj/effect/hotspot(location)
							playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/weapon/weldingtool))
						var/obj/item/weapon/weldingtool/J = O
						if(J.welding == 1 && location)
							new/obj/effect/hotspot(location)
							playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/weapon/bikehorn) || istype(O, /obj/item/weapon/bikehorn/rubberducky))
						playsound(src, 'sound/items/bikehorn.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/device/megaphone))
						playsound(src, 'sound/misc/fartmassive.ogg', 75, 1, 5)
					else
						playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					if(prob(33))
						O.loc = get_turf(src)
						B.contents -= O
						B.stored -= O.itemstorevalue
				else
					playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
				sleep(1)
				if(lose_butt)
					src.losebutt(B)
				else
					src.nutrition -= rand(5, 25)
				for(var/mob/living/M in range(0))
					if(M != src)
						if(lose_butt)
							visible_message("\red <b>[src]</b>'s ass hits <b>[M]</b> in the face!", "\red Your ass smacks <b>[M]</b> in the face!")
							M.apply_damage(15,"brute","head")
							add_logs(src, M, "farted on", object=null, addition=" (DAMAGE DEALT: 15)")
						else
							visible_message("\red <b>[src]</b> farts in <b>[M]</b>'s face!")



		if ("poo")
			exception = 1
			var/obj/item/organ/internal/butt/B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			exception = 1
			src.nutrition -= 30
			if(src.w_uniform)
				src << "You shit in your uniform. Good job."
				playsound(src, 'sound/misc/squishy.ogg')
				return
			var/lose_butt = prob(9)
			src.nutrition -= 30
			new /obj/effect/decal/cleanable/poo(src.loc)
			new /obj/item/weapon/reagent_containers/food/snacks/poo(src.loc)
			message = "<B>[src]</B> [pick(
				  "pinches a loaf!",
				  "squeezes out a log with grace!",
				  "releases their bowels.",
				  "releases a brown serpent from captivity.",
				  "<B><font color='red'>S</font><font color='blue'>H</font><font color='red'>I</font><font color='blue'>T</font><font color='red'>S</font></B>")]"
			spawn(0)
				spawn(1)
					for(var/obj/item/weapon/storage/book/bible/Y in range(0))
						var/obj/effect/lightning/L = new /obj/effect/lightning(get_turf(src.loc))
						L.layer = 16
						L.start()
						playsound(Y,'sound/effects/thunder.ogg', 90, 1)

						spawn(10)
							src.gib()
						break //This is to prevent multi-gibbening
				B = locate() in src.internal_organs
				if(B.contents.len)
					var/obj/item/O = pick(B.contents)
					var/turf/location = get_turf(B)
					if(istype(O, /obj/item/weapon/lighter))
						var/obj/item/weapon/lighter/G = O
						if(G.lit && location)
							new/obj/effect/hotspot(location)
							playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/weapon/weldingtool))
						var/obj/item/weapon/weldingtool/J = O
						if(J.welding == 1 && location)
							new/obj/effect/hotspot(location)
							playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/weapon/bikehorn) || istype(O, /obj/item/weapon/bikehorn/rubberducky))
						playsound(src, 'sound/items/bikehorn.ogg', 50, 1, 5)
					else if(istype(O, /obj/item/device/megaphone))
						playsound(src, 'sound/misc/fartmassive.ogg', 75, 1, 5)
					else
						playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					if(prob(33))
						O.loc = get_turf(src)
						B.contents -= O
						B.stored -= O.itemstorevalue
				else
					playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
				sleep(1)
				if(lose_butt)
					src.losebutt(B)
				else
					src.nutrition -= rand(5, 25)
				for(var/mob/living/M in range(0))
					if(M != src)
						if(lose_butt)
							visible_message("\red <b>[src]</b>'s ass hits <b>[M]</b> in the face!", "\red Your ass smacks <b>[M]</b> in the face!")
							M.apply_damage(15,"brute","head")
							add_logs(src, M, "farted on", object=null, addition=" (DAMAGE DEALT: 15)")
						else
							visible_message("\red <b>[src]</b> shits in <b>[M]</b>'s mouth!")
							M.apply_damage(5,TOX)
							add_logs(src, M, "shat in the mouth of", object=null, addition=" (DAMAGE DEALT: 5)")

//REWRITE THIS ASAP
		if ("shitcannon" || "finalform" || "finalesfunkeln")
			var/turf/T = src.loc
			if(src.nutrition >=200)
				for(var/i=0, i<6, i++)
					T = get_step(T, turn(src.dir, 180))
					new /obj/effect/decal/cleanable/poo(T)
					new /obj/item/weapon/reagent_containers/food/snacks/poo(T)
					src.nutrition -= 100
					playsound(loc, 'fart.ogg', 100, 1, 2)
					playsound(loc, 'squishy.ogg', 100, 1, -5)
					message = "<font size=4><B>[src]</B> releases a fountain of <B>shit</B> from \his augmented ass!</font>"
					for(var/mob/living/carbon/human/H in T)
						H.weakened = 4
						H << "\red Holy shit, what the fuck was that!?"

		if ("flap","flaps")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his hands."
				m_type = 2

		if ("gasp","gasps")
			if (miming)
				message = "<B>[src]</B> appears to be gasping!"
			else
				..(act)

		if ("giggle","giggles")
			if (miming)
				message = "<B>[src]</B> giggles silently!"
			else
				..(act)

		if ("groan","groans")
			if (miming)
				message = "<B>[src]</B> appears to groan!"
			else
				if (!muzzled)
					message = "<B>[src]</B> groans!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("grumble","grumbles")
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if ("hug","hugs")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "<B>[src]</B> takes a drag from a cigarette and blows \"[M]\" out in smoke."
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows \his name out in smoke."
					m_type = 2

		if ("me")
			if((src.lashed>=1))
				src << "You're too ashamed to do that..."
				return
			if(silent)
				return
			if(jobban_isbanned(src, "emote"))
				src << "You cannot send custom emotes (banned)"
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='danger'>You cannot send IC messages (muted).</span>"
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				message = "<B>[src]</B> [message]"

		if ("moan","moans")
			if(miming)
				message = "<B>[src]</B> appears to moan!"
			else
				message = "<B>[src]</B> moans!"
				m_type = 2

		if ("mumble","mumbles")
			message = "<B>[src]</B> mumbles!"
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if ("salute","salutes")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("scream")
			if(silent) // Fixes the screaming while muffled issue. Thanks to Crystal for the fix.
				message = "<B>[src]</B> makes a loud, muffled noise."
				m_type = 2
			else
				if (miming)
					message = "<B>[src]</B> acts out a scream!"
				else
					var/DNA = src.dna.species.id
					var/sound = pick('sound/misc/scream_m1.ogg', 'sound/misc/scream_m2.ogg')
					switch(DNA)
						if("IPC")
							sound = "sound/voice/screamsilicon.ogg"
						if("tarajan")
							sound = "sound/misc/cat.ogg"
						if("lizard")
							sound = "sound/misc/lizard.ogg"
						if("avian")
							sound = "sound/misc/caw.ogg"
						if("skeleton")
							sound = "sound/misc/skeleton.ogg"
						if("jew")
							sound = "sound/misc/oyvey.ogg"
						else
							if(gender == FEMALE)
								sound = pick('sound/misc/scream_f1.ogg', 'sound/misc/scream_f2.ogg')
							if(isalien(src))
								sound = pick('sound/voice/hiss6.ogg')

					playsound(src.loc, sound, 50, 1, 4, 1.2)
					message = "<B>[src]</B> screams!"
					src.adjustOxyLoss(5)
					m_type = 2
			delay = 15

		if ("vomit")
			if(src.nutrition >= 50)
				message = "<span class='danger'>[src] vomits!</span>"
				src.nutrition -= 40
				src.adjustToxLoss(-3)
				src.adjustBruteLoss(5)
				var/turf/T = get_turf(src)
				T.add_vomit_floor(src)
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
			else
				message = "<span class='danger'>[src] dry heaves violently!</span>"
				src.adjustBruteLoss(8)
				var/sound = pick('sound/misc/cough1.ogg', 'sound/misc/cough2.ogg', 'sound/misc/cough3.ogg', 'sound/misc/cough4.ogg')
				if(gender == FEMALE)
					sound = pick('sound/misc/cough_f1.ogg', 'sound/misc/cough_f2.ogg', 'sound/misc/cough_f3.ogg')
				playsound(src.loc, sound, 50, 1, 5)
			m_type = 1
			delay = 30

		if ("shiver","shivers")
			message = "<B>[src]</B> shivers."
			m_type = 1

		if ("shrug","shrugs")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("sigh","sighs")
			if(miming)
				message = "<B>[src]</B> sighs."
			else
				..(act)

		if ("signal","signals")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze","sneezes")
			if (miming)
				message = "<B>[src]</B> sneezes."
			else
				if (muzzled)
					message = "<B>[src]</B> makes a strange noise."
				else
					var/sound = pick('sound/misc/malesneeze01.ogg', 'sound/misc/malesneeze02.ogg', 'sound/misc/malesneeze03.ogg')
					if(gender == FEMALE)
						sound = pick('sound/misc/femsneeze01.ogg', 'sound/misc/femsneeze02.ogg')
					playsound(src.loc, sound, 50, 1, 5)
					message = "<B>[src]</B> sneezes."
				m_type = 2
				..(act)

		if ("sniff","sniffs")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore","snores")
			if (miming)
				message = "<B>[src]</B> sleeps soundly."
			else
				..(act)

		if ("superfart") //how to remove ass
			exception = 1
			var/obj/item/organ/internal/butt/B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			if(B.loose)
				src << "\red Your butt's too loose to superfart!"
				return
			B.loose = 1 // to avoid spamsuperfart
			var/fart_type = 1 //Put this outside probability check just in case. There were cases where superfart did a normal fart.
			if(prob(76)) // 76%     1: ASSBLAST  2:SUPERNOVA  3: FARTFLY
				fart_type = 1
			else if(prob(12)) // 3%
				fart_type = 2
			else if(prob(12)) // 0.4%
				fart_type = 3
			spawn(0)
				spawn(1)
					for(var/obj/item/weapon/storage/book/bible/Y in range(0))
						var/obj/effect/lightning/L = new /obj/effect/lightning(get_turf(src.loc))
						L.layer = 16
						L.start()
						playsound(Y,'sound/effects/thunder.ogg', 90, 1)
						spawn(10)
							src.gib()
						break //This is to prevent multi-gibbening
				sleep(4)
				for(var/i = 1, i <= 10, i++)
					playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
					sleep(1)
				playsound(src, 'sound/misc/fartmassive.ogg', 75, 1, 5)
				if(B.contents.len)
					for(var/obj/item/O in B.contents)
						O.assthrown = 1
						O.loc = get_turf(src)
						B.contents -= O
						B.stored -= O.itemstorevalue
						var/turf/target = get_turf(O.loc)
						var/range = 7
						var/turf/new_turf
						var/new_dir
						switch(dir)
							if(1)
								new_dir = 2
							if(2)
								new_dir = 1
							if(4)
								new_dir = 8
							if(8)
								new_dir = 4
						for(var/i = 1; i < range; i++)
							new_turf = get_step(target, new_dir)
							target = new_turf
							if(new_turf.density)
								break
						O.throw_at(target,range,O.throw_speed)
						O.assthrown = 0 // so you can't just unembed it and throw it for insta embeds
				B.Remove(src)
				B.loc = get_turf(src)
				B.name = "[src]'s absolutely ruined butt" // no fuck this shit its entirely different
				if(B.loose) B.loose = 0
				new /obj/effect/decal/cleanable/blood(src.loc)
				src.nutrition -= 500
				switch(fart_type)
					if(1)
						for(var/mob/living/M in range(0))
							if(M != src)
								visible_message("\red <b>[src]</b>'s ass blasts <b>[M]</b> in the face!", "\red You ass blast <b>[M]</b>!")
								M.apply_damage(50,"brute","head")
								add_logs(src, M, "superfarted on", object=null, addition=" (DAMAGE DEALT: 50)")

						visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")

					if(2)
						visible_message("\red <b>[src]</b> rips their ass apart in a massive explosion!", "\red Holy shit, your butt goes supernova!")
						explosion(src.loc, 0, 1, 3, adminlog = 0, flame_range = 3)
						src.gib()

					if(3)
						var/startx = 0
						var/starty = 0
						var/endy = 0
						var/endx = 0
						var/startside = pick(cardinal)

						switch(startside)
							if(NORTH)
								starty = src.loc
								startx = src.loc
								endy = 38
								endx = rand(41, 199)
							if(EAST)
								starty = src.loc
								startx = src.loc
								endy = rand(38, 187)
								endx = 41
							if(SOUTH)
								starty = src.loc
								startx = src.loc
								endy = 187
								endx = rand(41, 199)
							else
								starty = src.loc
								startx = src.loc
								endy = rand(38, 187)
								endx = 199

						//ASS BLAST USA
						visible_message("\red <b>[src]</b> blows their ass off with such force, they explode!", "\red Holy shit, your butt flies off into the galaxy!")
						src.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
						new /obj/effect/immovablerod/butt(locate(startx, starty, 1), locate(endx, endy, 1))
						priority_announce("What the fuck was that?!", "General Alert")

		if ("whimper","whimpers")
			if (miming)
				message = "<B>[src]</B> appears hurt."
			else
				..(act)

		if ("yawn","yawns")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2

		if("wag","wags")
			if(dna && dna.species && (("tail_lizard" in dna.species.mutant_bodyparts) || (dna.features["tail_human"] != "None")))
				message = "<B>[src]</B> wags \his tail."
				startTailWag()
			else
				src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if("stopwag")
			if(dna && dna.species && (("waggingtail_lizard" in dna.species.mutant_bodyparts) || ("waggingtail_human" in dna.species.mutant_bodyparts)))
				message = "<B>[src]</B> stops wagging \his tail."
				endTailWag()
			else
				src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if ("help") //This can stay at the bottom.
			src << "Help for human emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, dance, dap, deathgasp, drool, eyebrow, faint, fart, flap, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, jump, laugh, look-(none)/mob, me, moan, mumble, nod, pale, point-(atom), raise, salute, scream, shake, shiver, shrug, sigh, signal-#1-10, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, stopwag, superfart, tremble, twitch, twitch_s, wave, whimper, wink, wag, yawn"

		else
			..(act)

	if(miming)
		m_type = 1



	if (message)
		log_emote("[name]/[key] : [message]")
		if(!exception)
			src.spam_flag = 1
			spawn(delay)
				src.spam_flag = 0

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			visible_message(message)
		else if (m_type & 2)
			audible_message(message)



//Don't know where else to put this, it's basically an emote
/mob/living/carbon/human/proc/startTailWag()
	if(!dna || !dna.species)
		return
	if("tail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_lizard"
		dna.species.mutant_bodyparts -= "spines"
		dna.species.mutant_bodyparts |= "waggingtail_lizard"
		dna.species.mutant_bodyparts |= "waggingspines"
	if("tail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_human"
		dna.species.mutant_bodyparts |= "waggingtail_human"
	update_body()


/mob/living/carbon/human/proc/endTailWag()
	if(!dna || !dna.species)
		return
	if("waggingtail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_lizard"
		dna.species.mutant_bodyparts -= "waggingspines"
		dna.species.mutant_bodyparts |= "tail_lizard"
		dna.species.mutant_bodyparts |= "spines"
	if("waggingtail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_human"
		dna.species.mutant_bodyparts |= "tail_human"
	update_body()
