import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrtTestBottomBarCompletedView extends StatelessWidget {
  const OrtTestBottomBarCompletedView({
    super.key,
    required this.language,
    required this.id,
  });

  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 218,
      height: 62,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          GestureDetector(
            onTap: () {
              // context.go('');
            },
            child: Center(
              child: Icon(
                Icons.share,
                size: 26,
                color: Color(0xFF666666).withOpacity(0.5),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go('/ort_test/$language/$id');
            },
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Color(0xFF7B1FA2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Icon(Icons.replay, color: Color(0xFFFFFFFF), size: 30),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              context.go('/home/');
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF666666).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  size: 15,
                  color: Color(0xFF666666).withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
