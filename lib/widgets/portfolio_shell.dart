import 'package:flutter/material.dart';

import '../feature/hackathon/presentation/hackathons_body.dart';
import '../feature/work/presentation/work_page.dart';
import 'portfolio_nav_bar.dart';

/// Root portfolio page. Keeps one scaffold and one app bar; switching a
/// section only swaps the body.
class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  PortfolioSection _section = PortfolioSection.work;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PortfolioNavBar(
        current: _section,
        onSectionSelected: (section) {
          if (section == _section) return;
          setState(() => _section = section);
        },
      ),
      body: switch (_section) {
        PortfolioSection.work => const WorkBody(),
        PortfolioSection.hackathons => const HackathonsBody(),
      },
    );
  }
}