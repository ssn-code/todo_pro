# Todo Pro

Todo Pro is a native Flutter productivity app for Windows and Android. It provides a calm Material 3 interface for managing personal tasks locally, without an account or network connection.

## Features

- Today and Upcoming task views
- Create, edit, complete, reopen, and delete tasks
- Optional descriptions, due dates, and Low/Medium/High/Urgent priorities
- SQLite persistence through `sqflite` and `sqflite_common_ffi`
- Light, Dark, and System theme modes persisted with Shared Preferences
- Responsive desktop navigation rail and mobile navigation bar
- Riverpod state management with loading and error states
- Accessible empty states and confirmation before deletion

## Requirements

- Flutter stable (Dart 3.13 or newer)
- Windows desktop tooling for Windows builds
- Android Studio and an Android SDK for Android builds

On Windows, Flutter desktop plugin builds may require Windows Developer Mode for symlink support. Enable it from **Settings → System → For developers**.

## Run locally

```powershell
flutter pub get
flutter run -d windows
```

For Android, connect a device or start an emulator and run:

```powershell
flutter run -d android
```

## Verify

```powershell
flutter analyze
flutter test
```

The local database is created automatically on first launch. Tasks remain on the device between application restarts.

## Project structure

```text
lib/
  database/       SQLite initialization
  models/         Task and priority models
  providers/      Riverpod task state
  repositories/   Database operations
  screens/        Task and settings UI
  theme/          Centralized Material 3 themes
```
