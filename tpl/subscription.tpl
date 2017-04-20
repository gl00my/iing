%include tpl/header.tpl nodename=nodename, dsc=dsc, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i> Главная</a>
</div>
<h3>Управление подписками</h3>
</div><br>

<center>
<table id="conferences" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr>
<td width="50%" valign="top">
<form method="post" enctype="multipart/form-data" action="/s/subscription">
<textarea name="subscription" cols="40" rows=20" class="input" placeholder="Введите список конференций">
%for ea in subscription:
{{ea}}
%end
</textarea><br>
<label><input type="checkbox" name="default" value="1">Вернуться к списку конференций по-умолчанию</label><br><br>
<button class="form-button">Сохранить</button>
</form>
</td>
<td valign="top">
<table cellpadding="0" cellspacing="0" border="0" id="echolist">
%for echoarea in echoareas:
<tr>
<td>
{{echoarea[0]}}
</td>
<td>
{{echoarea[1]}}
</td>
<td>
{{echoarea[2]}}
</td>
</tr>
%end
</table>
</td>
</tr>
</table>
</center>
<br>

%include tpl/footer.tpl