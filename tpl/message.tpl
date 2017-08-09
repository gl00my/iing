%import api, re, points
%include tpl/header.tpl nodename=nodename, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> Главная</span></a>
<a href="/echolist" id="echolist-button" class="button"><i class="fa fa-bars"></i></a>
</div>
%if feed == 1:
<a href="/{{echoarea[0]}}/{{page}}/{{msgid}}#{{msgid}}"><h3><i class="fa fa-comments"></i><span class="caption"> {{echoarea[0]}}: {{echoarea[1]}}</span></h3></a>
%else:
<h3><span class="caption"><i class="fa fa-comments"></i> {{echoarea[0]}}: {{echoarea[1]}}</span></h3>
%end
<div id="rbuttons">
<form id="search" class="query" method="get" action="/search/{{echoarea[0]}}"><input class="input_line" id="query" name="regexp" placeholder="regexp" value="" type="text"/></form>
%if feed == 0:
<a href="/rss/{{echoarea[0]}}" class="button"><i class="fa fa-rss"></i><span class="caption"> RSS</span></a>
%end
<a href="/new/{{echoarea[0]}}" class="button"><i class="fa fa-plus-circle"></i><span class="caption"> Новое</span></a>
<a href="/msglist/{{echoarea[0]}}/{{msgid}}" class="button"><i class="fa fa-list"></i><span class="caption"> Список</span></a>
</div>
</div>

%if current > 0:
%prev = index[current - 1]
%else:
%prev = index[0]
%end
%if current < len(index) - 1:
%next = index[current + 1]
%else:
%next = index[current]
%end
<script>
  document.onkeydown = function(evt) {
  evt = evt || window.event;
  if (document.activeElement.id == "query")
    return;
  switch (evt.keyCode) {
    case 83:
      scrollBy(0,20);
      evt.preventDefault();
      break;
    case 74:
      scrollBy(0,20);
      evt.preventDefault();
      break;
    case 87:
      scrollBy(0,-20);
      evt.preventDefault();
      break;
    case 75:
      scrollBy(0,-20);
      evt.preventDefault();
      break;
    case 65:
      window.location.assign('/{{prev}}');
      evt.preventDefault();
      break;
    case 72:
      window.location.assign('/{{prev}}');
      evt.preventDefault();
      break;
    case 68:
      window.location.assign('/{{next}}');
      evt.preventDefault();
      break;
    case 76:
      window.location.assign('/{{next}}');
      evt.preventDefault();
      break;
    case 81:
      window.location.assign('/');
      evt.preventDefault();
      break;
    }
  };
</script>
<table cellpadding="0" cellsspacing="0" id="content">
<tr>
<td>
<div class="single-message">
%if points.is_operator(auth):
<a class="blacklisted" href="/s/blacklisted/{{msgid}}" title="Поместить сообщение в ЧС"><i class="fa fa-trash"></i></a>
%end
<div id="echo-buttons">
%if current > 0:
<a href="/{{index[0]}}" class="echo-button" title="В начало"><i class="fa fa-fast-backward"></i></a>
<a href="/{{prev}}" class="echo-button" title="Предыдущее сообщение"><i class="fa fa-step-backward"></i></a>
%else:
<a class="echo-button-disabled"><i class="fa fa-fast-backward"></i></a>
<a class="echo-button-disabled"><i class="fa fa-step-backward"></i></a>
%end
%node=address.split(",")
%if len(node) == 2 and node[0] == nodename:
<a href="/private/{{point}} <{{address}}>" class="echo-button" title="Личное сообщение"><i class="fa fa-envelope"></i></a>
%end
<a href="/reply/{{echoarea[0]}}/{{msgid}}" class="echo-button" title="Ответить"><i class="fa fa-reply"></i></a>
%if points.is_operator(auth):
<a href="/favorites/{{msgid}}" class="echo-button" title="Избранное"><i class="fa fa-heart"></i></a>
<a href="/edit/{{echoarea[0]}}/{{msgid}}" class="echo-button" title="Редактировать"><i class="fa fa-edit"></i></a>
%end
%if current < len(index) - 1:
<a href="/{{next}}" class="echo-button" title="Следующее сообщение"><i class="fa fa-step-forward"></i></a>
<a href="/{{index[-1]}}" class="echo-button" title="В конец"><i class="fa fa-fast-forward"></i></a>
%else:
<a class="echo-button-disabled"><i class="fa fa-step-forward"></i></a>
<a class="echo-button-disabled"><i class="fa fa-fast-forward"></i></a>
%end
</div>

<div class="message-header">
%if repto:
<b>Ответ на:</b> <a href="/{{repto}}">{{repto}}</a><br>
%end
<b>От:</b> {{point}} ({{address}}) {{time}}<br>
<b>Кому:</b> {{to}}<br>
<b>Тема:</b> {{subj}}
</div>
{{!api.body_render("\n".join(body))}}
</div>
<div class="echo-title">
[{{current + 1}} / {{len(index)}}]
</div>
</table>
<img id="keys" src="lib/buttons.svg">
%include tpl/footer.tpl