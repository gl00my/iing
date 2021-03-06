%import api, i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<script>
  document.onkeydown = function(evt) {
  evt = evt || window.event;
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
    }
  };
</script>

<div id="panel">
<span id="container"><h3 id="nodedsc"><a href="/"><img src="/lib/idec_grey.png" width="20"> {{dsc}}</a></h3></span>
<a href="/echolist" id="echolist-button" class="button"><i class="fa fa-bars"></i></a>
<div id="rbuttons">
<a href="favorites" class="button"><i class="fa fa-heart"></i><span class="caption"> {{i18n.tr("Favorites")}}</span></a>
<a href="https://instead-hub.github.io/page/club/" class="button"><i class="fa fa-info-circle"></i><span class="caption"> {{i18n.tr("About")}}</span></a>
%if not nosubscription:
<a href="/s/subscription" class="button"><i class="fa fa-paper-plane"></i><span class="caption"> {{i18n.tr("Subscriptions")}}</span></a>
%end
<a href="/s/filelist" class="button"><i class="fa fa-floppy-o"></i><span class="caption"> {{i18n.tr("Files")}}</span></a>
%if addr:
<a href="/profile" class="button"><i class="fa fa-user"></i><span class="caption"> {{i18n.tr("Profile")}}</span></a>
%else:
<a href="/login" class="button"><i class="fa fa-sign-in"></i><span class="caption"> {{i18n.tr("Log in")}}</span></a>
%end
</div>
</div>

<table id="content" cellpadding="0" cellspacing="0">
<tr>
<td id="side-menu">
<div id="conferences">
<center><b>{{i18n.tr("Conferences")}}</b></center>
%unread = False
%for echoarea in allechoareas:
%if echoarea[2] == 0:
%if feed == 1 and echoarea[3]:
<a href="/{{echoarea[0]}}/{{echoarea[4]}}/{{echoarea[3]}}#{{echoarea[3]}}" class="new-button-link echo-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i>
 {{echoarea[5]}}<span class="unread">0</span></a>
%else:
<a href="/{{echoarea[0]}}" class="new-button-link echo-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i>
 {{echoarea[5]}}<span class="unread">0</span></a>
%end
%else:
%unread = True
%if feed == 1 and echoarea[3]:
<a href="/{{echoarea[0]}}/{{echoarea[4]}}/{{echoarea[3]}}#{{echoarea[3]}}" class="new-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i>
 {{echoarea[5]}}<span class="unread">{{echoarea[2]}}</span></a>
%else:
<a href="/{{echoarea[0]}}" class="new-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i> {{echoarea[5]}}<span class="unread">{{echoarea[2]}}</span></a>
%end
%end
%end
%if unread:
<hr>
<a href="/readall" class="new-button-link" title="{{i18n.tr("Mark as read")}}">
<i class="fa fa-check-square"></i> {{i18n.tr("Mark as read")}}</a>
%end
</div>

<!-- <img id="keys" src="lib/buttons.svg"> -->
</td>
<td>

%for echoarea in echoareas:
%last_msgid = api.get_last_msgid(echoarea["echoname"])
%if feed == 1 and echoarea["last"]:
<a class="echoarea-link" href="/{{echoarea["echoname"]}}/{{echoarea["page"]}}/{{echoarea["last"]}}#{{echoarea["last"]}}"><h2 class="echo-title">{{echoarea["dsc"]}}</a> <i class="fa fa-envelope-o"></i>
{{echoarea["count"]}}</h2>
%else:
<a class="echoarea-link" href="/{{echoarea["echoname"]}}"><h2 class="echo-title">{{echoarea["dsc"]}}</a> <i class="fa fa-envelope-o"></i>
{{echoarea["count"]}}</h2>
%end
%if len(echoarea["msg"]) > 0:
<div class="message">
%#<h3 class="message-title">{{echoarea["msg"][6]}}</h3>
<b title="{{echoarea["msg"][4]}}">{{echoarea["msg"][3]}}</b> to {{echoarea["msg"][5]}} @ {{echoarea["msg"][6]}} <i class="fa fa-clock-o"></i>  {{api.formatted_time(echoarea["msg"][2])}}<br><br>
%body = echoarea["msg"][8].split("\n")
%if len(body) <= 10:
%body = api.body_render("\n".join(body))
%else:
%body = api.body_render("\n".join(body[0:10])) + "<br><br><a href=" + last_msgid + ">" + i18n.tr('Read more') + "</a>"
%end
{{!body}}
</div>
%end
%end
</td>
</tr>
</table>
<br>
%include tpl/footer.tpl