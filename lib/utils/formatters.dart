import 'package:intl/intl.dart';

/// Classe utilitária para formatação de dados
/// Centraliza todas as formatações usadas no app
class Formatters {
  /// Formata uma data no padrão brasileiro (dd/MM/yyyy)
  ///
  /// Exemplo:
  /// ```dart
  /// final date = DateTime(2025, 11, 19);
  /// print(Formatters.formatDate(date)); // "19/11/2025"
  /// ```
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formata uma data no padrão estendido (ex: "19 de novembro de 2025")
  ///
  /// Útil para exibições mais descritivas
  static String formatDateExtended(DateTime date) {
    return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(date);
  }

  /// Formata uma data e hora no padrão brasileiro (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
