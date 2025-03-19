import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  Future<void> launchHospitalMap() async {
    var url = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': 'Hospital'});
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> call(String number) async {
    final Uri callLaunchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunchUrl(callLaunchUri)) {
      await launchUrl(callLaunchUri);
    }
  }

  Future<void> openMail() async {
    final Uri mailLaunchUri = Uri(
      scheme: 'mailTo',
    );

    try {
      launchUrl(mailLaunchUri);
    } catch (_) {}
  }
}
