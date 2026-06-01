<!DOCTYPE html>
<html lang="en">

<head>
  <meta name="description" content="Webpage description goes here" />
  <meta charset="utf-8">
  <title>Zaloguj się!</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="author" content="">

  <link rel="shortcut icon" type="image/x-icon" href="/utils/images/favicon.ico">
  <link rel="icon" type="image/png" href="/utils/images/favicon-32x32.png" sizes="32x32" />
  <link rel="icon" type="image/png" href="/utils/images/favicon-16x16.png" sizes="16x16" />
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/utils/images/apple-touch-icon-114x114.png" />
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/utils/images/apple-touch-icon-72x72.png" />
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/utils/images/apple-touch-icon-144x144.png" />
  <link rel="apple-touch-icon-precomposed" sizes="120x120" href="/utils/images/apple-touch-icon-120x120.png" />
  <link rel="apple-touch-icon-precomposed" sizes="152x152" href="/utils/images/apple-touch-icon-152x152.png" />

  <link rel="stylesheet" href="/utils/css/bootstrap-reboot.min.css">
  <link rel="stylesheet" href="/utils/css/bootstrap.min.css">
  <link rel="stylesheet" href="/utils/css/style.css">

  <script src="/utils/jQuery/jQuery.js"></script>
  <script src="/utils/js/bootstrap.min.js"></script>
  </script>

</head>

<body class="login-page">
  {if isset($msg_success)}
    <div class="alert alert-success" id="success-alert">
      <button type="button" class="close" data-dismiss="alert">x</button>
      {$msg_success}
    </div>

    <script>
      $("#success-alert").fadeTo(4000, 500).fadeOut(500, function() {
        $("#success-alert").fadeOut(500);
      });
    </script>
    <style>
      #success-alert {
        z-index: 30;
        opacity: 500;
        width: 500px;
        top: 95px;
        position: absolute;
        left: 0px;
        right: 0px;
        margin: 0 auto;
      }
    </style>
{/if}