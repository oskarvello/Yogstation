/obj/item/weapon/melee/baton
	name = "stun baton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")
	var/charges = 10
	var/status = 0

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)


/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"


/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>You grab the [src] on the wrong side.</span>"
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		user << "<span class='notice'>[src] is now [status ? "on" : "off"].</span>"
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		user << "<span class='warning'>[src] is out of charge.</span>"
	add_fingerprint(user)


/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with [src]!</span>"
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return

	if(isrobot(M))
		..()
		return

	if(user.a_intent == "harm")
		..()

	else if(!status)
		M.visible_message("<span class='warning'>[M] has been prodded with [src] by [user]. Luckily it was off.</span>")
		return

	if(status)
		user.lastattacked = M
		M.lastattacker = user

		M.Stun(10)
		M.Weaken(10)
		M.stuttering = max(M.stuttering, 10)

		M.visible_message("<span class='danger'>[M] has been stunned with [src] by [user]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

		if(isrobot(loc))
			var/mob/living/silicon/robot/R = loc
			if(R && R.cell)
				R.cell.use(50)
		else
			charges--
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.forcesay(hit_appends)

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [M.name] ([M.ckey]) with [name]</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [name]</font>"
		log_attack("<font color='red'>[user.name] ([user.ckey]) stunned [M.name] ([M.ckey]) with [name]</font>" )

		if(charges < 1)
			status = 0
			update_icon()


/obj/item/weapon/melee/baton/emp_act(severity)
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()