import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgWidget(child: Scaffold(backgroundColor: Colors.transparent));
  }
}
