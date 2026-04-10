// import 'package:flutter/material.dart';
// import 'package:avatar_flow/core/theme/app_colors.dart';

// class ErrorBoundary extends StatefulWidget {
//   final Widget child;
//   final Widget? fallback;
//   final Function(Object error, StackTrace stackTrace)? onError;

//   const ErrorBoundary({
//     super.key,
//     required this.child,
//     this.fallback,
//     this.onError,
//   });

//   @override
//   State<ErrorBoundary> createState() => _ErrorBoundaryState();
// }

// class _ErrorBoundaryState extends State<ErrorBoundary> {
//   Object? _error;
//   bool _hasError = false;

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError && _error != null) {
//       return widget.fallback ?? _buildDefaultErrorWidget();
//     }

//     // Use a simple try-catch approach with a custom widget
//     return _SafeWidget(
//       onError: (error, stackTrace) {
//         if (mounted) {
//           setState(() {
//             _error = error;
//             _hasError = true;
//           });
//           widget.onError?.call(error, stackTrace);
//         }
//       },
//       child: widget.child,
//     );
//   }

//   Widget _buildDefaultErrorWidget() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.red.withValues(alpha: 0.1),
//         border: Border.all(color: Colors.red, width: 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 32),
//           const SizedBox(height: 8),
//           const Text(
//             'Something went wrong',
//             style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Please try again or contact support if the problem persists.',
//             style: TextStyle(color: Colors.red.shade700, fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//           if (_error != null) ...[
//             const SizedBox(height: 4),
//             Text(
//               'Error: ${_error.toString()}',
//               style: TextStyle(
//                 color: Colors.red.shade600,
//                 fontSize: 10,
//                 fontFamily: 'monospace',
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _error = null;
//                 _hasError = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Safe widget wrapper that catches build errors
// class _SafeWidget extends StatelessWidget {
//   final Widget child;
//   final Function(Object error, StackTrace stackTrace) onError;

//   const _SafeWidget({required this.child, required this.onError});

//   @override
//   Widget build(BuildContext context) {
//     try {
//       return child;
//     } catch (error, stackTrace) {
//       // Handle synchronous errors
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         onError(error, stackTrace);
//       });

//       return Container(
//         padding: const EdgeInsets.all(8),
//         child: const Center(
//           child: Text('Loading...', style: TextStyle(color: Colors.grey)),
//         ),
//       );
//     }
//   }
// }
