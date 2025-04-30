import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Presentation/Themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppThemes.lightTheme) {
    _loadTheme();
  }

  bool isDarkTheme = false;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? true;
    if (!isDarkTheme) {
      emit(AppThemes.darkTheme);
    } else {
      emit(AppThemes.lightTheme);
    }
  }

  void setSystemTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      emit(AppThemes.darkTheme);
    } else {
      emit(AppThemes.lightTheme);
    }
  }

  Future<void> setMode(bool mode) async {
    isDarkTheme = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
    if (mode) {
      emit(AppThemes.darkTheme);
    } else {
      emit(AppThemes.lightTheme);
    }
  }
}
