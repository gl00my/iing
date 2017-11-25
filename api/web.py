import api, points, base64, math, urllib, time, json, i18n
from api.bottle import *

def get_page(n):
    return math.floor(n / 50) + 1

def get_pages(n):
    if n == 0:
        return 1;
    return math.ceil(n / 50)

def set_user_conf(name, value):
    auth = request.get_cookie("authstr")

    if not points.is_point(auth):
        return response.set_cookie(name, value, path="/", max_age=180*24*60*60, secret='some-secret-key')
    try:
        cfg = json.loads(open("profiles/" + auth, "r").read())
    except:
        cfg = {}
    if not (type(cfg) is dict):
        cfg = {}
    cfg[name] = value
    open("profiles/" + auth, "w").write(json.dumps(cfg))

def get_user_conf(name, cookie = True):
    auth = request.get_cookie("authstr")
    if not points.is_point(auth):
        if not cookie:
            return False
        return request.get_cookie(name, secret='some-secret-key')
    try:
        cfg = json.loads(open("profiles/" + auth, "r").read())
    except:
        cfg = {}
    if name in cfg:
        return cfg[name]
    return False

def get_last_cookie(e):
    if e.startswith('.'):
        return False
    auth = request.get_cookie("authstr")
    if not points.is_point(auth):
        last = request.get_cookie("last", secret='some-secret-key')
        if not last or not (e in last):
            return False
        return last[e]
    last = get_user_conf('last') or {}
    if not last or not (e in last):
        return False
    return last[e]

def set_last_cookie(e, msg):
    if e.startswith('.'):
        return True
    auth = request.get_cookie("authstr")
    if not points.is_point(auth):
        last = request.get_cookie("last", secret='some-secret-key')
        if not (type(last) is dict):
            last = {}
        last[e] = msg
        return response.set_cookie("last", last, path="/", max_age=180*24*60*60, secret='some-secret-key')
    last = get_user_conf('last') or {}
    last[e] = msg
    set_user_conf('last', last)
    return last[e]

def get_subscription():
    return get_user_conf("subscription") or []

def set_subscription(subscription):
    return set_user_conf("subscription", subscription)

def get_feed():
    return get_user_conf("feed") or 1

def set_feed(feed):
    return set_user_conf("feed", feed)

def get_lang():
    lang = get_user_conf("lang")
    if not lang:
        l = request.headers.get('Accept-Language')
        if l and l.startswith("ru"):
            lang = 'ru'
        else:
            lang = 'en'
    return lang

def set_lang(lang):
    return set_user_conf("lang", lang)

def private_echo_name(ea):
    m = api.get_first_msg(ea)
    if m:
        return (m[3] + " / " + m[5] + " / " + m[6][:16] + "...")
    else:
        return (ea[0:8] + "...")

def echoes(subscription):
    allechoareas = []

    for echoarea in subscription:
        temp = echoarea

        current = get_last_cookie(echoarea[0])

        echoarea_msglist = api.get_echoarea(echoarea[0])

        if current in echoarea_msglist:
            new = len(echoarea_msglist) - echoarea_msglist.index(current) - 1
        else:
            new = 0
            current = False

        if not current and new == 0 and len(echoarea_msglist) > 0:
            new = len(echoarea_msglist)

        if new > 0:
            last = echoarea_msglist[-new];
        elif len(echoarea_msglist) > 0:
            last = echoarea_msglist[-1];
        else:
            last = False

        temp.append(new)
        temp.append(last)

        if last:
            temp.append(get_page(echoarea_msglist.index(last)))
        else:
            temp.append(get_pages(len(echoarea_msglist)))

        vea = api.is_vea(echoarea[0])
        if vea:
            temp.append(i18n.tr(vea[2]) + ": " + vea[3])
        elif echoarea[0].startswith("private."):
            temp.append(echoarea[1])
        else:
            temp.append(echoarea[0])

        allechoareas.append(temp)

    return allechoareas

