%import i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<h3>{{i18n.tr("Registration")}}</h3>
</div><br>

<div id="conferences" class="width90">
<h3>{{i18n.tr("Enter username and password")}}</h3>
%if alarm:
<span class="alarm">{{alarm}}</span>
%end
<form method="post" enctype="multipart/form-data" action="/registration">
<input type="text" name="username" class="input input_line login" placeholder="username"><br>
<input type="password" name="password" class="input input_line login" placeholder="password"><br>
<button class="form-button">{{i18n.tr("Register")}}</button>
</form>
</div>
%include tpl/footer.tpl