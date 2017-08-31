%import api, i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<div id="panel">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
<div id="rbuttons">
<a href="http://ii-net.tk/" class="button"><i class="fa fa-info-circle"></i><span class="caption"> {{i18n.tr("About")}}</span></a>
%if not nosubscription:
<a href="/s/subscription" class="button"><i class="fa fa-paper-plane"></i><span class="caption"> {{i18n.tr("Subscriptions")}}</span></a>
%end
<a href="/s/filelist" class="button"><i class="fa fa-floppy-o"></i><span class="caption"> {{i18n.tr("Files")}}</span></a>
%if addr:
<a href="/logout" class="button"><i class="fa fa-sign-out"></i><span class="caption"> {{i18n.tr("Log out")}}</span></a>
%else:
<a href="/login" class="button"><i class="fa fa-sign-in"></i><span class="caption"> {{i18n.tr("Log in")}}</span></a>
%end
</div>
</div>

<div id="echolist">
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
%if feed == 1 and echoarea[3]:
<a href="/{{echoarea[0]}}/{{echoarea[4]}}/{{echoarea[3]}}#{{echoarea[3]}}" class="new-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i> {{echoarea[5]}}<span class="unread">{{echoarea[2]}}</span></a>
%unread = True
%else:
<a href="/{{echoarea[0]}}" class="new-button-link" title="{{echoarea[1]}}"><i class="fa fa-comments"></i> {{echoarea[5]}}<span class="unread">{{echoarea[2]}}</span></a>
%end
%end
%end
%if unread:
<hr>
<a href="/readall" class="new-button-link" title="{{i18n.tr("New")}}">
<i class="fa fa-check-square"></i> {{i18n.tr("Mark as read")}}</a>
%end
</div>
</div>

%include tpl/footer.tpl