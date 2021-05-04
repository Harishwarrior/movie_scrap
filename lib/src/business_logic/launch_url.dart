import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String magnet) async {
  if (await canLaunch(magnet)) {
    await launch(magnet);
  } else {
    throw 'Could not launch $magnet';
  }
}
