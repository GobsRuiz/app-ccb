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
  List<Event> get favoriteEvents => _allEvents.where((event) => event.isFavorite).toList();
  String get selectedCity => _selectedCity;
  Set<String> get selectedEventTypes => _selectedEventTypes;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;
  double get radiusKm => _radiusKm;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  EventProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _allEvents = [
      // Batismos
      Event(
        id: '1',
        title: 'Batismo nas Águas',
        date: DateTime.now().add(const Duration(days: 2)),
        time: '15:00',
        church: 'Igreja Batista de Taquaritinga',
        address: 'Rua São Paulo, 450 - Centro',
        city: 'Taquaritinga',
        conductor: 'Pastor João Silva',
        description: 'Cerimônia de batismo nas águas com celebração especial.',
        latitude: -21.408333,
        longitude: -48.505833,
        attachments: [],
        eventType: 'Batismos',
      ),
      Event(
        id: '2',
        title: 'Batismo e Ceia',
        date: DateTime.now().add(const Duration(days: 5)),
        time: '16:00',
        church: 'Igreja Metodista Central',
        address: 'Av. Doutor Carlos Botelho, 1200',
        city: 'São Carlos',
        conductor: 'Pastora Ana Paula',
        description: 'Batismo seguido de santa ceia.',
        latitude: -22.017532,
        longitude: -47.890939,
        attachments: [],
        eventType: 'Batismos',
      ),
      Event(
        id: '3',
        title: 'Batismo Especial',
        date: DateTime.now().add(const Duration(days: 8)),
        time: '14:00',
        church: 'Igreja Presbiteriana',
        address: 'Rua Nove de Julho, 789',
        city: 'Ribeirão Preto',
        conductor: 'Pastor Roberto Lima',
        description: 'Batismo especial com momento de louvor.',
        latitude: -21.170401,
        longitude: -47.810326,
        attachments: [],
        eventType: 'Batismos',
      ),
      // Reuniões para Mocidade
      Event(
        id: '4',
        title: 'Encontro de Jovens',
        date: DateTime.now().add(const Duration(days: 3)),
        time: '19:30',
        church: 'Igreja Adventista',
        address: 'Rua Luiz de Camões, 320',
        city: 'Matão',
        conductor: 'Líder Marcos Vieira',
        description: 'Reunião especial da mocidade com louvor e palavra.',
        latitude: -21.602778,
        longitude: -48.365833,
        attachments: [],
        eventType: 'Reuniões para Mocidade',
      ),
      Event(
        id: '5',
        title: 'Célula de Jovens',
        date: DateTime.now().add(const Duration(days: 6)),
        time: '20:00',
        church: 'Igreja Batista de Taquaritinga',
        address: 'Rua São Paulo, 450 - Centro',
        city: 'Taquaritinga',
        conductor: 'Líder Júlia Santos',
        description: 'Célula semanal de jovens com estudo bíblico.',
        latitude: -21.408333,
        longitude: -48.505833,
        attachments: [],
        eventType: 'Reuniões para Mocidade',
      ),
      Event(
        id: '6',
        title: 'Mocidade em Ação',
        date: DateTime.now().add(const Duration(days: 9)),
        time: '18:30',
        church: 'Igreja Assembleia de Deus',
        address: 'Rua Conde do Pinhal, 1500',
        city: 'São Carlos',
        conductor: 'Pastor Pedro Oliveira',
        description: 'Encontro mensal da mocidade regional.',
        latitude: -22.007532,
        longitude: -47.895939,
        attachments: [],
        eventType: 'Reuniões para Mocidade',
      ),
      // Ensaios Musicais Regionais
      Event(
        id: '7',
        title: 'Ensaio Regional - Soprano',
        date: DateTime.now().add(const Duration(days: 4)),
        time: '19:00',
        church: 'Congregação Central',
        address: 'Av. Presidente Vargas, 2300',
        city: 'Ribeirão Preto',
        conductor: 'Maestro Carlos Eduardo',
        description: 'Ensaio regional do coral soprano.',
        latitude: -21.177401,
        longitude: -47.815326,
        attachments: [],
        eventType: 'Ensaios Musicais Regionais',
      ),
      Event(
        id: '8',
        title: 'Ensaio Geral da Orquestra',
        date: DateTime.now().add(const Duration(days: 7)),
        time: '15:00',
        church: 'Igreja Matriz',
        address: 'Praça da Independência, 50',
        city: 'Matão',
        conductor: 'Maestrina Maria Helena',
        description: 'Ensaio geral da orquestra regional.',
        latitude: -21.607778,
        longitude: -48.370833,
        attachments: [],
        eventType: 'Ensaios Musicais Regionais',
      ),
      Event(
        id: '9',
        title: 'Ensaio Regional - Tenor',
        date: DateTime.now().add(const Duration(days: 10)),
        time: '19:00',
        church: 'Congregação Central',
        address: 'Av. Presidente Vargas, 2300',
        city: 'Ribeirão Preto',
        conductor: 'Maestro Carlos Eduardo',
        description: 'Ensaio regional do coral tenor.',
        latitude: -21.177401,
        longitude: -47.815326,
        attachments: [],
        eventType: 'Ensaios Musicais Regionais',
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

  void toggleNotification(String eventId) {
    final index = _allEvents.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _allEvents[index] = _allEvents[index].copyWith(
        isNotifying: !_allEvents[index].isNotifying,
      );
      _applyFilters();
    }
  }

  Future<void> refreshEvents() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simula delay de rede (em produção, seria chamada à API)
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Futuramente substituir por chamada à API
      // final response = await apiService.getEvents();
      // final jsonList = response.data as List;
      // _allEvents = jsonList.map((json) => Event.fromJson(json)).toList();

      // Por ora, apenas recarrega dados mock
      _loadMockData();

      _isLoading = false;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in refreshEvents: $e');
      debugPrint('Stack trace: $stack');

      _error = 'Erro ao carregar eventos. Tente novamente.';
      _isLoading = false;
      notifyListeners();

      // Re-lança para permitir tratamento no UI se necessário
      rethrow;
    }
  }
}
