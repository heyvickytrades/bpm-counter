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
    - accuracyNote: User feedback for tap accuracy
    - resetTimer: Timer for auto-reset functionality
  - Methods:
    - recordTap(): Records a new tap timestamp and triggers BPM calculation
      - Cancels existing reset timer
      - Records timestamp and updates count
      - Starts new 5-second reset timer
    - _calculateBpm(): Calculates BPM based on timestamps with validation
      - Validates minimum 2 taps required
      - Calculates BPM using formula: (taps - 1) * 60 / timeSpan
      - Validates BPM range (40-200)
      - Updates error state if validation fails
      - Sets accuracy note based on tap count
    - reset(): Clears all data and resets state
      - Cancels reset timer
      - Clears all state properties
    - dispose(): Cleans up resources
      - Cancels reset timer
      - Calls super.dispose()
    - setAudioProcessingDuration(): Updates the audio processing duration
    - setAutoModeStatus(): Updates the auto mode status
    - setError(): Sets or clears error messages

### UI Screens (Partially Implemented)
- `screens/tap_mode_screen.dart`: UI for manual BPM calculation through screen taps
  - Implemented features:
    - Fixed layout to prevent UI shifts
    - Platform-specific buttons (CupertinoButton for iOS, ElevatedButton for Android)
    - BPM display with validation
    - Reset functionality
    - Error state display
    - Real-time BPM updates
    - Accuracy note display with orange styling
- `screens/auto_mode_screen.dart`: UI for automatic BPM detection using microphone (to be implemented)

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
- Resource cleanup in dispose method

### UI Architecture
- Screen-based navigation using TabBar
- Platform-specific UI components
- Separation of concerns between UI and business logic
- Consumer widgets for reactive UI updates
- Fixed layout containers to prevent UI shifts

### Native Integration
- Platform channels for audio processing (to be implemented)
- Native code for microphone access and audio analysis (to be implemented)
- Cross-platform compatibility through Flutter's abstraction layer

## Data Flow

### Tap Mode (Implemented)
1. User taps screen → recordTap() is called in BpmProvider
   - Cancels existing reset timer
   - Records timestamp and updates count
   - Starts new 5-second reset timer
2. Timestamp is recorded and added to tapTimestamps list
3. _calculateBpm() analyzes timestamps and updates currentBpm
   - Validates minimum 2 taps
   - Calculates time span between first and last tap
   - Applies BPM formula with validation
   - Updates error state if needed
   - Sets accuracy note based on tap count
4. Consumer widgets in the UI update to reflect new state
5. Validation ensures BPM values are within 40-200 range
6. Reset functionality clears all state when requested
   - Manual reset through reset button
   - Auto-reset after 5 seconds of inactivity

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
- Provider (^6.0.0) for state management
- Permission Handler (^10.0.0) for microphone access
