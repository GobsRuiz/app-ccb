import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/error_handler.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../services/map_service.dart';
import '../widgets/event_card.dart';
import '../widgets/event_detail_modal.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _showEventDetail(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailModal(event: event),
    );
  }

  Future<void> _navigateToEvent(BuildContext context, Event event) async {
    try {
      final url = MapService.getMapsUrl(event.latitude, event.longitude);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ErrorHandler.showToUser(context, 'Não foi possível abrir o mapa');
        }
      }
    } catch (e, stack) {
      ErrorHandler.handle(e, stack, context: 'FavoritesPage._navigateToEvent');
      if (context.mounted) {
        ErrorHandler.showToUser(context, 'Erro ao abrir o mapa');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final eventProvider = context.watch<EventProvider>();
    final favoriteEvents = eventProvider.favoriteEvents;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: theme.colors.background,
          elevation: 0,
          title: Text(
            'Favoritos',
            style: theme.typography.xl.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        if (favoriteEvents.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FIcons.star,
                    size: 64,
                    color: theme.colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Favoritos',
                    style: theme.typography.xl2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nenhum favorito adicionado',
                    style: theme.typography.sm.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = favoriteEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EventCard(
                      event: event,
                      onDetailsPressed: () => _showEventDetail(context, event),
                      onNavigatePressed: () => _navigateToEvent(context, event),
                    ),
                  );
                },
                childCount: favoriteEvents.length,
              ),
            ),
          ),
      ],
    );
  }
}
