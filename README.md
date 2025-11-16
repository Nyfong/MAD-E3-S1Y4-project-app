# Recipe App - Final Project MAD II Year 4 S1

A Flutter application built with Clean Architecture and Provider state management.

## Features

- 🔐 Login screen with email and password authentication
- 🏠 Home screen with top navigation bar (profile, app name, date/time)
- 📱 Bottom navigation bar with 4 tabs:
  - Home
  - Explore
  - My Recipe
  - Profile
- 🏗️ Clean Architecture structure
- 🔄 Provider for state management
- 🌐 API integration layer ready

## Project Structure

```
lib/
├── data/
│   ├── api/              # API client and network layer
│   ├── datasources/      # Remote and local data sources
│   └── repositories/     # Repository implementations
├── domain/
│   └── repositories/     # Repository interfaces
└── presentation/
    ├── providers/        # State management (Provider)
    └── screens/          # UI screens
```

## Getting Started

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Tech Stack

- Flutter
- Dart
- Clean Architecture
- Provider (State Management)
- HTTP (for API calls)
- Intl (for date formatting)

## Login

For demo purposes, any email and password (minimum 6 characters) will work. In production, this will connect to your backend API.
