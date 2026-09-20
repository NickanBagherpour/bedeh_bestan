import 'package:core/core.dart'
    show bazaarAppDetailsUri, bazaarWebListingUri;
import 'package:url_launcher/url_launcher.dart';

import '../data/bazaar_update_check.dart';

/// Opens the Bazaar listing (native channel on Android, else URL).
Future<bool> openBazaarListing() async {
  if (await openBazaarAppPageNative()) return true;
  if (await canLaunchUrl(bazaarAppDetailsUri)) {
    return launchUrl(bazaarAppDetailsUri, mode: LaunchMode.externalApplication);
  }
  return launchUrl(bazaarWebListingUri, mode: LaunchMode.externalApplication);
}
