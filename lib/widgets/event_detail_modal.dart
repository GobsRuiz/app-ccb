import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class EventDetailModal extends StatelessWidget {
  final Event event;

  const EventDetailModal({
    super.key,
    required this.event,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _openMap() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
                            event.title,
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
                              return FButton(
                                onPress: () {
                                  provider.toggleFavorite(event.id);
                                },
                                style: event.isFavorite
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
                                        event.isFavorite ? 'Favoritado' : 'Favoritar',
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
                          child: FButton(
                            onPress: () {
                              final overlay = Overlay.of(context);
                              final overlayEntry = OverlayEntry(
                                builder: (context) => Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF323232),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Você será notificado sobre este evento',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              overlay.insert(overlayEntry);

                              // Remove após 2 segundos
                              Future.delayed(const Duration(seconds: 2), () {
                                overlayEntry.remove();
                              });
                            },
                            style: FButtonStyle.outline(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(FIcons.bell, size: 14),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Notificar',
                                    style: TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      icon: FIcons.calendar,
                      title: 'Data e Hora',
                      content: '${_formatDate(event.date)} às ${event.time}',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.mapPin,
                      title: 'Local',
                      content: '${event.church}\n${event.address}',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.user,
                      title: 'Regente',
                      content: event.conductor,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      icon: FIcons.fileText,
                      title: 'Descrição',
                      content: event.description,
                    ),
                    if (event.attachments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        icon: FIcons.paperclip,
                        title: 'Anexos',
                        content: '${event.attachments.length} arquivo(s) anexado(s)',
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
