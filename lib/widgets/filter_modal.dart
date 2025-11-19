import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late TextEditingController _searchController;
  late TextEditingController _cityController;
  late double _radius;
  DateTime? _startDate;
  DateTime? _endDate;
  final Set<String> _selectedTypes = {};

  final List<String> _eventTypes = [
    'Culto',
    'Estudo',
    'Vigília',
    'Conferência',
    'Reunião',
    'Evento Especial',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<EventProvider>();
    _searchController = TextEditingController(text: provider.searchQuery);
    _cityController = TextEditingController(text: provider.selectedCity);
    _radius = provider.radiusKm;
    _startDate = provider.startDate;
    _endDate = provider.endDate;
    _selectedTypes.addAll(provider.selectedEventTypes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _applyFilters() {
    final provider = context.read<EventProvider>();
    provider.setSearchQuery(_searchController.text);
    provider.setCity(_cityController.text);
    provider.setRadius(_radius);
    provider.setDateRange(_startDate, _endDate);

    for (final type in _selectedTypes) {
      if (!provider.selectedEventTypes.contains(type)) {
        provider.toggleEventType(type);
      }
    }

    for (final type in provider.selectedEventTypes.toList()) {
      if (!_selectedTypes.contains(type)) {
        provider.toggleEventType(type);
      }
    }

    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _cityController.text = 'São Paulo';
      _radius = 10.0;
      _startDate = null;
      _endDate = null;
      _selectedTypes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: theme.typography.xl2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colors.foreground,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(FIcons.x),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Busca',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FTextField(
                      controller: _searchController,
                      hint: 'Buscar eventos...',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cidade',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FTextField(
                      controller: _cityController,
                      hint: 'Digite a cidade',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Raio: ${_radius.toStringAsFixed(1)} km',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _radius,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      onChanged: (value) {
                        setState(() {
                          _radius = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Período',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FButton(
                            onPress: () => _selectDate(context, true),
                            style: FButtonStyle.outline(),
                            child: Text(
                              _startDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}'
                                  : 'Data inicial',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FButton(
                            onPress: () => _selectDate(context, false),
                            style: FButtonStyle.outline(),
                            child: Text(
                              _endDate != null
                                  ? '${_endDate!.day}/${_endDate!.month}'
                                  : 'Data final',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tipos de Evento',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _eventTypes.map((type) {
                        final isSelected = _selectedTypes.contains(type);
                        return FButton(
                          onPress: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTypes.remove(type);
                              } else {
                                _selectedTypes.add(type);
                              }
                            });
                          },
                          style: isSelected
                              ? FButtonStyle.primary()
                              : FButtonStyle.outline(),
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: FButton(
                      onPress: _clearFilters,
                      style: FButtonStyle.outline(),
                      child: const Text('Limpar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: _applyFilters,
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
