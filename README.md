# Trendstream

This repository contains the source code for the Trendstream, designed for Android TV. This app is a collection of movies / tvshows / tv guides of all types & genres. Including support for playing full HD & 4K videos with custom subtitles & multi-audio support.

![Splash](https://github.com/iamsahilsonawane/trendstream/blob/main/screenshots/splash.png?raw=true)

## Screenshots

| Screenshot 1 | Screenshot 2 |
|--------------|--------------|
| ![Screenshot 1](https://github.com/iamsahilsonawane/trendstream/blob/main/screenshots/movies_dashboard.png?raw=true) | ![Screenshot 2](https://github.com/iamsahilsonawane/trendstream/blob/main/screenshots/movie_details.png?raw=true) |
| Screenshot 3 | Screenshot 4 |
| ![Screenshot 1](https://github.com/iamsahilsonawane/trendstream/blob/main/screenshots/search.png?raw=true) | ![Screenshot 2](https://github.com/iamsahilsonawane/trendstream/blob/main/screenshots/seasons_episodes_selection.png?raw=true) |

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
- **Video Playback**: Integrated with native video player for playing full HD & 4K videos with custom subtitles & multi-audio support. Supports live streaming as well
- **OTA Updates**: Over-the-air updates to keep the app up-to-date.

## Architecture
The application follows the Model-View-Controller (MVC) architecture.

## Installation
To get started with the project, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/iamsahilsonawane/trendstream.git && cd trendstream
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
To use the trendstream app, simply run the project on an Android TV device or emulator. The app will display the latest movies, allowing you to browse and watch trailers or full movies.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate (if any).
