<?php

function sendMail($to, $password_hash_link)
{
  $subject = $_SERVER['HTTP_HOST']." - zmiana hasła do panelu zarządzania stroną";
  $link = "https://www.".$_SERVER['HTTP_HOST']."/admin/zmien-haslo/".$password_hash_link;
  $message = "
  <div>
    <h2>Witaj</h2>
    <p>Wysłałeś prośbę zmiany hasła w serwisie ".$_SERVER['HTTP_HOST'].".</p>
    <p>Link do zmiany hasła to <a href='".$link."' target='_blank'>".$link."</a></p>
    <p>Link jest aktywny tylko 20 minut.</p>
    <br>
    <p>Jeżeli to nie Ty wysłałeś prośbę o zmianę tego hasła, zignoruj tę wiadomość lub poinformuj nas o tym.</p>
    <p>Uwaga!<br>Powyższa wiadomość została wysłana automatycznie, prosimy na nią nie odpowiadać.</p>
    <p>Jeżeli chcesz się z nami skontaktować, napisz do nas na kontakt@weo.pl  </p>
  </div>
  ";
  $headers = "Content-Type: text/html; charset=UTF-8\r\n";
  $from = "kontakt@weo.pl";
  mail($to, $subject, $message, $headers, "-f " . $from);
}
