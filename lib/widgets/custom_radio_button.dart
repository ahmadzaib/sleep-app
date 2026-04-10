import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final double size;
  final Duration duration;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 20,
    this.duration = const Duration(milliseconds: 250),
  });

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final unselected = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: AnimatedContainer(
        duration: duration,
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isSelected ? primary : unselected,
            width: 2.r,
          ),
        ),
        child:
            _isSelected
                ? Center(
                  child: AnimatedContainer(
                    duration: duration,
                    width: (size / 2).r,
                    height: (size / 2).r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
