
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroScreenVM {
  late final WidgetRef _ref;
  IntroScreenVM(this._ref);

  final currentIndex = StateProvider<int>((ref) => 0);

  void updateSlideIndex(int index) async {
    _ref.refresh(currentIndex.notifier).state = index;
  }

}