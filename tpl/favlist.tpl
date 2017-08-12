%import api, math, i18n
%include tpl/header.tpl nodename=nodename, dsc=dsc, echoarea=False, hidehome=False, hidemenu=False, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> {{i18n.tr("Home")}}</span></a>
</div>
<h3><span class="caption">{{i18n.tr('Favorites')}}</span></h3>
</div><br>

<div id="content">
<table cellpaddint="0" cellspacing="0" class="single-message msglist">
<tr>
<th>{{i18n.tr('Favorites lists')}}:</th>
</tr>
%for f in favlist:
<tr class="echorow">
%if msgid:
<td><a href="/favadd/{{f[0]}}/{{msgid}}">{{f[1]}}</a></td>
%else:
<td><a href="/favlist/{{f[0]}}">{{f[1]}}</a></td>
%end
</tr>
%end
</table>
</div>
%include tpl/footer.tpl
