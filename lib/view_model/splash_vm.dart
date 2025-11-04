
// State providers for animation states
import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationsInitializedProvider = StateProvider<bool>((ref) => false);
final truckListenerAddedProvider = StateProvider<bool>((ref) => false);

// Animation controllers provider
final animationControllersProvider = Provider.family<AnimationController?, String>((ref, controllerId) {
  return null; // Will be overridden in the widget
});