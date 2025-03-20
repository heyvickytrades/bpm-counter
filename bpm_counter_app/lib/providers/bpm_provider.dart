import 'package:flutter/foundation.dart';
import 'dart:async';

class BpmProvider extends ChangeNotifier {
  // Properties
  final List<int> _tapTimestamps = [];
  double? _currentBpm;
  int _tapCount = 0;
  String _autoModeStatus = 'Not started';
  int _audioProcessingDuration = 10; // Default 10 seconds
  String? _errorState;
  String? _accuracyNote;
  Timer? _resetTimer;

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
    // Cancel any existing reset timer
    _resetTimer?.cancel();
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _tapTimestamps.add(timestamp);
    _tapCount++;
    _calculateBpm();
    
    // Start a new reset timer
    _resetTimer = Timer(const Duration(seconds: 5), reset);
    
    notifyListeners();
  }

  void _calculateBpm() {
    if (_tapTimestamps.length < 2) {
      _currentBpm = null;
      _accuracyNote = null;
      return;
    }

    final timeSpan = (_tapTimestamps.last - _tapTimestamps.first) / 1000; // Convert to seconds
    final calculatedBpm = (_tapCount - 1) * 60 / timeSpan;

    // Validate BPM range (40-200)
    if (calculatedBpm < 40 || calculatedBpm > 200) {
      _currentBpm = null;
      _errorState = 'BPM out of valid range (40-200)';
      _accuracyNote = null;
      return;
    }

    _currentBpm = calculatedBpm;
    _errorState = null;
    
    // Set accuracy note based on tap count
    _accuracyNote = _tapCount < 5 ? 'More taps needed for accuracy' : null;
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void reset() {
    _resetTimer?.cancel();
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