def subscriptions():
    if api.nosubscription:
        subscription = api.subscribes
        if len(subscription) == 0:
            return api.echoareas
    else:
        subscription = get_subscription()

    flag = False

    if not subscription:
        subscription = []
        for ea in api.subscribes:
            subscription.append(ea)

        if len(api.subscribes) == 0:
            for ea in api.echoareas:
                subscription.append(ea[0])
        flag = True
    else:
        for ea in api.subscribes:
            if not (ea in subscription):
                flag = True
                subscription.append(ea)
    if flag:
        set_subscription(subscription)

    s = subscription
    subscription = []

    for ea in s:
        if ea.startswith("private."):
            subscription.append([ea, private_echo_name(ea)])
        for e in api.echoareas:
            if ea == e[0]:
                subscription.append(e)
                break
    auth = request.get_cookie("authstr")

    if auth:
        subscription.append(["mail.to@"+auth, i18n.tr("Received")])
        subscription.append(["mail.from@"+auth, i18n.tr("Sent")])

    return subscription

def subscribe(ea):
    if not api.echo_filter(ea):
        return False
    s = get_subscription()
    if not (ea in s):
        s.append(ea)
        set_subscription(s)
    return True

@route("/subscribe/<ea>")
def routesubscribe(ea):
    if not subscribe(ea):
        return redirect("/")
    return redirect("/" + ea)

@route("/unsubscribe/<ea>")
def unsubscribe(ea):
    ns = []
    s = get_subscription()
    for e in s:
        if ea != e:
            ns.append(e)
    set_subscription(ns)
    return redirect("/")

@route("/")
def index():
    echoareas = []
    subscription = subscriptions()
    ea = [[echoarea[0], echoarea[1], api.get_time(echoarea[0])] for echoarea in subscription]
    for echoarea in sorted(ea, key=lambda ea: ea[2], reverse=True):
#        if api.is_vea(echoarea[0]):
#            continue
        msgids = api.get_echoarea(echoarea[0])
        if len(msgids) > 0:
            last = msgids[-1]
        else:
            last = False
        page = get_pages(len(msgids))
        echoareas.append({"echoname": echoarea[0], "count": len(msgids), "dsc": echoarea[1], "msg": api.get_msg(last), "last": last, "page": page})
    allechoareas = echoes(subscription)
    auth = request.get_cookie("authstr")
    msgfrom, addr = points.check_point(auth)
    feed = get_feed()
    if not feed:
        feed = 1
    else:
        feed = int(feed)
    return template("tpl/index.tpl", nodename=api.nodename, dsc=api.nodedsc, echoareas=echoareas, allechoareas=allechoareas, addr=addr, auth=auth, background=api.background, nosubscription=api.nosubscription, feed=feed)

@route("/readall")
def readall():
    echoareas = []
    subscription = subscriptions()
    last = {}
    for ea in subscription:
        last[ea[0]] = api.get_last_msgid(ea[0])
    set_user_conf("last", last)
    return redirect("/")

@route("/echolist")
def echolist():
    echoareas = []
    subscription = subscriptions()
    allechoareas = echoes(subscription)
    auth = request.get_cookie("authstr")
    msgfrom, addr = points.check_point(auth)
    feed = get_feed()
    if not feed:
        feed = 1
    else:
        feed = int(feed)
    return template("tpl/echolist.tpl", nodename=api.nodename, dsc=api.nodedsc, allechoareas=allechoareas, addr=addr, auth=auth, background=api.background, nosubscription=api.nosubscription, feed=feed)

