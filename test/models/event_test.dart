import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/event.dart';

void main() {
  group('Event.fromJson', () {
    test('should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial de louvor e adoração',
        'latitude': -23.550520,
        'longitude': -46.633308,
        'attachments': ['file1.pdf', 'file2.pdf'],
        'eventType': 'Culto',
        'isFavorite': true,
        'isNotifying': true,
      };

      // Act
      final event = Event.fromJson(json);

      // Assert
      expect(event.id, '1');
      expect(event.title, 'Culto de Louvor');
      expect(event.date, DateTime.parse('2025-11-25T19:00:00.000Z'));
      expect(event.time, '19:00');
      expect(event.church, 'Igreja Batista Central');
      expect(event.address, 'Rua das Flores, 123');
      expect(event.city, 'São Paulo');
      expect(event.conductor, 'Pastor João Silva');
      expect(event.description, 'Culto especial de louvor e adoração');
      expect(event.latitude, -23.550520);
      expect(event.longitude, -46.633308);
      expect(event.attachments, ['file1.pdf', 'file2.pdf']);
      expect(event.eventType, 'Culto');
      expect(event.isFavorite, true);
      expect(event.isNotifying, true);
    });

    test('should parse JSON with optional fields as null', () {
      // Arrange
      final json = {
        'id': '2',
        'title': 'Estudo Bíblico',
        'date': '2025-11-26T20:00:00.000Z',
        'time': '20:00',
        'church': 'Igreja Presbiteriana',
        'address': 'Av. Paulista, 456',
        'city': 'São Paulo',
        'conductor': 'Pastor Maria Santos',
        'description': 'Estudo do livro de Romanos',
        'latitude': -23.561684,
        'longitude': -46.655981,
        'eventType': 'Estudo',
        // attachments, isFavorite e isNotifying omitidos (opcionais)
      };

      // Act
      final event = Event.fromJson(json);

      // Assert
      expect(event.attachments, isEmpty);
      expect(event.isFavorite, false);
      expect(event.isNotifying, false);
    });

    test('should throw FormatException when id is null', () {
      // Arrange
      final json = {
        // 'id': null, // id ausente
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -23.550520,
        'longitude': -46.633308,
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when title is empty', () {
      // Arrange
      final json = {
        'id': '1',
        'title': '', // Título vazio
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -23.550520,
        'longitude': -46.633308,
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when date format is invalid', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': 'invalid-date-format', // Formato inválido
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -23.550520,
        'longitude': -46.633308,
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when latitude is out of range', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': 95.0, // Fora do range válido (-90 a 90)
        'longitude': -46.633308,
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when longitude is out of range', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -23.550520,
        'longitude': 185.0, // Fora do range válido (-180 a 180)
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when required field is missing', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        // 'address': 'Rua das Flores, 123', // Campo obrigatório ausente
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -23.550520,
        'longitude': -46.633308,
        'eventType': 'Culto',
      };

      // Act & Assert
      expect(
        () => Event.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should accept latitude and longitude at valid boundaries', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': 90.0, // Máximo válido
        'longitude': 180.0, // Máximo válido
        'eventType': 'Culto',
      };

      // Act
      final event = Event.fromJson(json);

      // Assert
      expect(event.latitude, 90.0);
      expect(event.longitude, 180.0);
    });

    test('should accept negative latitude and longitude', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Culto de Louvor',
        'date': '2025-11-25T19:00:00.000Z',
        'time': '19:00',
        'church': 'Igreja Batista Central',
        'address': 'Rua das Flores, 123',
        'city': 'São Paulo',
        'conductor': 'Pastor João Silva',
        'description': 'Culto especial',
        'latitude': -90.0, // Mínimo válido
        'longitude': -180.0, // Mínimo válido
        'eventType': 'Culto',
      };

      // Act
      final event = Event.fromJson(json);

      // Assert
      expect(event.latitude, -90.0);
      expect(event.longitude, -180.0);
    });
  });

  group('Event.toJson', () {
    test('should convert Event to JSON correctly', () {
      // Arrange
      final event = Event(
        id: '1',
        title: 'Culto de Louvor',
        date: DateTime.parse('2025-11-25T19:00:00.000Z'),
        time: '19:00',
        church: 'Igreja Batista Central',
        address: 'Rua das Flores, 123',
        city: 'São Paulo',
        conductor: 'Pastor João Silva',
        description: 'Culto especial',
        latitude: -23.550520,
        longitude: -46.633308,
        attachments: ['file1.pdf'],
        eventType: 'Culto',
        isFavorite: true,
        isNotifying: true,
      );

      // Act
      final json = event.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Culto de Louvor');
      expect(json['date'], '2025-11-25T19:00:00.000Z');
      expect(json['time'], '19:00');
      expect(json['church'], 'Igreja Batista Central');
      expect(json['address'], 'Rua das Flores, 123');
      expect(json['city'], 'São Paulo');
      expect(json['conductor'], 'Pastor João Silva');
      expect(json['description'], 'Culto especial');
      expect(json['latitude'], -23.550520);
      expect(json['longitude'], -46.633308);
      expect(json['attachments'], ['file1.pdf']);
      expect(json['eventType'], 'Culto');
      expect(json['isFavorite'], true);
      expect(json['isNotifying'], true);
    });
  });

  group('Event.copyWith', () {
    test('should create a copy with updated fields', () {
      // Arrange
      final original = Event(
        id: '1',
        title: 'Culto de Louvor',
        date: DateTime.parse('2025-11-25T19:00:00.000Z'),
        time: '19:00',
        church: 'Igreja Batista Central',
        address: 'Rua das Flores, 123',
        city: 'São Paulo',
        conductor: 'Pastor João Silva',
        description: 'Culto especial',
        latitude: -23.550520,
        longitude: -46.633308,
        eventType: 'Culto',
        isFavorite: false,
        isNotifying: false,
      );

      // Act
      final updated = original.copyWith(
        title: 'Culto de Celebração',
        isFavorite: true,
        isNotifying: true,
      );

      // Assert
      expect(updated.id, original.id); // Não alterado
      expect(updated.title, 'Culto de Celebração'); // Alterado
      expect(updated.isFavorite, true); // Alterado
      expect(updated.isNotifying, true); // Alterado
      expect(updated.church, original.church); // Não alterado
    });
  });
}
