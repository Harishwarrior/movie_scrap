import 'package:flutter/material.dart';
import 'package:moviescrap/src/theme/theme_notifier.dart';
import 'package:moviescrap/src/views/ui/home_view.dart';
import 'package:moviescrap/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (context) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'MovieScrap',
      theme: themeNotifier.getTheme(),
      home: HomePage(),
    );
  }
}
