<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.1 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="/lib/css/font-awesome.min.css">
    <link rel="icon" href="/lib/idec.png" type="image/png">
    <link rel="stylesheet" type="text/css" href="/lib/css/style.css">
    <meta name="viewport" content="width=device-width; initial-scale=1.0">
    <title>{{nodename}}</title>
    <script>
      window.onscroll = function() {
      var top = document.body.scrollTop + document.documentElement.scrollTop == 0;
      document.getElementById('ontop').style.display = top ? 'none' : 'block';
      }
    </script>
  </head>
  %import random
  %image = random.choice(background)
  <body style="background: url(/lib/{{image}}) no-repeat; background-size: cover; -webkit-background-size: cover; background-attachment: fixed;">
    <div id="ontop" class="ontop">
     <div id="bottom-buttons">
      <a href="/" class="bbutton"><i class="fa fa-home"></i></a>
%if defined('echoarea') and echoarea:
      <a href="/new/{{echoarea[0]}}" class="bbutton"><i class="fa fa-plus-circle"></i></a>
%end
      <i class="fa fa-arrow-circle-up bbutton" onclick="document.body.scrollTop = document.documentElement.scrollTop = 0;"></i>
     </div>
    </div>
    <center>
