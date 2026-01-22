# Panduan Deployment Laravel FrankenPHP (Worker Mode)

Ini adalah panduan LENGKAP dari 0 (Clone) sampai Live, menggunakan FrankenPHP + Nginx Proxy Manager.

## 📋 Prasyarat
- VPS dengan Ubuntu/Linux.
- Docker & Docker Compose sudah terinstall.
- Nginx Proxy Manager (NPM) sudah berjalan di port 80/443.
- Domain sudah diatur di Cloudflare (Proxied).

---

## 🚀 Langkah 1: Clone & Setup Awal

1.  **Masuk ke VPS** dan pindah ke folder project (misal `/var/www`):
    ```bash
    cd /var/www
    ```

2.  **Clone Repository**:
    ```bash
    git clone https://github.com/username/repo-anda.git nama-folder
    cd nama-folder
    ```

3.  **Setup Environment**:
    Copy `.env.example` ke `.env`:
    ```bash
    cp .env.example .env
    ```
    Edit `.env` sesuaikan dengan production config:
    ```bash
    nano .env
    ```
    *Pastikan `APP_URL` menggunakan `https://domainanda.com`*

---

## 🐳 Langkah 2: Build & Start Container

1.  **Jalankan Container**:
    Proses ini akan **sekaligus menginstall vendor/library** karena kita menggunakan Multi-stage Build.
    ```bash
    docker compose up -d --build
    ```
    *Tunggu proses build selesai (agak lama di awal karena download vendor).*

2.  **Generate Key & Storage Link**:
    Sekarang `composer` sudah tersedia di dalam container (jika butuh manual).
    ```bash
    docker compose exec app php artisan key:generate
    docker compose exec app php artisan storage:link
    ```

3.  **Migrasi Database**:
    ```bash
    docker compose exec app php artisan migrate --force
    ```
    *(Gunakan `--seed` jika butuh data awal)*

---

## 🌐 Langkah 3: Setup Domain (Nginx Proxy Manager)

1.  Buka Dashboard NPM (biasanya di port 81).
2.  Klik **"Add Proxy Host"**.
3.  **Tab Details**:
    - **Domain Names**: `domainanda.com`
    - **Scheme**: `http` (PENTING! Jangan https, karena container kita jalan di port 80).
    - **Forward Hostname**: `nama_service_app` (Jika NPM satu network) ATAU IP Docker Host (misal `172.17.0.1`).
        - *Rekomendasi*: Gunakan IP Host gateway docker (`172.17.0.1`) jika ragu soal network bridge.
    - **Forward Port**: `8001` (Sesuai `ports` di docker-compose.yml host).
    - **Cache Assets**, **Block Common Exploits**, **Websockets Support**: [Check Semua].
4.  **Tab SSL**:
    - **SSL Certificate**: "Request a new SSL Certificate" (Let's Encrypt) ATAU gunakan Cloudflare Origin Certificate.
    - **Force SSL**: [Check].
    - **HTTP/2 Support**: [Check].
    - **HSTS Enabled**: [Check].
5.  Save.

---

## 🛠️ Langkah 4: Troubleshooting Umum

### Container Jalan tapi "Empty Reply" saat diakses?
Cek environment variable di `docker-compose.yml`. Pastikan baris ini ADA & `host` diset 0.0.0.0:
```yaml
environment:
  - SERVER_NAME=:80
```

### Update Aplikasi (Maintenance Rutin)
Setiap ada perubahan kode di Git, jalankan urutan ini:

```bash
# 1. Tarik kode terbaru
git pull origin main

# 2. Rebuild Image (WAJIB jika ada update composer.json atau Dockerfile)
docker compose up -d --build

# 3. Jalankan migrasi (jika ada perubahan database)
docker compose exec app php artisan migrate --force

# 4. Reload Octane (Jika tidak rebuild image)
docker compose exec app php artisan octane:reload
```

---

## 📂 Struktur Penting
- **Dockerfile**: Config Multi-stage build (Builder + Runtime).
- **docker-compose.yml**: Config service & network.
- **deployment_guide.md**: File panduan ini.
