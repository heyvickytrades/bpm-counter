# Project Architecture

## Project Structure

```
bpm_counter_app/
├── lib/                    # Main source code directory
│   ├── main.dart          # Application entry point
│   ├── providers/         # State management (to be created)
│   │   └── bpm_provider.dart
│   └── screens/           # UI screens (to be created)
│       ├── tap_mode_screen.dart
│       └── auto_mode_screen.dart
├── test/                  # Test files directory
├── android/               # Android-specific code
├── ios/                   # iOS-specific code
├── macos/                 # macOS-specific code
└── pubspec.yaml          # Project configuration and dependencies
```

## File Purposes

### Core Files
- `main.dart`: The entry point of the application. Contains the root widget and initial app setup.
- `pubspec.yaml`: Defines project metadata, dependencies, and assets. Currently includes basic Flutter dependencies.

### State Management (To Be Created)
- `providers/bpm_provider.dart`: Will handle all BPM-related state management using Provider pattern.
  - Manages tap timestamps
  - Calculates BPM
  - Handles audio processing state
  - Manages error states

### UI Screens (To Be Created)
- `screens/tap_mode_screen.dart`: UI for manual BPM calculation through screen taps
- `screens/auto_mode_screen.dart`: UI for automatic BPM detection using microphone

### Platform-Specific Code
- `android/`: Contains Android-specific configurations and native code
- `ios/`: Contains iOS-specific configurations and native code
- `macos/`: Contains macOS-specific configurations and native code

## Architecture Patterns

### State Management
- Using Provider pattern for state management
- Centralized state in BpmProvider
- Reactive updates through ChangeNotifier

### UI Architecture
- Screen-based navigation using TabBar
- Platform-specific UI components where necessary
- Separation of concerns between UI and business logic

### Native Integration
- Platform channels for audio processing
- Native code for microphone access and audio analysis
- Cross-platform compatibility through Flutter's abstraction layer

## Dependencies
Currently using:
- Flutter SDK
- (Provider and permission_handler to be added in next step)
