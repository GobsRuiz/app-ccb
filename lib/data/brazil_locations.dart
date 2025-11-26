/// Dados de localização do Brasil (estados e cidades)
/// Futuramente pode ser substituído por dados de API
class BrazilLocations {
  /// Lista de tipos de eventos disponíveis
  static const eventTypes = [
    'Batismos',
    'Reuniões para Mocidade',
    'Ensaios Musicais Regionais',
  ];

  /// Mapa de estados brasileiros (sigla => nome completo)
  static const states = {
    'AC': 'Acre',
    'AL': 'Alagoas',
    'AP': 'Amapá',
    'AM': 'Amazonas',
    'BA': 'Bahia',
    'CE': 'Ceará',
    'DF': 'Distrito Federal',
    'ES': 'Espírito Santo',
    'GO': 'Goiás',
    'MA': 'Maranhão',
    'MT': 'Mato Grosso',
    'MS': 'Mato Grosso do Sul',
    'MG': 'Minas Gerais',
    'PA': 'Pará',
    'PB': 'Paraíba',
    'PR': 'Paraná',
    'PE': 'Pernambuco',
    'PI': 'Piauí',
    'RJ': 'Rio de Janeiro',
    'RN': 'Rio Grande do Norte',
    'RS': 'Rio Grande do Sul',
    'RO': 'Rondônia',
    'RR': 'Roraima',
    'SC': 'Santa Catarina',
    'SP': 'São Paulo',
    'SE': 'Sergipe',
    'TO': 'Tocantins',
  };

  /// Mapa de cidades por estado (sigla do estado => lista de cidades)
  static const citiesByState = {
    'AC': ['Rio Branco'],
    'AL': ['Maceió'],
    'AP': ['Macapá'],
    'AM': ['Manaus'],
    'BA': ['Salvador'],
    'CE': ['Fortaleza'],
    'DF': ['Brasília'],
    'ES': ['Vitória'],
    'GO': ['Goiânia'],
    'MA': ['São Luís'],
    'MT': ['Cuiabá'],
    'MS': ['Campo Grande'],
    'MG': ['Belo Horizonte'],
    'PA': ['Belém'],
    'PB': ['João Pessoa'],
    'PR': ['Curitiba'],
    'PE': ['Recife'],
    'PI': ['Teresina'],
    'RJ': ['Rio de Janeiro'],
    'RN': ['Natal'],
    'RS': ['Porto Alegre'],
    'RO': ['Porto Velho'],
    'RR': ['Boa Vista'],
    'SC': ['Florianópolis'],
    'SP': [
      'São Paulo',
      'Ribeirão Preto',
      'São Carlos',
      'Taquaritinga',
      'Matão',
      'Catanduva',
      'Guariroba',
      'Guariba',
      'São José do Rio Preto',
      'Araraquara',
      'Barretos',
    ],
    'SE': ['Aracaju'],
    'TO': ['Palmas'],
  };
}
