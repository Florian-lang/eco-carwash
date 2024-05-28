import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/logout_modal_widget.dart';

final class ToolsService {
  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto', // Le schema mailto
      path: 'cosaj31459@qiradio.com',  // l'adresse mail d'aide généré par TempMail
      query: encodeQueryParameters(<String, String>{
        'subject': 'Support Request',
      }),
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // l'utilisateur doit taper sur un bouton pour fermer
      builder: (BuildContext context) {
        return const LogoutModalWidget();
      },
    );
  }

}