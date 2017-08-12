%import i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, hidemenu=True, background=background
%title=i18n.tr('Edit the') + " " + msgid
%msgbody = msg[8:]
%subj = msg[6]
%if not subj.startswith("Re: "):
%subj = subj
%end
<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<h3><span class="caption">{{title}}</span></h3>
</div>
<br>

<br>
<center>
<form method="post" enctype="multipart/form-data" action="/a/editmsg/{{echoarea}}/{{msgid}}">
%if subj:
<input type="text" name="subj" class="input input_line" placeholder="{{i18n.tr('Subject')}}" value="{{subj}}"><br>
%else:
<input type="text" name="subj" class="input input_line" placeholder="{{i18n.tr('Subject')}}"><br>
%end
<textarea name="msgbody" cols="80" rows=10" class="input" placeholder="{{i18n.tr('Enter the text body')}}">
%for line in msg[8:]:
{{line}}
%end
</textarea><br>
<button class="form-button"><i class="fa fa-share-square"></i> {{i18n.tr('Send')}}</button>
</form>
</center>
</div>
<br>
%include tpl/footer.tpl