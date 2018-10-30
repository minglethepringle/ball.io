<?php
    $hs=(string)$_POST['score'];
    $file = 'highScore.txt';
    $currentHS = file($file)[0];
    if(intval($hs) > intval($currentHS)) {
        file_put_contents($file, $hs);
    }
?>