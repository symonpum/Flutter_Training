class Address {
  final String id;
  final String line1;
  final String city;
  final String region;
  final String postalCode;
  final double lat;
  final double lng;

  Address({
    required this.id,
    required this.line1,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.lat,
    required this.lng,
  });

  factory Address.fromMap(Map<String, dynamic> m) => Address(
    id: (m['id'] ?? '').toString(),
    line1: m['line1'] ?? '',
    city: m['city'] ?? '',
    region: m['region'] ?? '',
    postalCode: m['postalCode'] ?? '',
    lat: (m['lat'] is num) ? (m['lat'] as num).toDouble() : 0.0,
    lng: (m['lng'] is num) ? (m['lng'] as num).toDouble() : 0.0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'line1': line1,
    'city': city,
    'region': region,
    'postalCode': postalCode,
    'lat': lat,
    'lng': lng,
  };

  // ==================== ADDED THIS METHOD ====================
  /// Creates a copy of the address with updated fields.
  Address copyWith({
    String? id,
    String? line1,
    String? city,
    String? region,
    String? postalCode,
    double? lat,
    double? lng,
  }) {
    return Address(
      id: id ?? this.id,
      line1: line1 ?? this.line1,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  // ==========================================================
}
