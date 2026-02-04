# Monetra - Financial Management App

## Tech Stack
- **Frontend**: Flutter (Riverpod, GoRouter, Dio, SQLite)
- **Backend**: Laravel 10 (Sanctum, MySQL)

## Features
- **Offline-First**: fast local storage with SQLite.
- **Sync Engine**: Bi-directional sync with conflict resolution (Last-Write-Wins).
- **Authentication**: Secure Login/Register with Token support (Sanctum).
- **Modules**: Wallets, Transactions (Income/Expense).

## Setup Instructions

### Backend (Laravel)
The backend is set up to run with SQLite for easy local development.

1.  Navigate to `backend/`.
2.  Install dependencies:
    ```bash
    composer install
    ```
3.  Run migrations and seed the database with demo data:
    ```bash
    # This creates a demo user (demo@example.com / password)
    php artisan migrate:fresh --seed
    ```
4.  Serve the API:
    ```bash
    php artisan serve
    ```
    The API will run at `http://127.0.0.1:8000`.

### Frontend (Mobile)
1.  Navigate to `mobile/`.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Ensure your Android Emulator is running.
4.  Run the app:
    ```bash
    flutter run
    ```

## Verification Steps
1.  **Login**: Use `demo@example.com` / `password` to log in on the mobile app.
2.  **Sync Pull**: On the dashboard, tap the **Sync Icon** (top right). You should see the Wallets and Transactions from the seeder appear (e.g., "Main Bank Account - $25,000" and "Salary - $5,000").
3.  **Sync Push**: 
    -   Create a new Wallet or Transaction while offline (or just normally).
    -   Tap Sync again.
    -   Check the backend database (or use an API tool like Postman) to verify the new record exists in the `transactions` table.

## Sync Logic
- Local changes mark records as `is_synced = 0`.
- Sync Push sends unsynced records to the server.
- Sync Pull fetches records updated since `last_sync_time`.
