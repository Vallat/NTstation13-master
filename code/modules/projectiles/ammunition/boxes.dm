/obj/item/ammo_box/a357
	name = "ammo box (.357)"
	desc = "A box of .357 ammo"
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/c38
	name = "speed loader (.38)"
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_box/c38/e
	name = "speed loader (.38 Expansive)"
	ammo_type = /obj/item/ammo_casing/c38/e

/obj/item/ammo_box/suicide
	name = "speed loader (.38)"
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 1
	multiple_sprites = 1

/obj/item/ammo_box/a418
	name = "ammo box (.418)"
	icon_state = "418"
	ammo_type = /obj/item/ammo_casing/a418
	max_ammo = 7
	multiple_sprites = 1



/obj/item/ammo_box/a666
	name = "ammo box (.666)"
	icon_state = "666"
	ammo_type = /obj/item/ammo_casing/a666
	max_ammo = 4
	multiple_sprites = 1

/obj/item/ammo_box/c9mm
	name = "Ammunition Box (9mm)"
	icon_state = "9mmbox"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c10mm
	name = "Ammunition Box (10mm)"
	icon_state = "10mmbox"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20

/obj/item/ammo_box/c45
	name = "Ammunition Box (.45)"
	icon_state = "45box"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20

/*
 * SHOTGUN AMMO BOXES
 */

/obj/item/ammo_box/shotgun
	name = "slug box"
	icon_state = "gbox"
	caliber = ".12"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 8
	multiple_sprites = 1

	update_icon()
		icon_state = "[initial(icon_state)]-0"
		overlays.Cut()
		var/i = 0
		for(var/obj/item/ammo_casing/shotgun/AC in stored_ammo)
			i++
			overlays += icon('icons/obj/ammo.dmi', "[AC.icon_state]-[i]")


/*obj/item/ammo_box/shotgun/dart
	name = "darts box"
	icon_state = "blbox"
	ammo_type = /obj/item/ammo_casing/shotgun/dart*/

/obj/item/ammo_box/shotgun/stun
	name = "stunshells box"
	icon_state = "stunbox"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell

/obj/item/ammo_box/shotgun/bean
	name = "beanbag box"
	icon_state = "bbox"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag