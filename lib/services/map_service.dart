/// Serviço para geração de URLs de aplicativos de mapas
/// Centraliza a lógica de navegação para diferentes provedores de mapas
class MapService {
  /// Gera URL do Google Maps para navegação
  ///
  /// [latitude] - Latitude do destino
  /// [longitude] - Longitude do destino
  ///
  /// Retorna uma URL que abre o Google Maps com o ponto marcado
  static Uri getGoogleMapsUrl(double latitude, double longitude) {
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
  }

  /// Gera URL do Waze para navegação
  ///
  /// [latitude] - Latitude do destino
  /// [longitude] - Longitude do destino
  ///
  /// Retorna uma URL que abre o Waze com navegação para o ponto
  static Uri getWazeUrl(double latitude, double longitude) {
    return Uri.parse(
      'https://www.waze.com/ul?ll=$latitude,$longitude&navigate=yes',
    );
  }

  /// Gera URL do Apple Maps para navegação
  ///
  /// [latitude] - Latitude do destino
  /// [longitude] - Longitude do destino
  ///
  /// Retorna uma URL que abre o Apple Maps (útil para iOS)
  static Uri getAppleMapsUrl(double latitude, double longitude) {
    return Uri.parse(
      'https://maps.apple.com/?daddr=$latitude,$longitude',
    );
  }

  /// Método principal para obter URL de mapas
  ///
  /// Por padrão usa Google Maps, mas pode ser configurado
  /// futuramente para permitir escolha do usuário
  static Uri getMapsUrl(double latitude, double longitude) {
    // TODO: Futuramente pode ler de Settings qual app de mapas usar
    return getGoogleMapsUrl(latitude, longitude);
  }
}
