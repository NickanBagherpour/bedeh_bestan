import 'package:core/core.dart'
    show bazaarAppDetailsUri, bazaarWebListingUri;
import 'package:url_launcher/url_launcher.dart';

/// Opens the Bazaar listing (app if installed, otherwise the web page).
Future<bool> openBazaarListing() async {
  if (await canLaunchUrl(bazaarAppDetailsUri)) {
    return launchUrl(bazaarAppDetailsUri, mode: LaunchMode.externalApplication);
  }
  return launchUrl(bazaarWebListingUri, mode: LaunchMode.externalApplication);
}
