import 'package:flutter/foundation.dart';
import '../models/event.dart';

class EventProvider with ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  String _selectedCity = 'São Paulo';
  final Set<String> _selectedEventTypes = {};
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';
  double _radiusKm = 10.0;

  List<Event> get events => _filteredEvents;
  String get selectedCity => _selectedCity;
  Set<String> get selectedEventTypes => _selectedEventTypes;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;
  double get radiusKm => _radiusKm;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EventProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _allEvents = [
      Event(
        id: '1',
        title: 'Culto de Louvor e Adoração',
        date: DateTime.now().add(const Duration(days: 2)),
        time: '19:00',
        church: 'Igreja Batista Central',
        address: 'Rua das Flores, 123 - Centro',
        conductor: 'Pastor João Silva',
        description: 'Culto especial de louvor e adoração com ministração da palavra.',
        latitude: -23.550520,
        longitude: -46.633308,
        attachments: [],
        eventType: 'Culto',
      ),
      Event(
        id: '2',
        title: 'Estudo Bíblico',
        date: DateTime.now().add(const Duration(days: 5)),
        time: '20:00',
        church: 'Igreja Presbiteriana do Brasil',
        address: 'Av. Paulista, 456',
        conductor: 'Pastor Maria Santos',
        description: 'Estudo aprofundado do livro de Romanos.',
        latitude: -23.561684,
        longitude: -46.655981,
        attachments: [],
        eventType: 'Estudo',
      ),
      Event(
        id: '3',
        title: 'Vigília de Oração',
        date: DateTime.now().add(const Duration(days: 7)),
        time: '22:00',
        church: 'Assembleia de Deus',
        address: 'Rua dos Apóstolos, 789',
        conductor: 'Pastor Pedro Oliveira',
        description: 'Noite de oração e intercessão pela cidade.',
        latitude: -23.533773,
        longitude: -46.625290,
        attachments: [],
        eventType: 'Vigília',
      ),
      Event(
        id: '4',
        title: 'Conferência de Jovens',
        date: DateTime.now().add(const Duration(days: 10)),
        time: '18:00',
        church: 'Igreja Metodista',
        address: 'Praça da Sé, 100',
        conductor: 'Pastor Lucas Ferreira',
        description: 'Conferência especial para jovens com louvores e pregações.',
        latitude: -23.550385,
        longitude: -46.634290,
        attachments: [],
        eventType: 'Conferência',
      ),
    ];

    _filteredEvents = List.from(_allEvents);
    notifyListeners();
  }

  void setCity(String city) {
    _selectedCity = city;
    _applyFilters();
  }

  void toggleEventType(String eventType) {
    if (_selectedEventTypes.contains(eventType)) {
      _selectedEventTypes.remove(eventType);
    } else {
      _selectedEventTypes.add(eventType);
    }
    _applyFilters();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setRadius(double radius) {
    _radiusKm = radius;
    _applyFilters();
  }

  void clearFilters() {
    _selectedEventTypes.clear();
    _startDate = null;
    _endDate = null;
    _searchQuery = '';
    _radiusKm = 10.0;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredEvents = _allEvents.where((event) {
      bool matchesType = _selectedEventTypes.isEmpty ||
          _selectedEventTypes.contains(event.eventType);

      bool matchesDate = true;
      if (_startDate != null) {
        matchesDate = event.date.isAfter(_startDate!.subtract(const Duration(days: 1)));
      }
      if (_endDate != null && matchesDate) {
        matchesDate = event.date.isBefore(_endDate!.add(const Duration(days: 1)));
      }

      bool matchesSearch = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.church.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.conductor.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesType && matchesDate && matchesSearch;
    }).toList();

    notifyListeners();
  }

  void toggleFavorite(String eventId) {
    final index = _allEvents.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _allEvents[index] = _allEvents[index].copyWith(
        isFavorite: !_allEvents[index].isFavorite,
      );
      _applyFilters();
    }
  }

  Future<void> refreshEvents() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _loadMockData();

    _isLoading = false;
    notifyListeners();
  }
}
