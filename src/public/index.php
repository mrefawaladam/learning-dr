<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

$app = require __DIR__.'/../bootstrap/app.php';

$kernel = $app->make(Kernel::class);

return function ($request) use ($kernel, $app) {
    $laravelRequest = Request::createFromBase($request);

    $response = $kernel->handle($laravelRequest);

    $kernel->terminate($laravelRequest, $response);

    // 🔥 WAJIB untuk worker mode
    $app->forgetInstance('request');
    $app->forgetInstance('auth');
    $app->forgetInstance('session');

    return $response;
};
