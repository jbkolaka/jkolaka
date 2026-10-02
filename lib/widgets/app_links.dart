import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens links and mail addresses from the portfolio.
///
/// Falls back to copying the address to the clipboard when no handler is
/// registered, so a tap always does something visible.
class AppLinks {
  const AppLinks._();

  static Future<void> open(BuildContext context, String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    final bool supported =
        await canLaunchUrl(uri) || await canLaunchUrl(
          Uri(scheme: 'mailto', path: uri.path),
        );
    if (supported) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied $url')));
  }
}
