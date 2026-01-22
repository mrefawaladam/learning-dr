<?php

use Illuminate\Support\Facades\Route;

$bootTime = now();

Route::get('/', function () {
    return view('welcome');
});

Route::get('/cek-worker', function () use ($bootTime) {
    return [
        'boot_time' => $bootTime->toDateTimeString(), // Waktu server pertama kali nyala
        'request_time' => now()->toDateTimeString(),  // Waktu saat kamu refresh halaman
        'message' => 'Jika boot_time TIDAK BERUBAH saat direfresh, Worker Mode AKTIF!',
    ];
});