def ffeed(echoarea, msgid, page):
    msglist = api.get_echoarea(echoarea)
    result = []
    last = msgid
    if not page:
        if not last:
            page = get_pages(len(msglist))
            if page == 0:
                page = 1
        else:
            page = get_page(msglist.index(last))
    page = int(page)
    start = page * 50 - 50
    end = start + 50
    for mid in msglist[start:end]:
        msg = api.get_msg(mid)
        if len(msg) > 1:
            result.append([mid, msg])
    ea = [ea for ea in api.echoareas if ea[0] == echoarea]
    if len(ea) != 1:
        ea = [echoarea, ""]
    else:
        ea = ea[0]
    vea =  api.is_vea(ea[0])
    if vea:
        ea[1] = vea[3]
        ea.append(vea[2])
    else:
        if ea[0].startswith("private."):
            ea.append(i18n.tr("Private correspondence"))
            ea[1] = private_echo_name(ea[0])
        else:
            ea.append(ea[0])

    auth = request.get_cookie("authstr")
    if len(msglist) <= end:
        end = api.get_last_msgid(echoarea)
    else:
        end = msglist[end]
    set_last_cookie(echoarea, end)
    ss = get_subscription()
    if echoarea in ss:
        ss = True
    else:
        ss = False
    return template("tpl/feed.tpl", subscribe = ss, nodename=api.nodename, dsc=api.nodedsc, echoarea=ea, page=page, msgs=result, msgid=msgid, background=api.background, auth=auth)

@route("/<e1>.<e2>")
@route("/<e1>.<e2>/<page>")
@route("/<e1>.<e2>/<page>/<msgid>")
def echoareas(e1, e2, msgid=False, page=False):
    echoarea=e1 + "." + e2
    if not get_last_cookie(echoarea):
        set_last_cookie(echoarea, api.get_last_msgid(echoarea));
    feed = get_feed()
    if not feed or api.is_vea(echoarea):
        feed = 1
    else:
        feed = int(feed)
    last = msgid or get_last_cookie(echoarea)
    if not last in api.get_echoarea(echoarea):
        last = False
    if not last:
        last = api.get_last_msgid(echoarea)
    index = api.get_echoarea(echoarea)
    if feed == 0 and len(index) > 0 and index[-1] != last and last in index:
        last = index[index.index(last) + 1]
    if len(index) == 0:
        last = False

    if echoarea != "favicon.ico":
        if last or api.is_vea(echoarea):
            if feed == 0:
                redirect("/" + last)
            else:
                return ffeed(echoarea, last, page)
        else:
            redirect("/new/" + echoarea)

@route("/<msgid>")
def showmsg(msgid):
    if api.msg_filter(msgid):
        body = api.get_msg(msgid)
        if body != []:
            msgfrom, addr = points.check_point(request.get_cookie("authstr"))
            kludges = body[0].split("/")
            if "repto" in kludges:
                repto = kludges[kludges.index("repto") + 1]
            else:
                repto = False
            if len(body) > 0:
                echoarea = [ea for ea in api.echoareas if ea[0] == body[1]]
                if len(echoarea) == 0:
                    echoarea = [body[1], ""]
                    if body[1].startswith("private."):
                        echoarea[1] = i18n.tr("Private correspondence")
                else:
                    echoarea = echoarea[0]
            else:
                echoarea = ["", ""]
            t = api.formatted_time(body[2])
            point = body[3]
            address = body[4]
            to = body[5]
            subj = body[6]
            body = body[8:]
            index = api.get_echoarea(echoarea[0])
            current = index.index(msgid)
            set_last_cookie(echoarea[0], msgid)
            auth = request.get_cookie("authstr")
            feed = get_feed()
            if not feed:
                feed = 1
            else:
                feed = int(feed)
            if feed == 1:
                try:
                    page = get_page(index.index(msgid))
                except:
                    page = get_pages(len(index))
            else:
                page = False
            ss = get_subscription()
            if echoarea[0] in ss:
                ss = True
            else:
                ss = False
            return template("tpl/message.tpl", subscribe = ss, nodename=api.nodename, echoarea=echoarea, index=index, msgid=msgid, repto=repto, current=current, time=t, point=point, address=address, to=to, subj=subj, body=body, msgfrom=msgfrom, background=api.background, auth=auth, feed=feed, page=page)
        else:
            redirect("/")
    else:
        redirect("/")

