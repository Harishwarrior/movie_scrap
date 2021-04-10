import 'package:moviescrap/src/theme/theme.dart';
import 'package:moviescrap/src/theme/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
      ? themeNotifier.setTheme(darkTheme)
      : themeNotifier.setTheme(lightTheme);
  var prefs = await SharedPreferences.getInstance();
  await prefs.setBool('darkMode', value);
}
