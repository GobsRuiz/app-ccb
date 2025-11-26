import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import '../data/brazil_locations.dart';
import '../providers/event_provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late double _radius;
  DateTime? _startDate;
  DateTime? _endDate;
  final Set<String> _selectedTypes = {};
  String _selectedState = 'SP';
  String _selectedCity = 'São Paulo';

  @override
  void initState() {
    super.initState();
    final provider = context.read<EventProvider>();
    _radius = provider.radiusKm;
    _startDate = provider.startDate;
    _endDate = provider.endDate;
    _selectedTypes.addAll(provider.selectedEventTypes);

    final city = provider.selectedCity;
    for (final entry in BrazilLocations.citiesByState.entries) {
      if (entry.value.contains(city)) {
        _selectedState = entry.key;
        _selectedCity = city;
        break;
      }
    }

    _stateController = TextEditingController(text: '${BrazilLocations.states[_selectedState]} ($_selectedState)');
    _cityController = TextEditingController(text: _selectedCity);
  }

  @override
  void dispose() {
    _stateController.dispose();
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
    provider.setCity(_selectedCity);
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
      _selectedState = 'SP';
      _selectedCity = 'São Paulo';
      _radius = 10.0;
      _startDate = null;
      _endDate = null;
      _selectedTypes.clear();
    });
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
                            'Filtros',
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
                    FCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FIcons.mapPin,
                                  size: 20,
                                  color: theme.colors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Localização',
                                  style: theme.typography.base.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colors.foreground,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Estado',
                              style: theme.typography.sm.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colors.foreground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Autocomplete<String>(
                              initialValue: TextEditingValue(text: _stateController.text),
                              optionsBuilder: (textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return BrazilLocations.states.entries.map((e) => '${e.value} (${e.key})');
                                }
                                return BrazilLocations.states.entries
                                    .where((entry) =>
                                        entry.value.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                                        entry.key.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                                    .map((e) => '${e.value} (${e.key})');
                              },
                              onSelected: (String selection) {
                                final uf = selection.substring(selection.lastIndexOf('(') + 1, selection.lastIndexOf(')'));
                                setState(() {
                                  _selectedState = uf;
                                  final cities = BrazilLocations.citiesByState[uf] ?? [];
                                  _selectedCity = cities.isNotEmpty ? cities.first : '';
                                  _stateController.text = selection;
                                  _cityController.text = _selectedCity;
                                });
                              },
                              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                if (controller.text.isEmpty && _stateController.text.isNotEmpty) {
                                  controller.text = _stateController.text;
                                }
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Buscar estado...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                );
                              },
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
                            Autocomplete<String>(
                              key: ValueKey(_selectedState),
                              initialValue: TextEditingValue(text: _selectedCity),
                              optionsBuilder: (textEditingValue) {
                                final cities = BrazilLocations.citiesByState[_selectedState] ?? [];
                                if (textEditingValue.text.isEmpty) {
                                  return cities;
                                }
                                return cities.where((city) =>
                                    city.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String selection) {
                                setState(() {
                                  _selectedCity = selection;
                                  _cityController.text = selection;
                                });
                              },
                              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Buscar cidade...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                );
                              },
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FIcons.calendar,
                                  size: 20,
                                  color: theme.colors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Período',
                                  style: theme.typography.base.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colors.foreground,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FIcons.tag,
                                  size: 20,
                                  color: theme.colors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tipos de Evento',
                                  style: theme.typography.base.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colors.foreground,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: BrazilLocations.eventTypes.map((type) {
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colors.background,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.border,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
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
        );
      },
    );
  }
}
