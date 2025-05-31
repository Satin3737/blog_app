import 'package:flutter/material.dart';

class LinearLoader extends StatelessWidget {
  final bool loading;

  const LinearLoader({super.key, required this.loading});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child:
          loading
              ? const LinearProgressIndicator(key: ValueKey('loader'))
              : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
