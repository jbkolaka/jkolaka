import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text('JOE KOLAKA'),
                SizedBox(width: AppSpacing.spacing03),
                Text('MOBILE DEVELOPER'),
                SizedBox(width: AppSpacing.spacing03),
                Text('*'),
                SizedBox(width: AppSpacing.spacing03),
                Text('GO BACKEND DEVELOPER'),
              ],
            ),
            Row(
              children: const [
                Text('WORK'),
                SizedBox(width: AppSpacing.spacing03),
                Text('HACKATHONS'),
                SizedBox(width: AppSpacing.spacing03),
                Text('RESUME'),
              ],
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          SizedBox(height: AppSpacing.spacing09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('I\'m a mobile and backend developer \nso full stack'),
            ],
          ),
        ],
      ),
    );
  }
}
