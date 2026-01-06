# Recipe App - Project Structure Documentation

## 📱 Project Overview

**Project Name:** RUPP Final MAD (Mobile Application Development)  
**Type:** Flutter Recipe Application  
**Architecture:** Clean Architecture (3-Layer Architecture)  
**State Management:** Provider Pattern  
**Version:** 1.0.0+1

---

## 🏗️ Architecture Overview

The project follows **Clean Architecture** principles with three main layers:

```
┌─────────────────────────────────────┐
│     PRESENTATION LAYER              │  ← UI, Screens, Widgets, Providers
├─────────────────────────────────────┤
│     DOMAIN LAYER                    │  ← Business Logic, Repository Interfaces
├─────────────────────────────────────┤
│     DATA LAYER                      │  ← API, Data Sources, Models, Implementations
└─────────────────────────────────────┘
```

---

## 📂 Complete Project Structure

```
rupp-final-mad/
│
├── 📱 lib/                          # Main application code
│   │
│   ├── 🎯 main.dart                # Application entry point
│   │
│   ├── 📊 data/                    # DATA LAYER - External data handling
│   │   │
│   │   ├── 🌐 api/                 # API Communication
│   │   │   ├── api_client.dart     # HTTP client for API requests (GET, POST, PUT, DELETE, Multipart)
│   │   │   └── api_config.dart     # API configuration (base URL, endpoints)
│   │   │
│   │   ├── 💾 datasources/         # Data Sources (Remote/Local)
│   │   │   ├── auth_remote_datasource.dart      # Authentication API calls
│   │   │   ├── recipe_remote_datasource.dart    # Recipe API calls
│   │   │   └── user_remote_datasource.dart      # User profile API calls
│   │   │
│   │   ├── 📦 models/              # Data Models (DTOs)
│   │   │   ├── login_request.dart              # Login request model
│   │   │   ├── login_response.dart             # Login response model
│   │   │   ├── register_request.dart           # Registration request model
│   │   │   ├── register_response.dart          # Registration response model
│   │   │   ├── recipe.dart                     # Recipe data model
│   │   │   └── user_profile.dart               # User profile model
│   │   │
│   │   ├── 🔄 repositories/        # Repository Implementations
│   │   │   ├── auth_repository_impl.dart       # Auth repository implementation
│   │   │   ├── recipe_repository_impl.dart     # Recipe repository implementation
│   │   │   └── user_repository_impl.dart       # User repository implementation
│   │   │
│   │   └── 🛠️ services/            # Utility Services
│   │       ├── fallback_data_service.dart      # Fallback data when API fails
│   │       ├── onboarding_service.dart         # Onboarding state management
│   │       └── token_storage_service.dart      # Token storage (SharedPreferences)
│   │
│   ├── 🎯 domain/                  # DOMAIN LAYER - Business Logic
│   │   │
│   │   └── 🔌 repositories/         # Repository Interfaces (Contracts)
│   │       ├── auth_repository.dart            # Authentication interface
│   │       ├── recipe_repository.dart          # Recipe operations interface
│   │       └── user_repository.dart            # User operations interface
│   │
│   └── 🎨 presentation/             # PRESENTATION LAYER - UI & State
│       │
│       ├── 🔄 providers/            # State Management (Provider)
│       │   ├── auth_provider.dart              # Authentication state
│       │   └── theme_provider.dart             # Theme (Light/Dark) state
│       │
│       ├── 📱 screens/              # Application Screens
│       │   ├── onboarding_screen.dart          # First-time user onboarding
│       │   ├── login_screen.dart               # User login
│       │   ├── register_screen.dart            # User registration
│       │   ├── phone_login_screen.dart         # Phone number authentication
│       │   ├── home_screen.dart                # Main screen with bottom navigation
│       │   ├── home_tab_screen.dart            # Home tab content
│       │   ├── explore_screen.dart             # Explore recipes
│       │   ├── my_recipe_screen.dart           # User's saved recipes
│       │   ├── profile_screen.dart             # User profile
│       │   ├── edit_profile_screen.dart        # Edit user profile
│       │   ├── recipe_detail_screen.dart       # Recipe details view
│       │   ├── recipes_list_screen.dart        # List of recipes
│       │   ├── category_recipes_screen.dart     # Recipes by category
│       │   └── author_profile_screen.dart      # Author profile view
│       │
│       └── 🧩 widgets/              # Reusable UI Components
│           ├── category_card.dart              # Category display card
│           ├── home_app_bar_content.dart       # Home screen app bar
│           ├── login_form_ui.dart              # Login form component
│           ├── register_form_ui.dart           # Registration form component
│           ├── onboarding_page_content.dart     # Onboarding page content
│           ├── profile_header.dart             # Profile header widget
│           ├── profile_action_card.dart         # Profile action buttons
│           ├── recipe_grid_card.dart           # Recipe card for grid view
│           ├── recipe_grid_skeleton.dart       # Loading skeleton for recipes
│           └── skeleton_loader.dart             # Generic loading skeleton
│
├── 📦 android/                      # Android platform configuration
│   ├── app/
│   │   ├── build.gradle.kts        # Android app build configuration
│   │   └── src/                    # Android source files
│   ├── build.gradle.kts            # Project-level build config
│   └── gradle/                     # Gradle wrapper
│
├── 🍎 ios/                          # iOS platform configuration
│   ├── Runner/                     # iOS app files
│   │   ├── AppDelegate.swift       # iOS app delegate
│   │   └── Info.plist              # iOS app configuration
│   └── Podfile                     # CocoaPods dependencies
│
├── 💻 macos/                        # macOS platform configuration
│   └── Runner/                      # macOS app files
│
├── 🌐 web/                          # Web platform configuration
│   ├── index.html                  # Web entry point
│   └── manifest.json               # Web app manifest
│
├── 🖼️ assets/                       # Static assets
│   └── images/                     # Image files
│       ├── logo.png                # App logo
│       ├── google_logo.png          # Google sign-in logo
│       └── image1-4.png            # Onboarding images
│
├── 📄 pubspec.yaml                  # Flutter dependencies & config
├── 📄 pubspec.lock                  # Locked dependency versions
├── 📄 README.md                     # Project documentation
└── 📄 analysis_options.yaml         # Dart analyzer configuration
```