@route("/msglist/<echoarea>")
@route("/msglist/<echoarea>/<msgid>")
@route("/msglist/<echoarea>/<msgid>/<page>")
def msg_list(echoarea, page=False, msgid=False):
    msglist = api.get_echoarea(echoarea)
    result = []
    for mid in msglist:
        msg = api.get_msg(mid)
        try:
            subject = msg[6]
            f = msg[3]
            t = msg[5]
            result.append({"msgid": mid, "subject": subject, "from": f, "to": t})
        except:
            None
    ea = [ea for ea in api.echoareas if ea[0] == echoarea] #[0]
    if ea:
        ea = ea[0]
    else:
        ea = [ echoarea, "" ]
    if not page:
        if not msgid:
            page = get_pages(len(msglist))
        else:
            page = get_page(msglist.index(msgid))
        if page == 0:
            page = 1
    return template("tpl/msglist.tpl", nodename=api.nodename, dsc=api.nodedsc, page=int(page), echoarea=ea, msgid=msgid, msglist=result, topiclist=False, background=api.background)

@route("/new/<e1>.<e2>")
@route("/reply/<e1>.<e2>")
@route("/reply/<e1>.<e2>/<msgid>")
@post("/reply/<e1>.<e2>/<msgid>")
@post("/new/<e1>.<e2>")
def reply(e1, e2, msgid = False):
    echoarea = e1 + "." + e2
    if request.POST and request.POST.action == "submit":
        return save_message(echoarea, msgid)
    addr = request.forms.get("to")
    subj = request.forms.get("subj")
    msgbody = request.forms.get("msgbody")
    if api.is_vea(echoarea):
        return redirect("/")
    auth = request.get_cookie("authstr")
    if msgid:
        msg = api.get_msg(msgid)
    else:
        msg = False
    return template("tpl/reply.tpl", msgbody = msgbody or False, nodename=api.nodename, dsc=api.nodedsc, echoarea=echoarea, msgid=msgid, msg=msg, auth=auth, hidehome=False, topiclist=False, background=api.background, addr = addr or False, subj = subj)

@route("/private")
@route("/private/<addr>")
def private(addr = False):
    auth = request.get_cookie("authstr")
    if not auth:
        return redirect("/")
    echoarea = "private." + api.hsh(auth + str(time.time())).lower()
    return template("tpl/reply.tpl", msgbody = False, nodename=api.nodename, dsc=api.nodedsc, echoarea=echoarea, msgid=False, msg=False, addr = addr, auth=auth, hidehome=False, topiclist=False, background=api.background, subj = False)

@post("/a/savemsg/<echoarea>")
@post("/a/savemsg/<echoarea>/<msgid>")
def save_message(echoarea, msgid = False):
    if api.echo_filter(echoarea):
        subj = request.forms.get("subj")
        msgbody = request.forms.get("msgbody")
        if len(subj) > 0 and len(msgbody) > 0:
            pauth = request.forms.get("authstr")
            msgfrom, addr = points.check_point(pauth)
            if not addr:
                return "auth error!"
            response.set_cookie("authstr", pauth, path="/", max_age=3600000000)
            msg = ""
            msg = msg + echoarea + "\n"
            msg = msg + request.forms.get("to") + "\n"
            msg = msg + subj + "\n\n"
            if msgid:
                msg = msg + "@repto:" + msgid + "\n"
            msg = msg + msgbody
            msg = base64.b64encode(msg.encode("utf8"))
            message=api.toss_msg(msgfrom, addr, msg)
            if message.startswith("msg ok"):
                if echoarea.startswith("private."):
                    subscribe(echoarea)
                redirect("/%s" % message[7:])
            return message
    redirect("/")

@post("/s/subscription")
@route("/s/subscription")
def subscription():
    s = request.forms.get("subscription")
    subscription = []
    if request.forms.get("default"):
        for ea in api.echoareas:
            subscription.append(ea[0])
        for ea in s.strip().replace("\r", "").split("\n"):
            if not ea in subscription:
                subscription.append(ea)
        set_subscription(subscription)
        redirect("/")
    if request.POST:
        for ea in s.strip().replace("\r", "").split("\n"):
            if api.echo_filter(ea):
                subscription.append(ea)
        set_subscription(subscription)
        redirect("/")
    subscription = get_subscription()
    echoareas = []
    for echoarea in api.echoareas:
        echoareas.append([echoarea[0], api.get_echoarea_count(echoarea[0]), echoarea[1]])
    return template("tpl/subscription.tpl", nodename=api.nodename, dsc=api.nodedsc, echoareas=echoareas, subscription=subscription, background=api.background)

