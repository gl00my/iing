%pages = len(msglist) / onpage
%if pages - math.floor(pages) > 0:
%pages = math.floor(pages) + 1
%else:
%pages = math.floor(pages)
%end
%if pages > 1:
<center>
%for i in range(1, pages + 1):
%if i == 1 or i == pages or abs(i - page) < 2:
%if i == page:
<a href="/favlist/{{echoarea}}/{{msgid}}/{{i}}" class="page current_page">{{i}}</a>
%else:
<a href="/favlist/{{echoarea}}/{{msgid}}/{{i}}" class="page">{{i}}</a>
%end
%elif i < page and i == 2:
<a class="page">. . .</a>
%elif i > page and i == pages - 1:
<a class="page">. . .</a>
%end
%end
</center>
%end
