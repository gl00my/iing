%import i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<span class="caption"><h3>{{i18n.tr("Edit subscriptions")}}</h3></span>
</div><br>

<center>
<div id="subscriptions" cellpadding="0">
<table cellpadding="0" cellspacing="0" border="0" id="echolist">
%for echoarea in echoareas:
<tr>
<td>
{{echoarea[0]}}
</td>
<td>
{{echoarea[1]}}
</td>
<td class="caption">
{{echoarea[2]}}
</td>
</tr>
%end
</table>
<form id="sform" method="post" enctype="multipart/form-data" action="/s/subscription">
<textarea name="subscription" cols="40" rows=20" class="input" placeholder="{{i18n.tr('Edit list of conferences')}}">
%for ea in subscription:
{{ea}}
%end
</textarea><br>
<label><input type="checkbox" name="default" value="1">{{i18n.tr("Add all conferences")}}</label><br><br>
<button class="form-button">{{i18n.tr("Save")}}</button>
</form>
</div>
</center>
<br>

%include tpl/footer.tpl