def sort_files(files):
    filelist = []
    for f in sorted(files):
        if f[0].endswith("/") and not f in filelist:
            filelist.append(f)
    for f in sorted(files):
        if not f in filelist:
            filelist.append(f)
    return filelist

@route("/s/filelist")
@route("/s/filelist/<d>")
def filelist(d = False):
    auth = request.get_cookie("authstr")
    msgfrom, addr = points.check_point(auth)
    files = api.get_public_file_index(d)
    if not addr:
        return template("tpl/filelist.tpl", nodename=api.nodename, dsc=api.nodedsc, files=sort_files(files), auth=False, background=api.background, d=d)
    files = files + api.get_file_index(d)
    try:
        files = files + api.get_private_file_index(msgfrom, d)
    except:
        None
    return template("tpl/filelist.tpl", nodename=api.nodename, dsc=api.nodedsc, files=sort_files(files), auth=auth, background=api.background, d=d)

@route("/s/download/<filename:path>")
def download(filename):
    filename = filename.split("/")
    return static_file(filename[-1], "files/%s" % "/".join(filename[:-1]))

@route("/s/blacklisted/<msgid>")
def blacklist(msgid):
    if api.msg_filter(msgid):
        auth = request.get_cookie("authstr")
        if points.is_operator(auth):
            api.delete_msg(msgid)
            open("blacklist.txt", "a").write(msgid + "\n")
    redirect("/")

@route("/s/language/<lang>")
def slang(lang):
    set_lang(lang)
    redirect("/profile")

@route("/s/feed/<feed>")
def sfeed(feed):
    set_feed(feed)
    redirect("/profile")

