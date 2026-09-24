import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../widget/work_list.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    'JOE KOLAKA',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'MOBILE DEVELOPER',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  const Text('*'),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'GO BACKEND DEVELOPER',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      'WORK',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'HACKATHONS',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'RESUME',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.spacing10 * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'I\'m a mobile and backend developer \nso full stack',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const Expanded(child: WorkList()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
