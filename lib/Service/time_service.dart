import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;

  static DocumentReference<Map<String, dynamic>> get _userDoc =>
      _fs.collection('users').doc(_user!.uid);

  static Stopwatch? _stopwatch;
  static Timer? _periodicTimer;

  /// Start tracking total time spent for the current user.
  static void startTracking() {
    if (_user == null) return;
    if (_stopwatch != null && _stopwatch!.isRunning) return;

    _stopwatch ??= Stopwatch()..start();

    // Save time every minute (optional)
    _periodicTimer ??= Timer.periodic(const Duration(minutes: 1), (_) {
      saveTime();
    });
  }

  /// Stop tracking and save the current session time.
  static Future<void> stopTracking() async {
    if (_user == null) return;
    if (_stopwatch == null) return;

    _stopwatch!.stop();
    await saveTime();

    _stopwatch = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  /// Save elapsed time to Firestore, incrementing the user's total time spent.
  static Future<void> saveTime() async {
    if (_user == null || _stopwatch == null) return;

    final elapsedSeconds = _stopwatch!.elapsed.inSeconds;
    if (elapsedSeconds == 0) return;

    _stopwatch!.reset();
    _stopwatch!.start();

    try {
      await _userDoc.update({
        'timeSpent': FieldValue.increment(elapsedSeconds),
      });
    } catch (e) {
      // If the document doesn't exist yet, create it with initial timeSpent
      await _userDoc.set({'timeSpent': elapsedSeconds}, SetOptions(merge: true));
    }
  }

  /// Retrieve the total time spent (in seconds) for the current user.
  static Future<int> getTotalTimeSpent() async {
    if (_user == null) return 0;
    final snap = await _userDoc.get();
    if (!snap.exists) return 0;
    final data = snap.data();
    return data?['timeSpent'] ?? 0;
  }

  /// Format seconds into a human-readable string (days, hours, minutes, seconds).
  static String formatTimeSpent(int seconds) {
    const int secInMinute = 60;
    const int secInHour = 3600;
    const int secInDay = 86400;

    if (seconds >= secInDay) {
      final days = (seconds / secInDay).floor();
      final remainder = seconds % secInDay;
      final hours = (remainder / secInHour).floor();
      return '$days day${days > 1 ? 's' : ''}${hours > 0 ? ' $hours hour${hours > 1 ? 's' : ''}' : ''}';
    } else if (seconds >= secInHour) {
      final hours = (seconds / secInHour).floor();
      final remainder = seconds % secInHour;
      final minutes = (remainder / secInMinute).floor();
      return '$hours hour${hours > 1 ? 's' : ''}${minutes > 0 ? ' $minutes minute${minutes > 1 ? 's' : ''}' : ''}';
    } else if (seconds >= secInMinute) {
      final minutes = (seconds / secInMinute).floor();
      final secs = seconds % secInMinute;
      return '$minutes minute${minutes > 1 ? 's' : ''}${secs > 0 ? ' $secs second${secs > 1 ? 's' : ''}' : ''}';
    } else {
      return '$seconds second${seconds > 1 ? 's' : ''}';
    }
  }
}