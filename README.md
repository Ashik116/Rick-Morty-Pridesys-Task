# Rick and Morty Character Explorer

A polished Flutter application to explore, favorite, and locally edit characters from the Rick and Morty universe. This project demonstrates modern Flutter development practices, including clean architecture, state management with Provider, and robust offline support.

## 🚀 Features

- **Character Discovery**: Browse characters with infinite scrolling (pagination) from the [Rick and Morty API](https://rickandmortyapi.com/).
- **Detailed Profiles**: View comprehensive character information (Status, Species, Gender, Origin, Location, and Episodes).
- **Favorites System**: Save your favorite characters for quick access. Favorites are persisted locally.
- **Local Editing (Overrides)**: Edit character details (Name, Status, Species, etc.) locally. Your changes override API data and persist across app restarts.
- **Offline Support**: The app caches API responses locally, allowing you to browse characters, favorites, and edited data even without an internet connection.
- **Modern UI**: A clean, dark-themed interface with smooth loading animations and responsive design.

## 🛠️ Technical Stack

- **Framework**: [Flutter](https://flutter.dev/) (latest stable)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Storage**: [SharedPreferences](https://pub.dev/packages/shared_preferences) (for favorites and local edits)
- **Networking**: [http](https://pub.dev/packages/http)
- **Architecture**: Modular folder structure (Models, Providers, Screens, Widgets)

## 📁 Project Structure

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
    git clone https://github.com/your-username/rick_and_morty_character_explorer.git
    cd rick_and_morty_character_explorer
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 📝 Key Requirements Met

- **Local Editing**: Users can modify character details which are then merged with API data at runtime.
- **Persistence**: Both favorites and user-edited overrides are stored locally.
- **UX Excellence**: Includes loading states (initial + pagination), error handling for API failures, and empty states.
- **Offline Reliability**: The app gracefully handles network failures by serving cached content.
