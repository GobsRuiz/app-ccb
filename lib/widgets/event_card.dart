import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../models/event.dart';
import '../utils/formatters.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onDetailsPressed;
  final VoidCallback onNavigatePressed;

  const EventCard({
    super.key,
    required this.event,
    required this.onDetailsPressed,
    required this.onNavigatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colors.foreground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FBadge(
                  child: Text(event.eventType),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  FIcons.calendar,
                  size: 16,
                  color: theme.colors.mutedForeground,
                ),
                const SizedBox(width: 6),
                Text(
                  '${Formatters.formatDate(event.date)} às ${event.time}',
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  FIcons.mapPin,
                  size: 16,
                  color: theme.colors.mutedForeground,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${event.church} - ${event.address} - ${event.city}',
                    style: theme.typography.sm.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  FIcons.user,
                  size: 16,
                  color: theme.colors.mutedForeground,
                ),
                const SizedBox(width: 6),
                Text(
                  event.conductor,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FButton(
                    onPress: onDetailsPressed,
                    style: FButtonStyle.outline(),
                    child: const Text('Detalhes'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FButton(
                    onPress: onNavigatePressed,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(FIcons.navigation, size: 16),
                        SizedBox(width: 6),
                        Text('Ir'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
