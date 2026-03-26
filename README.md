# Rick and Morty Character Explorer

A polished Flutter application to explore, favorite, and locally edit characters from the Rick and Morty universe. This project demonstrates modern Flutter development practices, including clean architecture, state management with Provider, and robust offline support.

## 🚀 Features

- **Character Discovery**: Browse characters with infinite scrolling (pagination) from the [Rick and Morty API](https://rickandmortyapi.com/).
- **Detailed Profiles**: View comprehensive character information (Status, Species, Gender, Origin, Location, and Episodes).
- **Favorites System**: Save your favorite characters for quick access. Favorites are persisted locally.
- **Local Editing (Overrides)**: Edit character details (Name, Status, Species, etc.) locally. Your changes override API data and persist across app restarts.
- **Offline Support**: The app caches API responses locally, allowing you to browse characters, favorites, and edited data even without an internet connection.
- **Modern UI**: A clean, dark-themed interface with smooth loading animations and responsive design.

## Technical Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/) (latest stable)
- **State Management**: **Provider**
  - *Reasoning*: Provider was chosen for its simplicity, low boilerplate, and effective dependency injection. It perfectly handles the app's reactive state (favorites and overrides) while keeping the business logic separated from the UI.
- **Local Storage**: **SharedPreferences**
  - *Reasoning*: SharedPreferences is used to store user favorites (as a list of IDs) and local character overrides (as JSON). It provides a fast, lightweight solution for persisting key-value data without the overhead of a full database like SQLite or Hive for this specific use case.
- **Networking**: **http**
- **Architecture**: Modular folder structure based on **Separation of Concerns**:
  - `models/`: Data entities and JSON serialization.
  - `providers/`: Business logic, API calls, and persistence logic.
  - `screens/`: Feature-specific UI pages.
  - `widgets/`: Reusable UI components.

## Project Structure

```text
lib/
├── models/         # Data entities (Character model)
├── providers/      # Business logic & state management
├── screens/        # Feature pages (List, Detail, Favorites, Edit)
├── widgets/        # Reusable UI components (CharacterCard)
└── main.dart       # App entry point and theme configuration
```

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1.  **Clone the repository**:
    ```bash
    **https://github.com/Ashik116/Rick-Morty-Pridesys-Task.git**
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 📝 Deliverables Met

- **Git repository** structure maintained.
- **Proper State Management** implemented via Provider.
- **Correct Data Merge**: API data and Local Overrides are merged at runtime.
- **Persistence**: Edits and Favorites persist after app restarts.
- **Offline Mode**: App works with cached data when the API is unreachable.
