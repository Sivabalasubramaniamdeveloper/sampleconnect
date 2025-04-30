import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ThemeCubit/ThemeCubit.dart';

class ThemeListener extends StatefulWidget {
  final Widget child;

  const ThemeListener({super.key, required this.child});

  @override
  _ThemeListenerState createState() => _ThemeListenerState();
}

class _ThemeListenerState extends State<ThemeListener> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    context.read<ThemeCubit>().setSystemTheme(brightness);

    return widget.child;
  }
}
