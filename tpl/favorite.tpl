%import api, math
%include tpl/header.tpl nodename=nodename, dsc=dsc, echoarea=False, hidehome=False, hidemenu=False, background=background

<div id="panel">
<div id="buttons">
<a href="/" class="button"><i class="fa fa-home"></i><span class="caption"> Главная</span></a>
</div>
<h3><span class="caption">{{echoarea[1]}}</span></h3>
%if msgid:
<div id="rbuttons">
<a href="/favlist/{{echoarea[0]}}" class="button"><i class="fa fa-arrow-circle-left"></i><span class="caption"> Назад</span></a>
</div>
%end
</div><br>

%if not page:
%page = len(msglist) / 50
%if page - math.floor(page) > 0:
%page = math.floor(page) + 1
%else:
%page = math.floor(page)
%end
%end

%start = (page - 1) * 50
%if start + 50 > len(msglist):
%last = len(msglist)
%else:
%last = start + 50
%end

%curmsg = False
%for msg in msglist[start:last]:
%if msg["msgid"] == msgid:
%curmsg = msg
%end
%end

<div id="content">
%if curmsg:
%msg = curmsg
<div class="message">
<a name="{{msg["msgid"]}}"></a>
<a href="/{{msg["msgid"]}}" class="current-echorow" style="text-decoration: none">
<b title="{{msg["from"]}}">{{msg["from"]}}</b> to {{msg["to"]}} @ {{msg["subject"]}} <i class="fa fa-clock-o"></i> {{api.formatted_time(msg["time"])}}</a>
<br><br>
{{!api.body_render("\n".join(msg["body"]))}}
</div>
%end

<table cellpaddint="0" cellspacing="0" class="single-message msglist">
<tr>
<th>Тема</th>
<th align="right">От кого &#x279C; Кому</th>
</tr>
%for msg in msglist[start:last]:
%if msg["msgid"] == msgid:
<tr class="current-echorow">
%else:
<tr class="echorow">
%end
<td><a name="{{msg["msgid"]}}"></a><a href="/favlist/{{echoarea[0]}}/{{msg["msgid"]}}">{{msg["subject"]}}</a></td>
<td style="text-align: right;">{{msg["from"]}} &#x279C; {{msg["to"]}}</td>
</tr>
%end
%end
</table>
</div>

%include tpl/favpaginator.tpl echoarea=echoarea[0], msglist=msglist, page=page, onpage=50, shortlist=True
<br>
%include tpl/footer.tpl
