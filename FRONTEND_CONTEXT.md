# VinylVault - Frontend Context Guide

This document serves as the definitive reference guide for the VinylVault Flutter frontend repository.

## 1. Architecture & Core Patterns

**State Management:** 
The application uses the **Provider** package (`provider: ^6.1.2`) for state management. The app wraps the root widget with a `MultiProvider` in `lib/main.dart` exposing multiple `ChangeNotifierProvider` instances (e.g., `UserProvider`, `CartProvider`, `OrderProvider`). 

**Routing:** 
Routing is handled using Flutter's built-in **Navigator** (e.g., `Navigator.push`, `Navigator.pushReplacement`) rather than a declarative router like `go_router`. There is a `GlobalKey<NavigatorState>` (`_appNavigatorKey`) defined in `lib/main.dart` that is injected into the `ApiService` to allow global navigation events (like redirecting to a `SessionExpiredScreen` on a 401 Unauthorized response).

## 2. Tech Stack & Dependencies

The primary technologies and packages used in `pubspec.yaml` include:

*   **Flutter & Dart:** The core framework and language for the cross-platform application.
*   **`provider`**: Manages application state across the widget tree.
*   **`http`**: Used to make RESTful API calls to the VinylVault backend.
*   **`flutter_secure_storage` & `shared_preferences`**: Used for persistent local storage, primarily for securely storing authentication tokens and local user preferences.
*   **`cached_network_image`**: For downloading, caching, and displaying images efficiently.
*   **`shimmer`**: Provides a loading skeleton UI effect while data or images are being fetched.
*   **`flutter_svg`**: For rendering scalable vector graphics (SVG) in the app.
*   **`google_fonts`**: Provides typography directly from Google Fonts instead of relying on default system fonts.

## 3. Directory Structure & Flow

```text
d:\vinylvault\my_app\
├── pubspec.yaml
└── lib/
    ├── config/            # Configuration files (e.g., constants.dart, theme.dart)
    ├── models/            # Core data structures (e.g., product.dart, user.dart)
    ├── providers/         # State management logic (e.g., user_provider.dart)
    ├── screens/           # UI Pages (e.g., home_screen.dart, cart_screen.dart)
    ├── services/          # External integrations & API calls (api_service.dart)
    ├── utils/             # Helper functions and utilities
    ├── widgets/           # Reusable UI components
    └── main.dart          # Application entry point
```

**Flow Separation:**
*   **Business Logic:** Primarily resides in `lib/providers/` (handling state mutations and notifying listeners) and `lib/services/` (handling raw data fetching and external API communication).
*   **UI Components:** Handled by `lib/screens/` (full-page views) and `lib/widgets/` (reusable, smaller components). Screens consume data from providers via `context.read()` or `context.watch()`.

## 4. Data Models & Integration Points

**Core Data Models (`lib/models/`):**
*   `Product` (in `product.dart`)
*   `User` (in `user.dart`)
*   `Order` (in `order.dart`)
*   `CartItem` (in `cart_item.dart`)

**Backend API Integration:**
All API calls are centralized in `lib/services/api_service.dart`. The app expects to consume the following REST endpoints from the backend:

*   **Products:**
    *   `GET /products` (Supports query parameters: `genre`, `decade`, `condition`, `search`)
    *   `GET /products/:id`
*   **Cart:**
    *   `GET /cart`
    *   `POST /cart` (Requires `productId`, `quantity`)
    *   `PUT /cart/:id` (Updates `quantity`)
    *   `DELETE /cart/:id`
    *   `DELETE /cart` (Clears cart)
*   **Orders:**
    *   `POST /orders` (Requires `shippingAddress`)
    *   `GET /orders`
    *   `GET /orders/:id`
*   **User/Profile:**
    *   `GET /users/profile`
    *   `PUT /users/profile` (Updates `username`, `phone`, `address`)

Authentication tokens are injected into the headers using the `AuthService`. The base URL for all requests is defined by `Constants.apiBaseUrl`.

## 5. Development Workflow

**Running Locally:**
1.  Navigate to the app directory: `cd d:\vinylvault\my_app`
2.  Install dependencies: `flutter pub get`
3.  Run the application on an emulator or connected device: `flutter run`

**Environment Variables:**
This project does not appear to use a standard `.env` package (like `flutter_dotenv`). Environment configurations (like the backend URL) are likely hardcoded or managed as static constants. 
*   **Action Required:** Check `lib/config/constants.dart` and modify `Constants.apiBaseUrl` to point to your local backend server (e.g., `http://10.0.2.2:3000` for Android Emulator or `http://localhost:3000` for iOS Simulator/Web) when running locally.
