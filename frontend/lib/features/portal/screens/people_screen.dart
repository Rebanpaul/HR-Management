import 'package:flutter/material.dart';

class PeopleScreen extends StatelessWidget {
  final VoidCallback onOpenProfile;

  const PeopleScreen({
    super.key,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          'People',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Browse your team and key contacts.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1100;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: isWide
                      ? (constraints.maxWidth * 0.64)
                      : constraints.maxWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Directory',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Text(
                                  'A–Z',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _PersonRow(
                            name: 'Rachel Johnson',
                            role: 'Marketing Director',
                            leadingColor: colorScheme.primaryContainer,
                            leadingIcon: Icons.person_rounded,
                          ),
                          Divider(color: colorScheme.outlineVariant),
                          _PersonRow(
                            name: 'Sarah Lee',
                            role: 'Software Engineer',
                            leadingColor: colorScheme.secondaryContainer,
                            leadingIcon: Icons.person_rounded,
                          ),
                          Divider(color: colorScheme.outlineVariant),
                          _PersonRow(
                            name: 'Michael Carter',
                            role: 'HR Specialist',
                            leadingColor: colorScheme.tertiaryContainer,
                            leadingIcon: Icons.person_rounded,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Employee directory and org chart are placeholders for now.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: isWide
                      ? (constraints.maxWidth * 0.34)
                      : constraints.maxWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Team',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _TeamStat(label: 'Team members', value: '8'),
                          _TeamStat(label: 'Open roles', value: '1'),
                          _TeamStat(label: 'On leave today', value: '0'),
                          const SizedBox(height: 12),
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Org chart and teams\ncoming soon',
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.account_tree_rounded,
                                    color: colorScheme.onPrimary
                                        .withValues(alpha: 220),
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String name;
  final String role;
  final Color leadingColor;
  final IconData leadingIcon;

  const _PersonRow({
    required this.name,
    required this.role,
    required this.leadingColor,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: leadingColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(leadingIcon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _TeamStat extends StatelessWidget {
  final String label;
  final String value;

  const _TeamStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
