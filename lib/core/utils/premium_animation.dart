// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class PremiumAnimation extends StatelessWidget {
//   final Widget child;
//   final Duration delay;
//   final Duration duration;
//   final Offset slideOffset;
//   final double beginOpacity;
//   final double endOpacity;
//   final double beginScale;
//   final double endScale;
//   final Curve curve;

//   const PremiumAnimation({
//     super.key,
//     required this.child,
//     this.delay = Duration.zero,
//     this.duration = const Duration(milliseconds: 600),
//     this.slideOffset = const Offset(0, 0.1),
//     this.beginOpacity = 0.0,
//     this.endOpacity = 1.0,
//     this.beginScale = 1.0,
//     this.endScale = 1.0,
//     this.curve = Curves.easeOutCubic,
//   });

//   /// standard fade in from bottom effect
//   factory PremiumAnimation.fadeInUp({
//     required Widget child,
//     Duration delay = Duration.zero,
//     Duration duration = const Duration(milliseconds: 600),
//     double slideDistance = 30.0,
//   }) {
//     return PremiumAnimation(
//       delay: delay,
//       duration: duration,
//       slideOffset: Offset(0, slideDistance / 100),
//       child: child,
//     );
//   }

//   /// fade in from top
//   factory PremiumAnimation.fadeInDown({
//     required Widget child,
//     Duration delay = Duration.zero,
//     Duration duration = const Duration(milliseconds: 600),
//     double slideDistance = -30.0,
//   }) {
//     return PremiumAnimation(
//       delay: delay,
//       duration: duration,
//       slideOffset: Offset(0, slideDistance / 100),
//       child: child,
//     );
//   }

//   /// standard fade in with scale
//   factory PremiumAnimation.scaleIn({
//     required Widget child,
//     Duration delay = Duration.zero,
//     Duration duration = const Duration(milliseconds: 600),
//     double beginScale = 0.8,
//   }) {
//     return PremiumAnimation(
//       delay: delay,
//       duration: duration,
//       beginScale: beginScale,
//       slideOffset: Offset.zero,
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var animation = child
//         .animate(delay: delay)
//         .fadeIn(duration: duration, begin: beginOpacity, curve: curve);

//     if (slideOffset != Offset.zero) {
//       animation = animation.slide(
//         begin: slideOffset,
//         end: Offset.zero,
//         duration: duration,
//         curve: curve,
//       );
//     }

//     if (beginScale != endScale) {
//       animation = animation.scale(
//         begin: Offset(beginScale, beginScale),
//         end: Offset(endScale, endScale),
//         duration: duration,
//         curve: curve,
//       );
//     }

//     return animation;
//   }
// }

// /// A helper class to handle staggered animations in lists
// class StaggeredListAnimation extends StatelessWidget {
//   final List<Widget> children;
//   final Duration interval;
//   final Duration initialDelay;

//   const StaggeredListAnimation({
//     super.key,
//     required this.children,
//     this.interval = const Duration(milliseconds: 100),
//     this.initialDelay = Duration.zero,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(children.length, (index) {
//         return PremiumAnimation.fadeInUp(
//           delay: initialDelay + (interval * index),
//           child: children[index],
//         );
//       }),
//     );
//   }
// }
