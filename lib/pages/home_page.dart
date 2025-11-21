import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/error_handler.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../providers/connectivity_provider.dart';
import '../services/map_service.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_modal.dart';
import '../widgets/event_detail_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _quickFilters = [
    'Todos',
    'Culto',
    'Estudo',
    'Vigília',
    'Conferência',
  ];

  String _selectedQuickFilter = 'Todos';

  // initState removido - não precisa mais chamar refreshEvents()
  // Os dados já são carregados no construtor do EventProvider

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) => const FilterModal(),
    );
  }

  void _showEventDetail(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailModal(event: event),
    );
  }

  Future<void> _navigateToEvent(Event event) async {
    try {
      final url = MapService.getMapsUrl(event.latitude, event.longitude);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ErrorHandler.showToUser(context, 'Não foi possível abrir o mapa');
        }
      }
    } catch (e, stack) {
      ErrorHandler.handle(e, stack, context: 'HomePage._navigateToEvent');
      if (mounted) {
        ErrorHandler.showToUser(context, 'Erro ao abrir o mapa');
      }
    }
  }

  void _onQuickFilterTap(String filter) {
    setState(() {
      _selectedQuickFilter = filter;
    });

    final provider = context.read<EventProvider>();

    if (filter == 'Todos') {
      provider.clearFilters();
    } else {
      provider.clearFilters();
      provider.toggleEventType(filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final eventProvider = context.watch<EventProvider>();
    final connectivityProvider = context.watch<ConnectivityProvider>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: theme.colors.background,
          elevation: 0,
          title: Row(
            children: [
              FBadge(
                style: FBadgeStyle.outline(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FIcons.mapPin,
                      size: 14,
                      color: theme.colors.foreground,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      eventProvider.selectedCity,
                      style: theme.typography.sm.copyWith(
                        color: theme.colors.foreground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FBadge(
                style: FBadgeStyle.outline(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      connectivityProvider.isOnline
                          ? FIcons.wifi
                          : FIcons.wifiOff,
                      size: 12,
                      color: connectivityProvider.isOnline
                          ? theme.colors.primary
                          : theme.colors.mutedForeground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      connectivityProvider.isOnline ? 'Online' : 'Cache',
                      style: theme.typography.xs.copyWith(
                        color: theme.colors.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(FIcons.slidersHorizontal),
              onPressed: _showFilterModal,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickFilters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _quickFilters[index];
                final isSelected = _selectedQuickFilter == filter;

                return FButton(
                  onPress: () => _onQuickFilterTap(filter),
                  style: isSelected
                      ? FButtonStyle.primary()
                      : FButtonStyle.outline(),
                  child: Text(filter),
                );
              },
            ),
          ),
        ),
        if (eventProvider.isLoading)
          SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: theme.colors.primary,
              ),
            ),
          )
        else if (eventProvider.events.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FIcons.calendar,
                    size: 64,
                    color: theme.colors.mutedForeground,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum evento encontrado',
                    style: theme.typography.base.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FButton(
                    onPress: () {
                      context.read<EventProvider>().clearFilters();
                      setState(() {
                        _selectedQuickFilter = 'Todos';
                      });
                    },
                    style: FButtonStyle.outline(),
                    child: const Text('Limpar Filtros'),
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
                  final event = eventProvider.events[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EventCard(
                      event: event,
                      onDetailsPressed: () => _showEventDetail(event),
                      onNavigatePressed: () => _navigateToEvent(event),
                    ),
                  );
                },
                childCount: eventProvider.events.length,
              ),
            ),
          ),
      ],
    );
  }
}
