import 'package:flutter/foundation.dart';

class BpmProvider extends ChangeNotifier {
  // Properties
  final List<int> _tapTimestamps = [];
  double? _currentBpm;
  int _tapCount = 0;
  String _autoModeStatus = 'Not started';
  int _audioProcessingDuration = 10; // Default 10 seconds
  String? _errorState;
  String? _accuracyNote;

  // Getters
  List<int> get tapTimestamps => _tapTimestamps;
  double? get currentBpm => _currentBpm;
  int get tapCount => _tapCount;
  String get autoModeStatus => _autoModeStatus;
  int get audioProcessingDuration => _audioProcessingDuration;
  String? get errorState => _errorState;
  String? get accuracyNote => _accuracyNote;

  // Methods
  void recordTap() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _tapTimestamps.add(timestamp);
    _tapCount++;
    _calculateBpm();
    notifyListeners();
  }

  void _calculateBpm() {
    if (_tapTimestamps.length < 2) {
      _currentBpm = null;
      _accuracyNote = 'Tap at least twice to calculate BPM';
      return;
    }

    final timeSpan = (_tapTimestamps.last - _tapTimestamps.first) / 1000; // Convert to seconds
    final calculatedBpm = (_tapCount - 1) * 60 / timeSpan;

    // Validate BPM range (40-200)
    if (calculatedBpm < 40 || calculatedBpm > 200) {
      _currentBpm = null;
      _errorState = 'BPM out of valid range (40-200)';
      return;
    }

    _currentBpm = calculatedBpm;
    _errorState = null;

    // Update accuracy note
    if (_tapCount < 5) {
      _accuracyNote = 'More taps needed for accuracy';
    } else {
      _accuracyNote = null;
    }
  }

  void reset() {
    _tapTimestamps.clear();
    _currentBpm = null;
    _tapCount = 0;
    _errorState = null;
    _accuracyNote = null;
    notifyListeners();
  }

  void setAudioProcessingDuration(int seconds) {
    if (seconds < 1 || seconds > 60) {
      _errorState = 'Duration must be between 1 and 60 seconds';
      return;
    }
    _audioProcessingDuration = seconds;
    notifyListeners();
  }

  void setAutoModeStatus(String status) {
    _autoModeStatus = status;
    notifyListeners();
  }

  void setError(String? error) {
    _errorState = error;
    notifyListeners();
  }
} 