---

## 🔍 Detailed Layer Breakdown

### 1️⃣ DATA LAYER (`lib/data/`)

**Purpose:** Handles all external data operations (API calls, local storage)

#### 📡 API (`api/`)
- **`api_client.dart`**: Centralized HTTP client
  - Handles GET, POST, PUT, DELETE requests
  - Supports multipart file uploads
  - Automatic token injection
  - Error handling & response parsing
  
- **`api_config.dart`**: API configuration
  - Base URL definition
  - Endpoint constants

#### 💾 Data Sources (`datasources/`)
- **`auth_remote_datasource.dart`**: Authentication API calls
  - Login, Register, Google Sign-in, Phone OTP
  
- **`recipe_remote_datasource.dart`**: Recipe-related API calls
  - Fetch recipes, categories, search
  
- **`user_remote_datasource.dart`**: User profile API calls
  - Get/Update user profile, avatar upload

#### 📦 Models (`models/`)
- Data Transfer Objects (DTOs) for API communication
- Converts JSON to Dart objects and vice versa
- Includes: LoginRequest, LoginResponse, Recipe, UserProfile, etc.

#### 🔄 Repository Implementations (`repositories/`)
- Implements domain layer interfaces
- Coordinates between data sources and domain
- Handles error cases and fallback data

#### 🛠️ Services (`services/`)
- **`token_storage_service.dart`**: Secure token storage using SharedPreferences
- **`onboarding_service.dart`**: Manages first-time user onboarding state
- **`fallback_data_service.dart`**: Provides mock data when API is unavailable

---

### 2️⃣ DOMAIN LAYER (`lib/domain/`)

**Purpose:** Contains business logic and defines contracts

#### 🔌 Repository Interfaces (`repositories/`)
- **`auth_repository.dart`**: Authentication contract
  - Methods: login(), register(), loginWithGoogle(), logout()
  
- **`recipe_repository.dart`**: Recipe operations contract
  - Methods: getRecipes(), getRecipeById(), searchRecipes()
  
- **`user_repository.dart`**: User operations contract
  - Methods: getUserProfile(), updateProfile()

**Key Principle:** Domain layer is independent of data sources - defines WHAT, not HOW

---

### 3️⃣ PRESENTATION LAYER (`lib/presentation/`)

