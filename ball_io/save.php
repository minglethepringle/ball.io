<?php

    $hs=(string)$_POST['score'];
    $file = 'highScore.txt';
    file_put_contents($file, $hs);

?>