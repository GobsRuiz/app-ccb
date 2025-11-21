class Event {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String church;
  final String address;
  final String conductor;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> attachments;
  final String eventType;
  final bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.church,
    required this.address,
    required this.conductor,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.attachments = const [],
    required this.eventType,
    this.isFavorite = false,
  });

  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? time,
    String? church,
    String? address,
    String? conductor,
    String? description,
    double? latitude,
    double? longitude,
    List<String>? attachments,
    String? eventType,
    bool? isFavorite,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      church: church ?? this.church,
      address: address ?? this.address,
      conductor: conductor ?? this.conductor,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      attachments: attachments ?? this.attachments,
      eventType: eventType ?? this.eventType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      if (json['id'] == null || json['id'].toString().isEmpty) {
        throw FormatException('Event.id is required and cannot be empty');
      }
      if (json['title'] == null || json['title'].toString().isEmpty) {
        throw FormatException('Event.title is required and cannot be empty');
      }
      if (json['date'] == null) {
        throw FormatException('Event.date is required');
      }
      if (json['time'] == null || json['time'].toString().isEmpty) {
        throw FormatException('Event.time is required and cannot be empty');
      }
      if (json['church'] == null || json['church'].toString().isEmpty) {
        throw FormatException('Event.church is required and cannot be empty');
      }
      if (json['address'] == null || json['address'].toString().isEmpty) {
        throw FormatException('Event.address is required and cannot be empty');
      }
      if (json['conductor'] == null || json['conductor'].toString().isEmpty) {
        throw FormatException('Event.conductor is required and cannot be empty');
      }
      if (json['description'] == null || json['description'].toString().isEmpty) {
        throw FormatException('Event.description is required and cannot be empty');
      }
      if (json['latitude'] == null) {
        throw FormatException('Event.latitude is required');
      }
      if (json['longitude'] == null) {
        throw FormatException('Event.longitude is required');
      }
      if (json['eventType'] == null || json['eventType'].toString().isEmpty) {
        throw FormatException('Event.eventType is required and cannot be empty');
      }

      // Validação de formato de data
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(json['date'] as String);
      } catch (e) {
        throw FormatException('Event.date has invalid format: ${json['date']}. Expected ISO 8601 format.');
      }

      // Validação de coordenadas
      final lat = (json['latitude'] as num).toDouble();
      final lon = (json['longitude'] as num).toDouble();

      if (lat < -90 || lat > 90) {
        throw FormatException('Event.latitude must be between -90 and 90, got: $lat');
      }
      if (lon < -180 || lon > 180) {
        throw FormatException('Event.longitude must be between -180 and 180, got: $lon');
      }

      return Event(
        id: json['id'] as String,
        title: json['title'] as String,
        date: parsedDate,
        time: json['time'] as String,
        church: json['church'] as String,
        address: json['address'] as String,
        conductor: json['conductor'] as String,
        description: json['description'] as String,
        latitude: lat,
        longitude: lon,
        attachments: (json['attachments'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        eventType: json['eventType'] as String,
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
    } catch (e) {
      // Re-lança o erro com contexto adicional para facilitar debug
      throw FormatException(
        'Failed to parse Event from JSON: $e\nJSON: $json',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'church': church,
      'address': address,
      'conductor': conductor,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'attachments': attachments,
      'eventType': eventType,
      'isFavorite': isFavorite,
    };
  }
}
