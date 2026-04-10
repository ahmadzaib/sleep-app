import 'package:avatar_flow/features/splash/home/views/components/home_appbar.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: HomeAppbar(),
      ),
    );
  }
}
