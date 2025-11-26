import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/error_handler.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../services/map_service.dart';
import '../services/toast_service.dart';
import '../utils/formatters.dart';

class EventDetailModal extends StatefulWidget {
  final Event event;

  const EventDetailModal({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailModal> createState() => _EventDetailModalState();
}

class _EventDetailModalState extends State<EventDetailModal> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openMap() async {
    try {
      final url = MapService.getMapsUrl(widget.event.latitude, widget.event.longitude);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ErrorHandler.showToUser(context, 'Não foi possível abrir o mapa');
        }
      }
    } catch (e, stack) {
      ErrorHandler.handle(e, stack, context: 'EventDetailModal._openMap');
      if (mounted) {
        ErrorHandler.showToUser(context, 'Erro ao abrir o mapa');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.border,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.event.title,
                            style: theme.typography.xl2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colors.foreground,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(FIcons.x),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: FButton(
                            onPress: _openMap,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(FIcons.mapPin, size: 14),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Mapa',
                                    style: TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Consumer<EventProvider>(
                            builder: (context, provider, child) {
                              final currentEvent = provider.events.firstWhere(
                                (e) => e.id == widget.event.id,
                                orElse: () => widget.event,
                              );
                              final isFavorite = currentEvent.isFavorite;

                              return FButton(
                                onPress: () {
                                  provider.toggleFavorite(widget.event.id);
                                },
                                style: isFavorite
                                    ? FButtonStyle.primary()
                                    : FButtonStyle.outline(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FIcons.star, size: 14),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        isFavorite ? 'Favoritado' : 'Favoritar',
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Consumer<EventProvider>(
                            builder: (context, provider, child) {
                              final currentEvent = provider.events.firstWhere(
                                (e) => e.id == widget.event.id,
                                orElse: () => widget.event,
                              );
                              final isNotifying = currentEvent.isNotifying;

                              return FButton(
                                onPress: () {
                                  provider.toggleNotification(widget.event.id);
                                  // Mostra toast apenas quando ativar notificação
                                  if (!isNotifying) {
                                    ToastService.showInfo(
                                      context,
                                      'Você será notificado sobre este evento',
                                    );
                                  }
                                },
                                style: isNotifying
                                    ? FButtonStyle.primary()
                                    : FButtonStyle.outline(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FIcons.bell, size: 14),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        isNotifying ? 'Notificando' : 'Notificar',
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      icon: FIcons.calendar,
                      title: 'Data e Hora',
                      content: '${Formatters.formatDate(widget.event.date)} às ${widget.event.time}',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.mapPin,
                      title: 'Local',
                      content: '${widget.event.church}\n${widget.event.address}\n${widget.event.city}',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.user,
                      title: 'Regente',
                      content: widget.event.conductor,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.fileText,
                      title: 'Descrição',
                      content: widget.event.description,
                    ),
                    if (widget.event.attachments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        icon: FIcons.paperclip,
                        title: 'Anexos',
                        content: '${widget.event.attachments.length} arquivo(s) anexado(s)',
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = context.theme;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: theme.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