**Purpose:** UI components and state management

#### 🔄 Providers (`providers/`)
- **`auth_provider.dart`**: Manages authentication state
  - User login status, user info, auth methods
  
- **`theme_provider.dart`**: Manages app theme
  - Light/Dark mode switching

#### 📱 Screens (`screens/`)
**Authentication Flow:**
- `onboarding_screen.dart` - First-time user introduction
- `login_screen.dart` - Email/password login
- `register_screen.dart` - New user registration
- `phone_login_screen.dart` - Phone number authentication

**Main App Screens:**
- `home_screen.dart` - Main container with bottom navigation
- `home_tab_screen.dart` - Home tab content (featured recipes)
- `explore_screen.dart` - Browse and discover recipes
- `my_recipe_screen.dart` - User's saved/favorite recipes
- `profile_screen.dart` - User profile and settings

**Detail Screens:**
- `recipe_detail_screen.dart` - Full recipe details
- `recipes_list_screen.dart` - List view of recipes
- `category_recipes_screen.dart` - Recipes filtered by category
- `author_profile_screen.dart` - Recipe author profile
- `edit_profile_screen.dart` - Edit user information

#### 🧩 Widgets (`widgets/`)
Reusable UI components for consistent design:
- Form components (login, register)
- Card components (recipe, category)
- Loading states (skeletons)
- Profile components (header, actions)

---

## 🛠️ Key Technologies & Dependencies

### Core Framework
- **Flutter SDK**: >=3.0.0 <4.0.0
- **Dart**: Modern Dart language features

### State Management
- **Provider** (^6.1.1): State management solution

### Networking
- **HTTP** (^1.1.0): HTTP client for API calls

### Authentication
- **Firebase Auth** (^5.3.1): Authentication service
- **Firebase Core** (^3.6.0): Firebase initialization
- **Google Sign In** (^6.2.1): Google authentication

### Storage
- **Shared Preferences** (^2.2.2): Local key-value storage

### UI/UX
- **Shimmer** (^3.0.0): Loading skeleton animations
- **Intl** (^0.19.0): Internationalization & date formatting
- **Image Picker** (^1.0.7): Image selection from gallery/camera

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Web

---

## 🔄 Data Flow Architecture

```
User Action (UI)
    ↓
Provider (State Management)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (API/Local)
    ↓
API Client (HTTP)
    ↓
Backend Server
```

**Response Flow (Reverse):**
```
Backend → API Client → Data Source → Repository → Provider → UI Update
```

---

## 🎯 Key Features

1. **🔐 Authentication**
   - Email/Password login
   - User registration
   - Google Sign-in
   - Phone number OTP authentication

2. **📱 Navigation**
   - Bottom navigation bar (4 tabs)
   - Top app bar with user info
   - Deep linking support

3. **🎨 Theming**
   - Light/Dark mode
   - Material Design 3
   - Custom color scheme

4. **📖 Recipe Management**
   - Browse recipes
   - Search functionality
   - Category filtering
   - Recipe details view
   - Author profiles

5. **👤 User Profile**
   - Profile viewing
   - Profile editing
   - Avatar upload
   - Settings management

6. **🔄 State Management**
   - Provider pattern
   - Reactive UI updates
   - Persistent authentication state

---

## 📊 Project Statistics

- **Total Screens:** 14
- **Total Widgets:** 10
- **Total Models:** 6
- **Total Repositories:** 3 (interfaces) + 3 (implementations)
- **Total Data Sources:** 3
- **Total Providers:** 2
- **Platforms Supported:** 4 (Android, iOS, macOS, Web)

---

## 🚀 Getting Started

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the App:**
   ```bash
   flutter run
   ```

3. **Build for Production:**
   ```bash
   flutter build apk        # Android
   flutter build ios        # iOS
   flutter build web        # Web
   ```

---

## 📝 Notes for Presentation

- **Architecture Pattern:** Clean Architecture (Separation of Concerns)
- **State Management:** Provider (Reactive Programming)
- **API Integration:** RESTful API with HTTP client
- **Error Handling:** Fallback data service for offline support
- **Security:** Token-based authentication with secure storage
- **Scalability:** Modular structure allows easy feature addition

---

*Generated for RUPP Final MAD Project Presentation*

