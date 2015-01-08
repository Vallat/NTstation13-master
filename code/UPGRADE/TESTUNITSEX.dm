/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["sex"])
		var/mob/living/carbon/M = usr.affectedsex
		if(get_dist(M.loc,usr.loc)>1)
			usr << "\red —лишком далеко дл&#255 мен&#255."
			return

		switch(href_list["sex"])
			if("mouthkiss")
				switch(rand(1,4))
					if(1)
						visible_message("Х <b>[usr]</b> целует <b>[M]</b>.")
					if(2)
						visible_message("Х <b>[usr]</b> со страстью целует <b>[M]</b>.")
					if(3)
						visible_message("Х <b>[usr]</b> впиваетс&#255; в губы <b>[M]</b>.")
					if(4)
						visible_message("Х <b>[usr]</b> осыпает уста <b>[M]</b> поцелу&#255;ми.")
			if("mouthpenis")
				if(M.gender=="male")
					switch(rand(1,6))
						if(1)
							visible_message("Х <b>[usr]</b> прижимает голову <b>[M]</b> к паху.")
							if(prob(40))
								spawn(5)
								visible_message("Х <b>[M]</b> тыкнувшись [M.gender=="male"?"носом":"носиком"] в [pick("пах","заросли")] <b>[usr]</b> плотно обхватывает его [M.gender=="male"?"губами":"губками"].")

						if(2 || 3 || 4 || 5)
							visible_message("Х <b>[usr]</b> трахает <b>[M]</b> в рот.")
							if(prob(40))
								spawn(5)
								visible_message("Х <b>[usr]</b> зажмурив [M.gender=="male"?"глаза":"глазки"] принимает в себ&#255; орган партнЄра.")
						if(6)
							visible_message("Х <b>[usr]</b> кладЄт руки на голову <b>[M]</b> и прижимает еЄ к паху.")
							if(prob(40))
								spawn(5)
								visible_message("Х <b>[usr]</b> загладывает член <b>[M]</b> полностью.")
				else
					switch(rand(1,4))
						if(1)
							visible_message("Х <b>[usr]</b> прижимает голову <b>[M]</b> к киске.")
							if(prob(40))
								spawn(5)
								visible_message("Х <b>[M]</b> [pick("отлизывает","целует половые губы","водит &#255;зыком в влагалище", "отлизывает", "отлизывает")] <b>[usr]</b>.")
						if(2 || 3 || 4)
							visible_message("Х <b>[usr]</b> сложив руки на затылке у <b>[M]</b> прижимает [M.gender=="male"?"его":"еЄ"] к киске.")
							if(prob(40))
								spawn(5)
								visible_message("Х <b>[M]</b> [pick("отлизывает","целует половые губы","водит &#255;зыком в влагалище", "отлизывает", "отлизывает")] <b>[usr]</b>.")
			if("chestmouth")
				if(M.gender == "male")
					switch(rand(1,3))
						if(1)
							visible_message("Х <b>[usr]</b> водит &#255;зыком по груди <b>[M]</b>.")
						if(2)
							visible_message("Х <b>[usr]</b> осыпает грудь <b>[M]</b> поцелу&#255;.")
						if(3)
							visible_message("Х <b>[usr]</b> посасывает сосочки у <b>[M]</b>.")
				if(M.gender == "female")
					switch(rand(1,3))
						if(1)
							visible_message("Х <b>[usr]</b> проводит &#255;зыком по груди <b>[M]</b>.")
						if(2)
							visible_message("Х <b>[usr]</b> [pick("","словно младенец ")]посасывает соски <b>[M]</b>.")
						if(3)
							visible_message("Х <b>[usr]</b> целует груди <b>[M]</b>.")
			if("chesthands")
				if(M.gender=="male")
					switch(rand(1,5))
						if(1)
							visible_message("Х <b>[usr]</b> ласкает груди девушки руками.")
						if(2)
							visible_message("Х <b>[usr]</b> выкручивает соски <b>[M]'a</b>")
						if(3 || 4 || 5)
							visible_message("Х <b>[usr]</b> лапает тело <b>[M]</b>.")
				else
					switch(rand(1,4))
						if(1)
							visible_message("Х <b>[usr]</b> ласкает груди <b>[M]</b>")
						if(2)
							visible_message("Х <b>[usr]</b> лапает тело <b>[M]</b>")
						if(3 || 4)
							visible_message("Х <b>[usr]</b> мнЄт груди <b>[M]</b>")

			if("chestpenis")
				switch(rand(1,))
					if(1)
						visible_message("Х <b>[usr]</b> тыркаетс&#255; пенисом о грудь <b>[M]</b>.")
					if(2)
						visible_message("Х <b>[usr]</b> трахает груди партнЄрши.")
					if(3)
						visible_message("Х <b>[usr]</b> двигает членом вперЄд-назад меж грудей <b>[M]</b>.")
			if("groinmouth")
				if(M.gender=="male")
					switch(rand(1,11))
						if(1)
							visible_message("Х <b>[usr]</b> кладЄт член партнЄра себе в рот.")
						if(2)
							visible_message("Х <b>[usr]</b> целует член <b>[M]</b> и заглатывает его.")
						if(3)
							visible_message("Х <b>[usr]</b> плотным кольцом губ обсасывает орган партнЄра.")
						if(4)
							visible_message("Х <b>[usr]</b> проводит &#255;зыком по органу <b>[M]</b>.")
						if(5)
							visible_message("Х <b>[usr]</b> делает глубокий минет.")
						if(6)
							visible_message("Х <b>[usr]</b> причмокива&#255; сосЄт член <b>[M]'а</b>.")
						if(7 || 8 || 9 || 10 || 11)
							visible_message("Х <b>[usr]</b> отсасывает <b>[M]'у</b>.")
				else
					switch(rand(1,11))
						if(1)
							visible_message("Х <b>[usr]</b> покрывает поцелу&#255;ми лоно любви <b>[M]</b>.")
						if(2)
							visible_message("Х <b>[usr]</b> целует половые губы партнЄрши.")
						if(3 || 4 || 5 || 6 || 7)
							visible_message("Х <b>[usr]</b> отлизывает <b>[M]</b>.")
						if(8)
							visible_message("Х <b>[usr]</b> вводит пальцы внутрь <b>[M]</b>, целуy&#255; клитор.")
			if("groinhands")
				if(M.gender=="male")
					switch(rand(1,4))
						if(1 || 2 || 3)
							visible_message("Х <b>[usr]</b> надрачивает член <b>[M]'а</b>.")
						if(4)
							visible_message("Х <b>[usr]</b> обхватывает член <b>[M]'а</b> ладон&#255; двига&#255; ими вперЄд-назад.")
				else
					switch(rand(1,2))
						if(1)
							visible_message("Х <b>[usr]</b> двигает пальцами в дырочке у <b>[M]'ы</b>.")
						if(2)
							visible_message("Х <b>[usr]</b> проникает пальцами внутрь <b>[M]</b>.")
			if("groinpenis")
				if(M.gender=="male")
					switch(rand(1,2))
						if(1)
							visible_message("Х <b>[usr]</b> насаживаетс&#255; на орган партнЄра.")
						if(2)
							visible_message("Х <b>[usr]</b> трахает себ&#255; органом <b>[M]</b>.")
				else
					switch(rand(1,5))
						if(1)
							visible_message("Х <b>[usr]</b> трахает <b>[M]</b> .")
						if(2)
							visible_message("Х <b>[usr]</b> сжима&#255; бЄдра <b>[M]</b> трахает еЄ.")
						if(3)
							visible_message("Х <b>[usr]</b> двигаетс&#255; внутри <b>[M]</b> .")
						if(4)
							visible_message("Х <b>[usr]</b> резкими движени&#255;ми вгон&#255;ет член в <b>[M]</b>")
						if(5)
							visible_message("Х <b>[usr]</b> прижима&#255;сь к <b>[M]</b> вгон&#255;ет в неЄ член.")
			if("assmouth")
				switch(rand(1,3))
					if(1)
						visible_message("Х <b>[usr]</b> лижет [pick("очко","анальное кольцо","жопу")] <b>[M]</b>.")
					if(2)
						visible_message("Х <b>[usr]</b> водит &#255;зыком по [pick("очку","анальному кольцу","попке","жопе")] <b>[M]</b>.")
					if(3)
						visible_message("Х <b>[usr]</b> двигает &#255;зыком в [pick("очке","анальном кольце","жопе")] <b>[M]</b>.")
			if("asspenis")
				switch(rand(1,5))
					if(1)
						visible_message("Х <b>[usr]</b> трахает <b>[M]</b> в [pick("задницу","жопу","попку","анальное кольцо")].")
					if(2)
						visible_message("Х <b>[usr]</b> с силой трахает <b>[M]</b> в [pick("задницу","жопу","попку","анальное кольцо")].")
					if(3)
						visible_message("Х <b>[usr]</b> глубоко всаживает свой член в [pick("задницу","жопу","попку","анальное кольцо")] <b>[M]</b>.")
					if(4)
						visible_message("Х <b>[usr]</b> по самые &#255;йца засаживает член в [pick("задницу","жопу","попку","анальное кольцо")] <b>[M]</b>.")
					if(5)
						visible_message("Х <b>[usr]</b> сжима&#255; [pick("попку","жопу","бЄдра","бЄдра")] <b>[M]</b> [pick("грубо трахает", "трахает")] [M.gender=="male"?"его":"еЄ"] в [pick("задницу","жопу","попку","анальное кольцо")].")
			if("assfinger")
				if(usr.stat)	return
				usr << sound('sound/effects/chpok01.ogg')
				M << sound('sound/effects/chpok01.ogg')
				visible_message("Х <font color=red size=3><b>[usr]</b> засовывает большой палец в задницу <b>[M]</b></font>.")
				spawn(6)
					visible_message("Х \red<B>[M.name]</B> кричит!")
					for(var/mob/MM in viewers(usr, null))
						if (src.gender == "male")
							MM << sound(pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'))
						else
							MM << sound(pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'))
							M << "Х <font color=red size=6>®ЅјЌџ… ѕ»«ƒ≈÷</font>"



/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	//	world << "mob/m - [M] mob/user - [user], usr - [usr], src - [src]"
	if(M==src && src!=usr)		return
	if(!Adjacent(src))			return
	if(M!=usr)					return
	usr.affectedsex = src
	make_sex(machine)

/mob/proc/make_sex()
	usr.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>ѕотыкать палкой [name]</FONT></B>
	<BR>"}
	usr << browse(dat, text("window=mob[];size=325x500", name))
	onclose(usr, "mob[name]")
	return


/mob/living/carbon/human/make_sex()
	usr.set_machine(src)
	var/dat = {"<style type="text/css">
	body{
	background-color: #c0c0c0;
	}
	A {
	text-decoration: none;
	font-size: 12pt;
	}
	A:hover {
	text-decoration: underline;
	color: red;
	}
	</style>
	<B><FONT size=4>«апретные плоды</FONT></B>
	<HR>
	<font color=purple size=3>–от</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"Х<A href='?src=\ref[src];sex=mouthkiss'>ѕоцелуй</A><BR> \
	Х <A href='?src=\ref[src];sex=mouthpenis'>ѕенис</A><BR>":"—лишком далеко"]

	<font color=purple size=3>√рудь</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"Х<A href='?src=\ref[src];sex=chestmouth'>–от</A><BR> \
	Х <A href='?src=\ref[src];sex=chesthands'>–уки</A><BR> \
	Х <A href='?src=\ref[src];sex=chestpenis'>ѕенис</A><BR>":"—лишком далеко"]

	<font color=purple size=3>ѕах</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"Х<A href='?src=\ref[src];sex=groinmouth'>–от</A><BR> \
	Х <A href='?src=\ref[src];sex=groinhands'>–уки</A><BR> \
	Х <A href='?src=\ref[src];sex=groinpenis'>ѕенис</A><BR>":"—лишком далеко"]
	<font color=purple size=3>ѕопка</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"Х<A href='?src=\ref[src];sex=assmomuth'>–от</A><BR> \
	Х <A href='?src=\ref[src];sex=asshands'>–уки</A><BR> \
	Х <A href='?src=\ref[src];sex=asspenis'>ѕенис</A><BR>":"—лишком далеко"]
	<font color=purple size=3>»нтересности(?)</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"Х<A href='?src=\ref[src];sex=assfinger'>Ѕольшой палец</A><BR>":"—лишком далеко"]
	"}
	usr << browse(dat, text("window=mob[name];size=340x480"))
	onclose(usr, "mob[name]")
	return