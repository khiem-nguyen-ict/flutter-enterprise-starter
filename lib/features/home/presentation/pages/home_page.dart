import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/l10n/app_localizations.dart';
import '../../../../features/profile/presentation/provider/mock_user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(mockUserProvider);

    final stats = [
      _StatTile(
        label: l10n.revenue,
        value: '\$48.2k',
        trend: '+12.5%',
        icon: Icons.attach_money_outlined,
        color: Colors.green,
      ),
      _StatTile(
        label: l10n.activeUsers,
        value: '8,412',
        trend: '+3.1%',
        icon: Icons.people_outline,
        color: Colors.blue,
      ),
      _StatTile(
        label: l10n.orders,
        value: '1,204',
        trend: '+8.0%',
        icon: Icons.shopping_bag_outlined,
        color: Colors.orange,
      ),
      _StatTile(
        label: l10n.conversion,
        value: '4.8%',
        trend: '-0.4%',
        icon: Icons.show_chart_outlined,
        color: Colors.red,
      ),
    ];

    final activity = [
      _ActivityItem(
        title: 'New order #10241',
        subtitle: 'A customer placed a \$129.00 order',
        time: '2m ago',
        icon: Icons.shopping_bag_outlined,
      ),
      _ActivityItem(
        title: 'New follower',
        subtitle: 'Grace Hopper started following you',
        time: '1h ago',
        icon: Icons.person_add_outlined,
      ),
      _ActivityItem(
        title: 'Payout completed',
        subtitle: '\$2,340.00 was sent to your bank',
        time: '5h ago',
        icon: Icons.account_balance_wallet_outlined,
      ),
      _ActivityItem(
        title: 'Comment on your post',
        subtitle: 'Alan Turing commented on "Design systems"',
        time: '1d ago',
        icon: Icons.comment_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                user.initials,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            tooltip: l10n.viewProfile,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${l10n.welcomeBack}, ${user.name.split(' ').first}!',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) => _StatCard(tile: stats[index]),
          ),
          const SizedBox(height: 24),
          Card(
            child: InkWell(
              onTap: () => context.push('/profile'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        user.initials,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: theme.textTheme.titleMedium),
                          Text(
                            user.role,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/profile'),
                      child: Text(l10n.viewProfile),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.recentActivity, style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: () => context.push('/settings'),
                child: Text(l10n.goToSettings),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: activity.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _ActivityListTile(item: activity[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile {
  const _StatTile({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.tile});

  final _StatTile tile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = tile.trend.startsWith('+');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(tile.icon, color: tile.color),
                Text(
                  tile.trend,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: positive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(tile.value, style: theme.textTheme.titleLarge),
            Text(
              tile.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
}

class _ActivityListTile extends StatelessWidget {
  const _ActivityListTile({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          item.icon,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      trailing: Text(
        item.time,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
