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
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      church: json['church'] as String,
      address: json['address'] as String,
      conductor: json['conductor'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      eventType: json['eventType'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
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
