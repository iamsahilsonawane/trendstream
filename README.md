# Trendstream

This repository contains the source code for the Trendstream, designed for Android TV. This app is a collection of movies / tvshows / tv guides of all types & genres. Including support for playing full HD & 4K videos with custom subtitles & multi-audio support.

![Splash](https://github.com/Flutternest/trendstream/blob/main/screenshots/splash.png?raw=true)

## Screenshots

| Screenshot 1 | Screenshot 2 |
|--------------|--------------|
| ![Screenshot 1](https://github.com/Flutternest/trendstream/blob/main/screenshots/movies_dashboard.png?raw=true) | ![Screenshot 2](https://github.com/Flutternest/trendstream/blob/main/screenshots/movie_details.png?raw=true) |
| Screenshot 3 | Screenshot 4 |
| ![Screenshot 1](https://github.com/Flutternest/trendstream/blob/main/screenshots/search.png?raw=true) | ![Screenshot 2](https://github.com/Flutternest/trendstream/blob/main/screenshots/seasons_episodes_selection.png?raw=true) |

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [Screenshots](#screenshots)
- [License](#license)

## Features
- **Latest Movies Dashboard**: Browse the latest movies with a beautiful and intuitive UI.
- **Firebase Integration**: Authentication, Crashlytics, Analytics, and Remote Config.
- **Offline Support**: Cached network images and shared preferences.
- **Video Playback**: Integrated with VLC player for seamless video playback.
- **OTA Updates**: Over-the-air updates to keep the app up-to-date.

## Architecture
The application follows the Model-View-Controller (MVC) architecture. Here are the main components:

### Model
- **Data Models**: Represent the data structure of the application (e.g., `TvShow`, `ProgramGuide`).
- **Repositories**: Handle data fetching and caching (e.g., `TvShowsRepository`).

### View
- **UI Components**: Built with Flutter's `Material` and `Cupertino` widgets.
- **Screens and Widgets**: Display data and handle user interactions (e.g., `HomeView`, `SignUpView`, `LoginView`).

### Controller
- **State Management**: Using `hooks_riverpod` for state management.
- **Controllers**: Manage the logic and state of the application (e.g., `AuthController`, `TvShowsProvider`).

### Additional Components
- **Networking**: Handled by `dio` for HTTP requests.
- **JSON Serialization**: Using `json_serializable` for JSON parsing.
- **Video Playback**: Integrated with `flutter_vlc_player`.
- **Firebase Services**: Authentication, Crashlytics, Analytics, and Remote Config.

## Installation
To get started with the project, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/Flutternest/trendstream.git && cd trendstream
    ```

2. Install the dependencies:
    ```bash
    flutter pub get
    ```

3. Set up the Firebase configuration:
    - Add your `google-services.json` file to the `android/app` directory.

4. Run the project:
    ```bash
    flutter run
    ```

## Usage
To use the Latest Movies app, simply run the project on an Android TV device or emulator. The app will display the latest movies, allowing you to browse and watch trailers or full movies.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate (if any).