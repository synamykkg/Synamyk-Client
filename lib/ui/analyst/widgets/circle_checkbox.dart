
import 'package:flutter/material.dart';

class CircleCheckbox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CircleCheckbox({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.purple,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}