@route("/login")
@post("/login")
def login():
    username = request.forms.get("username")
    password = request.forms.get("password")
    auth = points.login(username, password)
    if auth:
        if auth != "error":
            response.set_cookie("authstr", auth, path="/", max_age=3600000000)
            redirect("/")
        else:
            return template("tpl/login.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, username=username, auth=auth, registration=api.registration, alarm=i18n.tr("Wrong username or password!"))
    return template("tpl/login.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, registration=api.registration, username=False, auth=False, alarm=False)

@route("/profile")
def profile():
    auth = request.get_cookie("authstr")
    username, addr = points.check_point(auth)
    feed = get_feed()
    lang = get_lang() or 'en'
    if not feed:
        feed = 1
    else:
        feed = int(feed)
    return template("tpl/profile.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, username=username, auth=auth, addr=addr, feed=feed, lang = lang)

@route("/logout")
def logout():
    response.set_cookie("authstr", "", path="/", max_age=-1, expires=0)
    redirect("/")

@route("/registration")
@post("/registration")
def registration():
    if api.registration:
        username = request.forms.get("username")
        password = request.forms.get("password")

        if username and not points.username_filter(username):
            return template("tpl/registration.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, alarm=i18n.tr("Bad username!"))

        if username and password:
            if points.check_username(username):
                return template("tpl/registration.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, alarm=i18n.tr("Such username already exists!"))
            else:
                hsh, phash = points.make_point(username, password)
                points.save_point(phash, username, hsh)
                response.set_cookie("authstr", phash, path="/", max_age=3600000000)
                redirect("/")
        return template("tpl/registration.tpl", nodename=api.nodename, dsc=api.nodedsc, background=api.background, alarm=False)
    else:
        redirect("/")

@route("/rss/<eas:path>")
def rss(eas):
    response.set_header("content-type", "application/rss+xml; charset=utf-8")
    msgs = []
    echoarea = ""
    for ea in eas.split("/"):
        msglist = api.get_echoarea(ea)
        if echoarea != "":
            echoarea += " / "
        echoarea += ea
        for msgid in msglist[-50:]:
            msgs.append([msgid, api.get_msg(msgid)])
    msgs = sorted(msgs, key = lambda m: m[1][2], reverse=True)
    return template("tpl/rss.tpl", nodename=api.nodename, dsc=api.nodedsc, nodeurl=api.nodeurl, msgs=msgs, echoarea=echoarea)

@route("/lib/css/<filename>")
def pcss(filename):
    return static_file(filename, root="lib/css/")

@route("/lib/fonts/<filename>")
def pcss(filename):
    return static_file(filename, root="lib/fonts/")

@route("/lib/<filename>")
def plib(filename):
    response = static_file(filename, root="lib/")
    response.set_header("Cache-Control", "public, max-age=604800")
    return response

#   return static_file(filename, root="lib/")


@route("/edit/<e1>.<e2>/<msgid>")
def edit(e1, e2, msgid):
    echoarea = e1 + "." + e2
    auth = request.get_cookie("authstr")
    if points.is_operator(auth):
        msg = api.get_msg(msgid)
        return template("tpl/edit.tpl", nodename=api.nodename, dsc=api.nodedsc, echoarea=echoarea, msgid=msgid, msg=msg, auth=auth, hidehome=False, topiclist=False, background=api.background)
    redirect("/")

@post("/a/editmsg/<echoarea>/<msgid>")
def edit_messsage(echoarea, msgid):
    auth = request.get_cookie("authstr")
    if points.is_operator(auth):
        subj = request.forms.get("subj")
        msgbody = request.forms.get("msgbody")
        message=api.edit_msg(msgid, subj, msgbody)
        if message.startswith("msg ok"):
            redirect("/%s" % message[7:])
    redirect("/")

@route("/favorites")
@route("/favorites/<msgid>")
def favorites(msgid = False):
    favlist = []
    lst = []
    for n in os.listdir("favorites"):
        if n.endswith('txt'):
            favlist.append(n[0:-4])
    favlist = reversed(sorted(favlist))
    for n in favlist:
            t = open("favorites/" + n + ".txt", "r").readline()
            lst.append((n, t))
    return template("tpl/favlist.tpl", nodename = api.nodename, dsc = api.nodedsc, msgid=msgid, favlist=lst, topiclist=False, background = api.background)

@route("/favadd/<fname>/<msgid>")
def favlist_add(fname, msgid):
    auth = request.get_cookie("authstr")
    if not points.is_operator(auth):
        return redirect("/")

    try:
        lst = open("favorites/" + fname + ".txt", "r").read().split("\n")
    except:
        return redirect("/")

    if not msgid in lst:
        open("favorites/" + fname + ".txt", "a").write("\n" + msgid)
    return redirect("/favlist/" + fname + "/" + msgid)

@route("/favlist/<fname>")
@route("/favlist/<fname>/<msgid>")
@route("/favlist/<fname>/<msgid>/<page>")
def sticky_list(fname, page=False, msgid=False):
    try:
        msglist = open("favorites/" + fname + ".txt", "r").read().split("\n")
    except:
        return redirect("/")
    ea = [ fname, msglist[0] ];
    msglist = msglist[1:]
    result = []
    for mid in msglist:
        msg = api.get_msg(mid)
        try:
            subject = msg[6]
            f = msg[3]
            t = msg[5]
            b = msg[8:]
            time = msg[2]
            result.append({"msgid": mid, "subject": subject, "from": f, "to": t, "body": b, "time": time})
        except:
            None
    if not page:
        page = msgid and get_page(msglist.index(msgid)) or 0
        if page == 0:
            page = 1
    return template("tpl/favorite.tpl", nodename=api.nodename, dsc=api.nodedsc, page=int(page), echoarea=ea, msgid=msgid, msglist=result, topiclist=False, background=api.background)

@route("/search/<e1>.<e2>")
def search(e1, e2):
    echoarea = e1 + "." + e2
    regexp = request.query.regexp
    regexp = base64.urlsafe_b64encode(regexp.encode("utf-8")) #.decode("utf-8")
    return redirect("/.query@"+ urllib.parse.quote(echoarea) + "@" + urllib.parse.quote(regexp))

@hook('before_request')
def loadconf():
    i18n.setlang(get_lang())
    api.load_config()
