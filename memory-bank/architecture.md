# Project Architecture

## Project Structure

```
bpm_counter_app/
├── lib/                    # Main source code directory
│   ├── main.dart          # Application entry point
│   ├── providers/         # State management
│   │   └── bpm_provider.dart # BPM state management
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
- `main.dart`: The entry point of the application. Contains the root widget and initial app setup. Wraps the app with ChangeNotifierProvider for state management.
- `pubspec.yaml`: Defines project metadata, dependencies, and assets. Currently includes:
  - Flutter SDK
  - provider (^6.0.0)
  - permission_handler (^10.0.0)

### State Management (Implemented)
- `providers/bpm_provider.dart`: Handles all BPM-related state management using Provider pattern.
  - Properties:
    - tapTimestamps: List of timestamps for tap mode
    - currentBpm: Calculated BPM value
    - tapCount: Number of taps recorded
    - autoModeStatus: Status message for auto mode
    - audioProcessingDuration: Duration (in seconds) for audio processing
    - errorState: Error messages
    - accuracyNote: Notes about BPM accuracy
  - Methods:
    - recordTap(): Records a new tap timestamp
    - _calculateBpm(): Calculates BPM based on timestamps with validation
    - reset(): Clears all data and resets state
    - setAudioProcessingDuration(): Updates the audio processing duration
    - setAutoModeStatus(): Updates the auto mode status
    - setError(): Sets or clears error messages

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
- Encapsulated business logic within provider
- Proper data validation and error handling

### UI Architecture
- Screen-based navigation using TabBar (to be implemented)
- Platform-specific UI components where necessary (to be implemented)
- Separation of concerns between UI and business logic
- Consumer widgets for reactive UI updates

### Native Integration
- Platform channels for audio processing (to be implemented)
- Native code for microphone access and audio analysis (to be implemented)
- Cross-platform compatibility through Flutter's abstraction layer

## Data Flow

### Tap Mode
1. User taps screen → recordTap() is called in BpmProvider
2. Timestamp is recorded and added to tapTimestamps list
3. _calculateBpm() analyzes timestamps and updates currentBpm
4. Consumer widgets in the UI update to reflect new state
5. Validation ensures BPM values are within 40-200 range
6. Accuracy feedback provided based on number of taps

### Auto Mode (To Be Implemented)
1. User selects Auto Mode → permission check
2. App starts audio processing through native code
3. BPM detection runs for configured duration (default 10s)
4. Results are passed back to Flutter through Platform Channels
5. BpmProvider updates state with detected BPM
6. UI updates to display results

## Dependencies
Currently using:
- Flutter SDK
- (Provider and permission_handler to be added in next step)
