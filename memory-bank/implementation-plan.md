# **BPM Counter App Implementation Plan**

This document provides a detailed, step-by-step implementation plan for building a Beats Per Minute (BPM) Counter App using Flutter and Dart. The app supports two modes: **Tap Mode** for manual BPM calculation via screen taps and **Auto Mode** for automatic BPM detection using the microphone. Each step includes specific instructions and a test to validate correct implementation, ensuring a robust, cross-platform app for iOS and Android.

---

## **Step 1: Set Up the Flutter Project**

**Instructions:**

* Ensure Flutter and Dart are installed on your development machine (refer to [Flutter's official installation guide](https://flutter.dev/docs/get-started/install) if needed).  
* Open a terminal and run the following command to create a new Flutter project:  
   text  
  CollapseWrapCopy  
  `flutter create bpm_counter_app`

* Navigate to the project directory:  
   text  
  CollapseWrapCopy  
  `cd bpm_counter_app`

* Open the project in your preferred IDE (e.g., Visual Studio Code or Android Studio).

**Test:**

* Run the app using flutter run on an emulator or physical device.  
* Verify that the default Flutter counter app launches successfully, displaying a button and a number.

---

## **Step 2: Add Dependencies to pubspec.yaml**

**Instructions:**

* Open the pubspec.yaml file in the project root.

Under dependencies, add the following lines:  
 yaml  
CollapseWrapCopy  
`dependencies:`  
  `flutter:`  
    `sdk: flutter`  
  `provider: ^6.0.0`

*   `permission_handler: ^10.0.0`

* Save the file and run flutter pub get in the terminal to install the dependencies.

**Test:**

* Open lib/main.dart, add import 'package:provider/provider.dart'; and import 'package:permission\_handler/permission\_handler.dart'; at the top.  
* Run flutter analyze to check for import errors; ensure no errors are reported.

---

## **Step 3: Set Up State Management with Provider**

**Instructions:**

* Create a new directory lib/providers.  
* Inside lib/providers, create a file named bpm\_provider.dart.  
* Define a BpmProvider class that extends ChangeNotifier.  
* Add properties:  
  * A list to store tap timestamps (e.g., List\<int\>).  
  * A variable for the current BPM (e.g., double?).  
  * A variable for the tap count (e.g., int).  
  * A variable for Auto Mode status (e.g., String like "Listening...").  
  * A variable for audio processing duration (default: 10 seconds).  
  * A variable for error state (e.g., String? for error messages).  
* Add methods to:
  * Validate BPM values (ensure they're between 40-200).  
  * Update audio processing duration.  
  * Handle and clear errors.  
* Add a method to notify listeners when state changes.

**Test:**

* In lib/main.dart, wrap the MaterialApp widget with a ChangeNotifierProvider using BpmProvider.  
* Add a Text widget to display the tap count from the provider.  
* Run the app and verify the initial tap count (e.g., 0\) displays correctly.

---

## **Step 4: Design the Main UI with Mode Selection**

**Instructions:**

* Open lib/main.dart and replace the default scaffold with a Scaffold containing a TabBar and TabBarView.  
* Set up two tabs: "Tap Mode" and "Auto Mode".  
* Use a DefaultTabController to manage tab navigation.  
* Create placeholder content for each tab (e.g., a Text widget saying "Tap Mode" and "Auto Mode").  
* Implement platform-specific UI elements:
  * Use CupertinoButton for iOS and ElevatedButton for Android.  
  * Apply platform-specific padding and spacing.  
  * Use platform-specific icons (CupertinoIcons for iOS, MaterialIcons for Android).

**Test:**

* Run the app on both iOS and Android.  
* Switch between tabs and confirm the UI updates to show "Tap Mode" and "Auto Mode" content correctly.  
* Verify platform-specific UI elements render appropriately.

---

## **Step 5: Build the Tap Mode UI**

**Instructions:**

* Create a new file lib/screens/tap\_mode\_screen.dart.  
* Add a StatefulWidget named TapModeScreen.  
* In the build method, return a Column with:  
  * A GestureDetector covering most of the screen (e.g., wrapped in an Expanded widget) for tapping.  
  * A Text widget to display BPM (e.g., "BPM: \--").  
  * A Text widget for tap count (e.g., "Taps: 0").  
  * A Text widget for accuracy note (e.g., "More taps needed for accuracy").  
  * An ElevatedButton labeled "Reset".  
* Use Provider.of\<BpmProvider\> to read state values.

**Test:**

* Update TabBarView in main.dart to use TapModeScreen for the first tab.  
* Run the app, navigate to Tap Mode, and verify all UI elements (tap area, BPM, tap count, accuracy note, reset button) are visible.

---

## **Step 6: Implement Tap Detection and Timestamp Recording**

**Instructions:**

* In tap\_mode\_screen.dart, add an onTap callback to the GestureDetector.  
* In the callback, use Provider.of\<BpmProvider\> to access the provider.  
* Call a method in BpmProvider (e.g., recordTap) that:  
  * Uses Stopwatch to get the current time in milliseconds since the app started.  
  * Adds the timestamp to the tap timestamps list.  
  * Increments the tap count.  
  * Notifies listeners.

**Test:**

* Run the app, go to Tap Mode, and tap the screen several times.  
* Check that the tap count increases with each tap (e.g., "Taps: 1", "Taps: 2").

---

## **Step 7: Calculate BPM in Tap Mode**

**Instructions:**

* In bpm\_provider.dart, add a method (e.g., calculateBpm) that:  
  * Checks if there are at least 2 taps.  
  * Calculates BPM using the formula: (number of taps \- 1\) \* 60 / (last timestamp \- first timestamp in seconds).  
  * Converts milliseconds to seconds for the time difference.  
  * Updates the BPM property and notifies listeners.  
* Call this method in recordTap after adding a timestamp.

**Test:**

* Tap the screen twice and verify the BPM updates (e.g., "BPM: 60" for taps 1 second apart).  
* Tap multiple times and confirm BPM adjusts based on tap speed.

---

## **Step 8: Implement Accuracy Note Logic**

**Instructions:**

* In bpm\_provider.dart, add a property for the accuracy note (e.g., String?).  
* In calculateBpm, set the note to "More taps needed for accuracy" if taps \< 5, otherwise clear it.  
* In tap\_mode\_screen.dart, display the accuracy note only if it's not null.

**Test:**

* Tap 3 times and check that "More taps needed for accuracy" appears.  
* Tap 5 times and verify the note disappears.

---

## **Step 9: Add Reset Functionality for Tap Mode**

**Instructions:**

* In bpm\_provider.dart, add a reset method that:  
  * Clears the tap timestamps list.  
  * Resets tap count, BPM, and accuracy note to initial values.  
  * Notifies listeners.  
* In tap\_mode\_screen.dart, add an onPressed callback to the Reset button that calls reset.  
* Add a timer in recordTap to call reset if no tap occurs for 5 seconds (use Timer from dart:async).

**Test:**

* Tap 3 times, then press Reset; verify BPM, tap count, and accuracy note reset.  
* Tap twice, wait 5 seconds, and confirm the UI resets automatically.

---

## **Step 10: Build the Auto Mode UI**

**Instructions:**

* Create a new file lib/screens/auto\_mode\_screen.dart.  
* Add a StatefulWidget named AutoModeScreen.  
* In the build method, return a Center widget with a Text widget displaying the Auto Mode status from the provider (e.g., "Listening...").

**Test:**

* Update TabBarView in main.dart to use AutoModeScreen for the second tab.  
* Run the app, switch to Auto Mode, and verify "Listening..." is displayed.

---

## **Step 11: Request Microphone Permission**

**Instructions:**

* In auto\_mode\_screen.dart, override initState to check microphone permission using permission\_handler.  
* If permission is not granted, request it with Permission.microphone.request().  
* Update the provider's status to "Permission denied" if denied, or "Listening..." if granted.

**Test:**

* Run the app, switch to Auto Mode, and confirm a permission dialog appears.  
* Deny permission and verify the status changes to "Permission denied".

---

## **Step 12: Set Up Platform Channels**

**Instructions:**

* In bpm\_provider.dart, define a MethodChannel with a unique name (e.g., "com.example.bpm/audio").  
* Add methods startAudioProcessing and stopAudioProcessing to invoke native methods via the channel.  
* Add a method to receive BPM results and update the status.  
* Configure audio processing parameters:
  * Set sample rate to 44,100 Hz.  
  * Set buffer size to 1,024 frames.  
  * Implement error handling for hardware failures.  
  * Add permission state monitoring.

**Test:**

* Temporarily set a dummy native method to return "BPM: 100".  
* Call startAudioProcessing in initState of AutoModeScreen and verify the status updates to "BPM: 100".  
* Test error handling by simulating hardware failures.

---

## **Step 13: Implement Native Audio Processing (Android)**

**Instructions:**

* Create a file android/app/src/main/java/com/example/bpm\_counter\_app/MainActivity.java.  
* Define a method channel handler to process audio using the Aubio library.  
* Implement a method to capture audio with AudioRecord and pass it to Aubio for beat detection.  
* Return the detected BPM via the channel.

**Test:**

* Call the native method from Flutter and verify a BPM value is returned (use a test audio file if needed).

---

## **Step 14: Implement Native Audio Processing (iOS)**

**Instructions:**

* Create a file ios/Runner/AppDelegate.swift.  
* Define a method channel handler in Swift to process audio using Aubio.  
* Use AVAudioEngine to capture audio and pass it to Aubio for beat detection.  
* Return the detected BPM via the channel.

**Test:**

* Call the native method from Flutter on an iOS device/emulator and verify a BPM value is returned.

---

## **Step 15: Implement Automatic BPM Detection Logic**

**Instructions:**

* In bpm\_provider.dart, update startAudioProcessing to:  
  * Set status to "Listening..." for 10 seconds.  
  * After 10 seconds, use the native BPM result or set "No clear beat pattern" if none detected.  
* Call startAudioProcessing when entering Auto Mode and stopAudioProcessing when leaving.

**Test:**

* Play music with a clear beat (e.g., 120 BPM) and verify "BPM: 120" appears after 10 seconds.  
* Test with silence and confirm "No clear beat pattern" displays.

---

## **Step 16: Handle Edge Cases**

**Instructions:**

* In Tap Mode:  
  * If taps \= 1, set BPM to "Tap at least twice to calculate BPM."  
  * If taps \< 5, show an estimate with the accuracy note.  
* In Auto Mode:  
  * Handle silence/noise by showing "No clear beat pattern" after 10 seconds.  
  * Handle complex rhythms similarly.

**Test:**

* Tap once and verify the correct message appears.  
* Play complex music (e.g., jazz) in Auto Mode and confirm "No clear beat pattern".

---

## **Step 17: Optimize Performance**

**Instructions:**

* In bpm\_provider.dart, use efficient data structures (e.g., List\<int\> for timestamps).  
* Minimize UI rebuilds by using Consumer selectively in TapModeScreen and AutoModeScreen.  
* Ensure native audio processing stops when not in Auto Mode.  
* Implement performance monitoring:
  * Track CPU usage (target: <20% idle, <50% during audio processing).  
  * Monitor memory usage (target: <100MB).  
  * Add performance logging for debugging.

**Test:**

* Monitor CPU usage with flutter run \--profile and confirm low resource usage during both modes.  
* Use Android Studio's Memory Profiler to verify memory usage stays under 100MB.  
* Test on low-end devices to ensure smooth performance.

---

## **Step 18: Ensure Cross-Platform Compatibility**

**Instructions:**

* Test the app on both iOS and Android emulators/devices.  
* Use Platform.isIOS for any platform-specific tweaks if issues arise.

**Test:**

* Run on an Android emulator and iOS simulator; verify both modes work as expected.

---

## **Step 19: Write Unit Tests**

**Instructions:**

* Create a test/bpm\_provider\_test.dart file.  
* Write tests for:  
  * BPM calculation with sample timestamps.  
  * Reset functionality clearing all values.  
  * BPM validation (40-200 range).  
  * Error handling scenarios.  
* Create widget tests for UI components:
  * Test platform-specific UI elements.  
  * Verify error messages display correctly.  
  * Test audio processing duration settings.  
* Add integration tests for platform channels:
  * Test audio processing start/stop.  
  * Verify error handling in native code.  
* Use flutter\_test package.

**Test:**

* Run flutter test and ensure all tests pass.  
* Verify test coverage for critical paths.

---

## **Step 20: Document the Code**

**Instructions:**

* Add comments in bpm\_provider.dart explaining BPM calculation logic.  
* Use descriptive variable names (e.g., tapTimestamps instead of list).  
* Keep methods short (e.g., separate tap recording and BPM calculation).

**Test:**

* Review the code and confirm it's readable and well-commented.

---

## **Step 21: Set Up Version Control**

**Instructions:**

* Initialize a Git repository with git init.  
* Commit initial changes with git commit \-m "Initial project setup".  
* Create a branch for each major feature (e.g., git checkout \-b tap-mode).

**Test:**

* Run git log and verify commit history reflects progress.

