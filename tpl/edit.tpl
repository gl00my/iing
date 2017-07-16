%include tpl/header.tpl nodename=nodename, dsc=dsc, hidemenu=True, background=background
%title="Редактирование " + msgid
%msgbody = msg[8:]
%subj = msg[6]
%if not subj.startswith("Re: "):
%subj = subj
%end
<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> Главная</span></a>
</div>
<h3><span class="caption">{{title}}</span></h3>
</div>
<br>

<br>
<center>
<form method="post" enctype="multipart/form-data" action="/a/editmsg/{{echoarea}}/{{msgid}}">
%if subj:
<input type="text" name="subj" class="input input_line" placeholder="Тема сообщения" value="{{subj}}"><br>
%else:
<input type="text" name="subj" class="input input_line" placeholder="Тема сообщения"><br>
%end
<textarea name="msgbody" cols="80" rows=10" class="input" placeholder="Введите текст сообщения...">
%for line in msg[8:]:
{{line}}
%end
</textarea><br>
<button class="form-button"><i class="fa fa-share-square"></i> Отправить</button>
</form>
</center>
</div>
<br>
%include tpl/footer.tpl