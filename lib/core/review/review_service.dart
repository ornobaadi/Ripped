import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

/// Asks the store to show its rating sheet. The store decides whether it
/// really appears (it rate-limits), so this never promises anything.
abstract interface class ReviewService {
  Future<void> request();
}

class StoreReviewService implements ReviewService {
  const new();

  @override
  Future<void> request() async {
    if (kIsWeb) return;
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) await review.requestReview();
    } on Object catch (e) {
      // Never let a rating prompt break the end of a workout.
      debugPrint('Review prompt unavailable: $e');
    }
  }
}
