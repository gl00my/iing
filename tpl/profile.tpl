%import i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<h3>{{i18n.tr("Profile")}}</h3>
</div><br>

<div id="edit">
<div class="width90 left">
<b>{{i18n.tr("Login")}}:</b> {{username}}
<b>Authstr:</b> {{auth}}<br>
<b>{{i18n.tr("Address")}}:</b> {{nodename}}, {{addr}}<br>
<b>{{i18n.tr("Read mode")}}:
%if feed == 1:
<a href="/s/feed/0">{{i18n.tr("Feed")}}</a>
%else:
<a href="/s/feed/1">{{i18n.tr("Mailbox")}}</a>
%end
<br>
<b>{{i18n.tr("Language")}}:
%if lang == 'en':
<a href="/s/language/ru">English</a>
%else:
<a href="/s/language/en">Русский</a>
%end
<br><br>
<a class="form-button" href="/logout">{{i18n.tr("Log out")}}</a><br><br>
</div>
</div>
%include tpl/footer.tpl