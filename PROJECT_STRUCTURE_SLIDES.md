# Recipe App - Project Structure (Slide Format)

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────┐
│   PRESENTATION LAYER                │
│   • Screens (14)                    │
│   • Widgets (10)                    │
│   • Providers (2)                   │
├─────────────────────────────────────┤
│   DOMAIN LAYER                      │
│   • Repository Interfaces (3)       │
│   • Business Logic Contracts        │
├─────────────────────────────────────┤
│   DATA LAYER                        │
│   • API Client                      │
│   • Data Sources (3)                │
│   • Models (6)                      │
│   • Repository Implementations (3)   │
│   • Services (3)                    │
└─────────────────────────────────────┘
```

---

## 📂 Project Structure (Simplified)

### 📱 lib/ - Main Application Code

#### 🎯 main.dart
- Application entry point
- Provider setup
- Theme configuration
- Navigation routing

#### 📊 data/ - Data Layer
```
data/
├── api/                    # API Communication
│   ├── api_client.dart     # HTTP client (GET, POST, PUT, DELETE)
│   └── api_config.dart     # API configuration
│
├── datasources/            # Data Sources
│   ├── auth_remote_datasource.dart
│   ├── recipe_remote_datasource.dart
│   └── user_remote_datasource.dart
│
├── models/                 # Data Models
│   ├── login_request.dart
│   ├── login_response.dart
│   ├── register_request.dart
│   ├── register_response.dart
│   ├── recipe.dart
│   └── user_profile.dart
│
├── repositories/           # Repository Implementations
│   ├── auth_repository_impl.dart
│   ├── recipe_repository_impl.dart
│   └── user_repository_impl.dart
│
└── services/               # Utility Services
    ├── fallback_data_service.dart
    ├── onboarding_service.dart
    └── token_storage_service.dart
```

#### 🎯 domain/ - Domain Layer
```
domain/
└── repositories/           # Repository Interfaces
    ├── auth_repository.dart
    ├── recipe_repository.dart
    └── user_repository.dart
```

#### 🎨 presentation/ - Presentation Layer
```
presentation/
├── providers/              # State Management
│   ├── auth_provider.dart
│   └── theme_provider.dart
│
├── screens/                # Application Screens (14)
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── phone_login_screen.dart
│   ├── home_screen.dart
│   ├── home_tab_screen.dart
│   ├── explore_screen.dart
│   ├── my_recipe_screen.dart
│   ├── profile_screen.dart
│   ├── edit_profile_screen.dart
│   ├── recipe_detail_screen.dart
│   ├── recipes_list_screen.dart
│   ├── category_recipes_screen.dart
│   └── author_profile_screen.dart
│
└── widgets/                # Reusable Components (10)
    ├── category_card.dart
    ├── home_app_bar_content.dart
    ├── login_form_ui.dart
    ├── register_form_ui.dart
    ├── onboarding_page_content.dart
    ├── profile_header.dart
    ├── profile_action_card.dart
    ├── recipe_grid_card.dart
    ├── recipe_grid_skeleton.dart
    └── skeleton_loader.dart
```

---

## 🔄 Data Flow

```
┌──────────┐
│   UI     │  User Interaction
└────┬─────┘
     │
     ▼
┌──────────┐
│ Provider │  State Management
└────┬─────┘
     │
     ▼
┌──────────┐
│Repository│  Business Logic
│Interface │
└────┬─────┘
     │
     ▼
┌──────────┐
│Repository│  Data Implementation
│  Impl    │
└────┬─────┘
     │
     ▼
┌──────────┐
│DataSource│  API Calls
└────┬─────┘
     │
     ▼
┌──────────┐
│API Client│  HTTP Requests
└────┬─────┘
     │
     ▼
┌──────────┐
│ Backend  │  Server
└──────────┘
```

---

## 🛠️ Key Technologies

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart |
| **Architecture** | Clean Architecture |
| **State Management** | Provider |
| **Networking** | HTTP |
| **Authentication** | Firebase Auth, Google Sign-In |
| **Storage** | SharedPreferences |
| **UI Components** | Material Design 3 |
| **Loading** | Shimmer |

---

## 📊 Project Statistics

| Component | Count |
|-----------|-------|
| **Screens** | 14 |
| **Widgets** | 10 |
| **Models** | 6 |
| **Repositories** | 3 interfaces + 3 implementations |
| **Data Sources** | 3 |
| **Providers** | 2 |
| **Services** | 3 |
| **Platforms** | 4 (Android, iOS, macOS, Web) |

---

## 🎯 Main Features

1. **Authentication**
   - Email/Password
   - Google Sign-in
   - Phone OTP

2. **Recipe Management**
   - Browse recipes
   - Search & filter
   - Recipe details
   - Categories

3. **User Profile**
   - View profile
   - Edit profile
   - Avatar upload

4. **UI/UX**
   - Light/Dark theme
   - Bottom navigation
   - Loading states
   - Responsive design

---

## 📦 Platform Structure

```
rupp-final-mad/
├── lib/          # Flutter code
├── android/      # Android config
├── ios/          # iOS config
├── macos/        # macOS config
├── web/          # Web config
└── assets/       # Images & resources
```

---

## 🔑 Key Files

| File | Purpose |
|------|---------|
| `main.dart` | App entry point |
| `api_client.dart` | HTTP communication |
| `auth_provider.dart` | Auth state management |
| `home_screen.dart` | Main app screen |
| `pubspec.yaml` | Dependencies |

---

*Use this format for slide presentations*

