# Memori App

A flashcard learning app, made with Flutter.

## Table of Contents
- [Dev Requirements](#dev-requirements)
- [Getting Started](#getting-started)
  - [Firebase](#firebase)
  - [IDE setup](#ide-setup)

## Dev Requirements
1. Flutter
2. Flutterfire CLI [(links)](https://firebase.google.com/docs/flutter/setup?platform=ios)
3. Memori Sync Backend [(links)](https://github.com/polarBearYap/memori-sync-backend)

## Getting Started
1. Complete setup of memori sync backend before proceed, as mentioned in Dev requirements.
2. Follow this official guide on how to add firebase to flutter project to add missing credential files. [(links)](https://firebase.google.com/docs/flutter/setup?platform=ios)

### Firebase
1. Go to Firebase console > Firebase remote config, create a property named `sync_backend_url`.
2. Set the value as the URL where your sync backend is hosted at.
3. For example, memori sync backend is hosted at local machine port 8080. Set to `http://localhost:8080` for debugging purposes.

### IDE setup
1. Run the command below to download required packages.
```
flutter pub get
```
2. Run the command below to generate the JSON serialized annotated files and drift files.
```
dart run build_runner build --delete-conflicting-outputs
```
3. Run the command below to generate the localization files.
```
flutter gen-l10n
```
4. Run the command below to build android APK.
```
flutter build apk --release
```
5. Run the command below to build android app bundle.
```
flutter build appbundle --release
```
6. Run the command below to build iOS app. macOS and Apple developer account is required.
```
flutter build ios --release
```

##  Main Packages
1. Flutter bloc
2. Go router
3. Drift
4. Firebase remote config

## Image Credit
1. Business illustrations from Storyset [(links)](https://storyset.com/business)
2. Event illustrations from Storyset [(links)](https://storyset.com/event)
3. Happy illustrations from Storyset [(links)](https://storyset.com/happy)
4. Internet illustrations from Storyset [(links)](https://storyset.com/internet)
5. Online illustrations from Storyset [(links)](https://storyset.com/online)
6. People illustrations from Storyset [(links)](https://storyset.com/people)
7. Web illustrations from Storyset [(links)](https://storyset.com/web)
8. Flag icons from Freepik - Flaticon [(links)](https://www.flaticon.com/free-icons/flags)

## License

Distributed under the MIT License. See LICENSE for more information.
