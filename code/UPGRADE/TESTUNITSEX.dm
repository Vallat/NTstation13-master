/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["sex"])
		var/mob/living/carbon/M = usr.affectedsex
		if(get_dist(M.loc,usr.loc)>1)
			usr << "\red ������� ������ ��&#255 ���&#255."
			return

		switch(href_list["sex"])
			if("mouthkiss")
				switch(rand(1,4))
					if(1)
						visible_message("� <b>[usr]</b> ������ <b>[M]</b>.")
					if(2)
						visible_message("� <b>[usr]</b> �� �������� ������ <b>[M]</b>.")
					if(3)
						visible_message("� <b>[usr]</b> ��������&#255; � ���� <b>[M]</b>.")
					if(4)
						visible_message("� <b>[usr]</b> ������� ���� <b>[M]</b> ������&#255;��.")
			if("mouthpenis")
				if(M.gender=="male")
					switch(rand(1,6))
						if(1)
							visible_message("� <b>[usr]</b> ��������� ������ <b>[M]</b> � ����.")
							if(prob(40))
								spawn(5)
								visible_message("� <b>[M]</b> ���������� [M.gender=="male"?"�����":"�������"] � [pick("���","�������")] <b>[usr]</b> ������ ����������� ��� [M.gender=="male"?"������":"�������"].")

						if(2 || 3 || 4 || 5)
							visible_message("� <b>[usr]</b> ������� <b>[M]</b> � ���.")
							if(prob(40))
								spawn(5)
								visible_message("� <b>[usr]</b> �������� [M.gender=="male"?"�����":"������"] ��������� � ���&#255; ����� �������.")
						if(6)
							visible_message("� <b>[usr]</b> ����� ���� �� ������ <b>[M]</b> � ��������� � � ����.")
							if(prob(40))
								spawn(5)
								visible_message("� <b>[usr]</b> ����������� ���� <b>[M]</b> ���������.")
				else
					switch(rand(1,4))
						if(1)
							visible_message("� <b>[usr]</b> ��������� ������ <b>[M]</b> � �����.")
							if(prob(40))
								spawn(5)
								visible_message("� <b>[M]</b> [pick("����������","������ ������� ����","����� &#255;����� � ���������", "����������", "����������")] <b>[usr]</b>.")
						if(2 || 3 || 4)
							visible_message("� <b>[usr]</b> ������ ���� �� ������� � <b>[M]</b> ��������� [M.gender=="male"?"���":"�"] � �����.")
							if(prob(40))
								spawn(5)
								visible_message("� <b>[M]</b> [pick("����������","������ ������� ����","����� &#255;����� � ���������", "����������", "����������")] <b>[usr]</b>.")
			if("chestmouth")
				if(M.gender == "male")
					switch(rand(1,3))
						if(1)
							visible_message("� <b>[usr]</b> ����� &#255;����� �� ����� <b>[M]</b>.")
						if(2)
							visible_message("� <b>[usr]</b> ������� ����� <b>[M]</b> ������&#255;.")
						if(3)
							visible_message("� <b>[usr]</b> ���������� ������� � <b>[M]</b>.")
				if(M.gender == "female")
					switch(rand(1,3))
						if(1)
							visible_message("� <b>[usr]</b> �������� &#255;����� �� ����� <b>[M]</b>.")
						if(2)
							visible_message("� <b>[usr]</b> [pick("","������ �������� ")]���������� ����� <b>[M]</b>.")
						if(3)
							visible_message("� <b>[usr]</b> ������ ����� <b>[M]</b>.")
			if("chesthands")
				if(M.gender=="male")
					switch(rand(1,5))
						if(1)
							visible_message("� <b>[usr]</b> ������� ����� ������� ������.")
						if(2)
							visible_message("� <b>[usr]</b> ����������� ����� <b>[M]'a</b>")
						if(3 || 4 || 5)
							visible_message("� <b>[usr]</b> ������ ���� <b>[M]</b>.")
				else
					switch(rand(1,4))
						if(1)
							visible_message("� <b>[usr]</b> ������� ����� <b>[M]</b>")
						if(2)
							visible_message("� <b>[usr]</b> ������ ���� <b>[M]</b>")
						if(3 || 4)
							visible_message("� <b>[usr]</b> ��� ����� <b>[M]</b>")

			if("chestpenis")
				switch(rand(1,))
					if(1)
						visible_message("� <b>[usr]</b> ��������&#255; ������� � ����� <b>[M]</b>.")
					if(2)
						visible_message("� <b>[usr]</b> ������� ����� ��������.")
					if(3)
						visible_message("� <b>[usr]</b> ������� ������ �����-����� ��� ������ <b>[M]</b>.")
			if("groinmouth")
				if(M.gender=="male")
					switch(rand(1,11))
						if(1)
							visible_message("� <b>[usr]</b> ����� ���� ������� ���� � ���.")
						if(2)
							visible_message("� <b>[usr]</b> ������ ���� <b>[M]</b> � ����������� ���.")
						if(3)
							visible_message("� <b>[usr]</b> ������� ������� ��� ���������� ����� �������.")
						if(4)
							visible_message("� <b>[usr]</b> �������� &#255;����� �� ������ <b>[M]</b>.")
						if(5)
							visible_message("� <b>[usr]</b> ������ �������� �����.")
						if(6)
							visible_message("� <b>[usr]</b> ����������&#255; ���� ���� <b>[M]'�</b>.")
						if(7 || 8 || 9 || 10 || 11)
							visible_message("� <b>[usr]</b> ���������� <b>[M]'�</b>.")
				else
					switch(rand(1,11))
						if(1)
							visible_message("� <b>[usr]</b> ��������� ������&#255;�� ���� ����� <b>[M]</b>.")
						if(2)
							visible_message("� <b>[usr]</b> ������ ������� ���� ��������.")
						if(3 || 4 || 5 || 6 || 7)
							visible_message("� <b>[usr]</b> ���������� <b>[M]</b>.")
						if(8)
							visible_message("� <b>[usr]</b> ������ ������ ������ <b>[M]</b>, ����y&#255; ������.")
			if("groinhands")
				if(M.gender=="male")
					switch(rand(1,4))
						if(1 || 2 || 3)
							visible_message("� <b>[usr]</b> ����������� ���� <b>[M]'�</b>.")
						if(4)
							visible_message("� <b>[usr]</b> ����������� ���� <b>[M]'�</b> �����&#255; �����&#255; ��� �����-�����.")
				else
					switch(rand(1,2))
						if(1)
							visible_message("� <b>[usr]</b> ������� �������� � ������� � <b>[M]'�</b>.")
						if(2)
							visible_message("� <b>[usr]</b> ��������� �������� ������ <b>[M]</b>.")
			if("groinpenis")
				if(M.gender=="male")
					switch(rand(1,2))
						if(1)
							visible_message("� <b>[usr]</b> �����������&#255; �� ����� �������.")
						if(2)
							visible_message("� <b>[usr]</b> ������� ���&#255; ������� <b>[M]</b>.")
				else
					switch(rand(1,5))
						if(1)
							visible_message("� <b>[usr]</b> ������� <b>[M]</b> .")
						if(2)
							visible_message("� <b>[usr]</b> �����&#255; ���� <b>[M]</b> ������� �.")
						if(3)
							visible_message("� <b>[usr]</b> ��������&#255; ������ <b>[M]</b> .")
						if(4)
							visible_message("� <b>[usr]</b> ������� �������&#255;�� ����&#255;�� ���� � <b>[M]</b>")
						if(5)
							visible_message("� <b>[usr]</b> �������&#255;�� � <b>[M]</b> ����&#255;�� � �� ����.")
			if("assmouth")
				switch(rand(1,3))
					if(1)
						visible_message("� <b>[usr]</b> ����� [pick("����","�������� ������","����")] <b>[M]</b>.")
					if(2)
						visible_message("� <b>[usr]</b> ����� &#255;����� �� [pick("����","��������� ������","�����","����")] <b>[M]</b>.")
					if(3)
						visible_message("� <b>[usr]</b> ������� &#255;����� � [pick("����","�������� ������","����")] <b>[M]</b>.")
			if("asspenis")
				switch(rand(1,5))
					if(1)
						visible_message("� <b>[usr]</b> ������� <b>[M]</b> � [pick("�������","����","�����","�������� ������")].")
					if(2)
						visible_message("� <b>[usr]</b> � ����� ������� <b>[M]</b> � [pick("�������","����","�����","�������� ������")].")
					if(3)
						visible_message("� <b>[usr]</b> ������� ��������� ���� ���� � [pick("�������","����","�����","�������� ������")] <b>[M]</b>.")
					if(4)
						visible_message("� <b>[usr]</b> �� ����� &#255;��� ���������� ���� � [pick("�������","����","�����","�������� ������")] <b>[M]</b>.")
					if(5)
						visible_message("� <b>[usr]</b> �����&#255; [pick("�����","����","����","����")] <b>[M]</b> [pick("����� �������", "�������")] [M.gender=="male"?"���":"�"] � [pick("�������","����","�����","�������� ������")].")
			if("assfinger")
				if(usr.stat)	return
				usr << sound('sound/effects/chpok01.ogg')
				M << sound('sound/effects/chpok01.ogg')
				visible_message("� <font color=red size=3><b>[usr]</b> ���������� ������� ����� � ������� <b>[M]</b></font>.")
				spawn(6)
					visible_message("� \red<B>[M.name]</B> ������!")
					for(var/mob/MM in viewers(usr, null))
						if (src.gender == "male")
							MM << sound(pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'))
						else
							MM << sound(pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'))
							M << "� <font color=red size=6>������ ������</font>"



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
	<B><HR><FONT size=3>�������� ������ [name]</FONT></B>
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
	<B><FONT size=4>��������� �����</FONT></B>
	<HR>
	<font color=purple size=3>���</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"�<A href='?src=\ref[src];sex=mouthkiss'>�������</A><BR> \
	� <A href='?src=\ref[src];sex=mouthpenis'>�����</A><BR>":"������� ������"]

	<font color=purple size=3>�����</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"�<A href='?src=\ref[src];sex=chestmouth'>���</A><BR> \
	� <A href='?src=\ref[src];sex=chesthands'>����</A><BR> \
	� <A href='?src=\ref[src];sex=chestpenis'>�����</A><BR>":"������� ������"]

	<font color=purple size=3>���</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"�<A href='?src=\ref[src];sex=groinmouth'>���</A><BR> \
	� <A href='?src=\ref[src];sex=groinhands'>����</A><BR> \
	� <A href='?src=\ref[src];sex=groinpenis'>�����</A><BR>":"������� ������"]
	<font color=purple size=3>�����</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"�<A href='?src=\ref[src];sex=assmomuth'>���</A><BR> \
	� <A href='?src=\ref[src];sex=asshands'>����</A><BR> \
	� <A href='?src=\ref[src];sex=asspenis'>�����</A><BR>":"������� ������"]
	<font color=purple size=3>������������(?)</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"�<A href='?src=\ref[src];sex=assfinger'>������� �����</A><BR>":"������� ������"]
	"}
	usr << browse(dat, text("window=mob[name];size=340x480"))
	onclose(usr, "mob[name]")
	return