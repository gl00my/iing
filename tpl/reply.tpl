%import i18n, api
%include tpl/header.tpl nodename=nodename, dsc=dsc, hidemenu=True, background=background

%if msgid:
%title=i18n.tr("Reply to")+ " " + msgid
%echoarea=msg[1]
%repto = msgid
%to = msg[3]
%if not subj:
%subj = msg[6]
%if not subj.startswith("Re: "):
%subj = "Re: " + subj
%end
%end
%else:
%title=i18n.tr("New message in") + " " + echoarea
%repto = ""
%to = addr or "All"
%end
%text = ""
%if msgbody:
%text = msgbody
%end
<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<h3><span class="caption">{{title}}</span></h3>
</div>
<br>
<div id="conferences" class="width90">

%if msg:
<div class="single-message reply">
{{!api.body_render("\n".join(msg[8:]))}}
</div><br>
%end

<br>
<center>
%if msgid:
<form method="post" enctype="multipart/form-data" action="/a/savemsg/{{echoarea}}/{{msgid}}">
<input type="hidden" name="to" value="{{to}}">
%else:
<form method="post" enctype="multipart/form-data" action="/a/savemsg/{{echoarea}}">
<input type="text" name="to" class="input input_line" placeholder="{{i18n.tr('To')}}" value="{{to}}"><br>
%end
<input type="hidden" name="repto" value="{{repto}}">
%if subj:
<input type="text" name="subj" class="input input_line" placeholder="{{i18n.tr('Subject')}}" value="{{subj}}"><br>
%else:
<input type="text" name="subj" class="input input_line" placeholder="{{i18n.tr('Subject')}}"><br>
%end
<textarea name="msgbody" cols="80" rows=10" class="input" placeholder="{{i18n.tr('Enter the text body')}}">{{text}}</textarea><br>
%if not auth:
<input type="text" name="authstr" class="input input_line" placeholder="{{i18n.tr('auth-key')}}"><br>
%else:
<input type="hidden" name="authstr" class="input input_line" placeholder="auth-str" value={{auth}}><br>
%end
<button type="submit" class="form-button"><i class="fa fa-share-square"></i> {{i18n.tr('Send')}}</button>
%if msgid:
<button type="submit" formaction="/reply/{{echoarea}}/{{msgid}}" class="form-button"><i class="fa fa-share-square"></i> {{i18n.tr('Preview')}}</button>
%else:
<button type="submit" formaction="/new/{{echoarea}}" class="form-button"><i class="fa fa-share-square"></i> {{i18n.tr('Preview')}}</button>
%end
</form>

%if msgbody:
<br>
<div class="single-message reply">
{{!api.body_render(api.spoiler_body(msgbody))}}
</div><br>
%end

</center>

<hr/>
<h2>{{i18n.tr('Help')}}</h2>

<div class='help'>

<div class='help-item'>
<h3>{{i18n.tr('Code blocks')}}</h3>
<pre>
====
for i=1,10 do
    print "hello world"
end
====
</pre>

</div>
<div class='help-item'>

<h3>{{i18n.tr('Quotes')}}</h3>
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,<br>
> sed do eiusmod tempor incididunt ut labore et dolore magna<br>

</div>
<div align="left" style="display: inline-block">

<h3>{{i18n.tr('Spoilers')}}</h3>
Open text...<br>
&#37;&#37;spoiler&#37;&#37;<br>
Top secret! Till end of message...<br>

</div>
<div class='help-item'>

<h3>{{i18n.tr('Headers and splitters')}}</h3>
== Chapter 1<br>
A long time ago in a galaxy far, far away....<br>
----<br>
That's all!<br>
</div>
</div>

</div>
<br>

%include tpl/footer.tpl