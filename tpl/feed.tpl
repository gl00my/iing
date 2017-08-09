%import api, re, points, math
%include tpl/header.tpl nodename=nodename, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> Главная</span></a>
<a href="/echolist" id="echolist-button" class="button"><i class="fa fa-bars"></i></a>
</div>
<h3><span class="caption"><i class="fa fa-comments"></i> {{echoarea[2]}}: {{echoarea[1]}}</span></h3>
<div id="rbuttons">
<form id="search" class="query" method="get" action="/search/{{echoarea[0]}}"><input class="input_line" name="regexp" placeholder="regexp" value="" type="text"/></form>
<a href="/rss/{{echoarea[0]}}" class="button"><i class="fa fa-rss"></i><span class="caption"> RSS</span></a>
%if not api.is_vea(echoarea[0]):
<a href="/new/{{echoarea[0]}}" class="button"><i class="fa fa-plus-circle"></i><span class="caption"> Новое</span></a>
%end
</div>
</div>
<br>
%include tpl/fpaginator.tpl echoarea=echoarea[0], msglist=msgs, page=page, onpage=50
%start = (page - 1) * 50
%if start + 50 > len(msgs):
%last = len(msgs)
%else:
%last = start + 50
%end

<table cellpadding="0" cellsspacing="0" id="content">
<tr>
<td>
%for msg in msgs:
<a name="{{msg[0]}}"></a>
%if msg[0] == msgid:
<div class="single-message current-message">
%else:
<div class="single-message">
%end
<div id="echo-buttons">
%if points.is_operator(auth):
<a href="/favorites/{{msg[0]}}" class="echo-button" title="Избранное"><i class="fa fa-heart"></i></a>
<a href="/edit/{{msg[1][1]}}/{{msg[0]}}" class="echo-button" title="Редактировать"><i class="fa fa-edit"></i></a>
%end
%node=msg[1][4].split(",")
%if len(node) == 2 and node[0] == nodename:
<a href="/private/{{msg[1][3]}} <{{msg[1][4]}}>" class="echo-button" title="Личное сообщение"><i class="fa fa-envelope"></i></a>
%end
<a href="/{{msg[0]}}" class="echo-button" title="Ссылка на сообщение"><i class="fa fa-eye"></i></a>
<a href="/reply/{{msg[1][1]}}/{{msg[0]}}" class="echo-button" title="Ответить"><i class="fa fa-reply"></i></a>
</div>
%if points.is_operator(auth):
<a class="blacklisted" href="/s/blacklisted/{{msg[0]}}" title="Поместить сообщение в ЧС"><i class="fa fa-trash"></i></a>
%end

%kludges = msg[1][0].split("/")
%if "repto" in kludges:
%repto = kludges[kludges.index("repto") + 1]
%else:
%repto = False
%end
%t = api.formatted_time(msg[1][2])
%point = msg[1][3]
%address = msg[1][4]
%to = msg[1][5]
%subj = msg[1][6]
%body = msg[1][8:]

<div class="message-header">
%if msg[1][1].startswith("private.") and msg[1][1] != echoarea[0]:
<span style="background-color:gold"><a href="/{{msg[1][1]}}"><b>Личная переписка</b></a></span><br>
%end
%if repto:
<b>Ответ на:</b> <a href="/{{repto}}">{{repto}}</a><br>
%end
<b>От:</b> {{point}} ({{address}}) {{t}}<br>
<b>Кому:</b> {{to}}<br>
<b>Тема:</b> {{subj}}
</div>

%if len(body) <= 16:
{{!api.body_render("\n".join(body))}}
%else:
{{!api.body_render("\n".join(body[0:16]))}}
<br><br><a href="/{{msg[0]}}">Читать далее</a>
%end

</div><br>
%end
</table>
%include tpl/fpaginator.tpl echoarea=echoarea[0], msglist=msgs, page=page, onpage=50
<br>
%include tpl/footer.tpl