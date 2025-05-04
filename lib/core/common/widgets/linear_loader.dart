import 'package:flutter/material.dart';

class LinearLoader extends StatelessWidget {
  final bool loading;

  const LinearLoader({super.key, required this.loading});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: loading ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: const LinearProgressIndicator(),
    );
  }
}
