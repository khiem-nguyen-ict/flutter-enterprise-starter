import 'package:flutter/material.dart';

import '../../../../config/l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text(l10n.login),
        ),
      ),
    );
  }
}
