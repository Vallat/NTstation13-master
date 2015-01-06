/proc/priority_announce(var/text, var/title = "", var/sound = 'sound/AI/attention.ogg', var/type)
	if(!text)
		return

	var/announcement

	if(type == "Priority")
		announcement += "<h1 class='alert'>��������� �������</h1>"

	else if(type == "Captain")
		announcement += "<h1 class='alert'>���������� �� ����</h1>"
		news_network.SubmitArticle(text, "���������� �� ����", "��������� �������", null)

	else
		announcement += "<h1 class='alert'>[command_name()]</h1>"
		if (title && length(title) > 0)
			announcement += "<br><h2 class='alert'>[rhtml_encode(title)]</h2>"
		if(title == "")
			news_network.SubmitArticle(text, "���������� �� ���������� �������������", "��������� �������", null)
		else
			news_network.SubmitArticle(title + "<br><br>" + text, "���������� �� ���������� �������������", "��������� �������", null)

	announcement += "<br><span class='alert'>[rhtml_encode(text)]</span><br>"
	announcement += "<br>"

	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << announcement
			M << sound(sound)