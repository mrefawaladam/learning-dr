<?php

$files = [
    __DIR__.'/vendor/autoload.php',
    __DIR__.'/bootstrap/app.php',
];

foreach ($files as $file) {
    if (file_exists($file)) {
        require_once $file;
    }
}
