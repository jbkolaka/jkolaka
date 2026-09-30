import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';

/// Body content of the HACKATHONS section, rendered inside the shared
/// portfolio scaffold alongside the work body.
class HackathonsBody extends StatelessWidget {
  const HackathonsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing07),
        child: Text(
          'Hackathons I\'ve participated in',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}