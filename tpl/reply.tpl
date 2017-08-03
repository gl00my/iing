%include tpl/header.tpl nodename=nodename, dsc=dsc, hidemenu=True, background=background
%if msgid:
%title="Ответ на " + msgid
%#msg = open("msg/" + msgid, "r").read().split("\n")
%repto = msgid
%to = msg[3]
%subj = msg[6]
%if not subj.startswith("Re: "):
%subj = "Re: " + subj
%end
%else:
%title="Новое сообщение в " + echoarea
%repto = ""
%to = "All"
%subj = False
%end
<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> Главная</span></a>
</div>
<h3><span class="caption">{{title}}</span></h3>
</div>
<br>
<div id="conferences" class="width90">
%if msgid:
<div class="single-message reply">
%for line in msg[8:]:
{{line}}<br>
%end
</div><br>
%end

<br>
<center>
%if msgid:
<form method="post" enctype="multipart/form-data" action="/a/savemsg/{{echoarea}}/{{msgid}}">
<input type="hidden" name="to" value="{{to}}">
%else:
<form method="post" enctype="multipart/form-data" action="/a/savemsg/{{echoarea}}">
<input type="text" name="to" class="input input_line" placeholder="Кому" value="{{to}}"><br>
%end
<input type="hidden" name="repto" value="{{repto}}">
%if subj:
<input type="text" name="subj" class="input input_line" placeholder="Тема сообщения" value="{{subj}}"><br>
%else:
<input type="text" name="subj" class="input input_line" placeholder="Тема сообщения"><br>
%end
<textarea name="msgbody" cols="80" rows=10" class="input" placeholder="Введите текст сообщения..."></textarea><br>
%if not auth:
<input type="text" name="authstr" class="input input_line" placeholder="auth-ключ"><br>
%else:
<input type="hidden" name="authstr" class="input input_line" placeholder="auth-str" value={{auth}}><br>
%end
<button class="form-button"><i class="fa fa-share-square"></i> Отправить</button>
</form>
</center>
<hr/>
<div align="left">
<h2>Помощь</h2>
<h3>Вставка кода</h3>
<pre>
Обычный текст.
А дальше -- вставляем код.

====
for i=1,10 do
    print "hello world"
end
====

А теперь снова обычный текст.
</pre>
<h3>Цитирование</h3>
<pre>
> Белеет парус одинокий...
> Это -- цитата!

Мне нравится это стихотворение!
</pre>
<h3>Спойлеры</h3>
<pre>
Я хочу рассказать, как пройти эту загадку.
&#37;&#37;spoiler&#37;&#37;
Совершенно секретно!
Вся эта часть сообщения будет закодирована!
</pre>
<br>
</div>

</div>
<br>

%include tpl/footer.tpl