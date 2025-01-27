// Energy reading model for individual entries
class EnergyReading {
  final String timestamp;
  final int timestampServer;
  final List<String> energyData;

  EnergyReading({
    required this.timestamp,
    required this.timestampServer,
    required this.energyData,
  });

  factory EnergyReading.fromJson(Map<String, dynamic> json) {
    return EnergyReading(
      timestamp: json['timestamp'] as String,
      timestampServer: json['timestampServer'] as int,
      energyData: List<String>.from(json['energyData'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'timestampServer': timestampServer,
        'energyData': energyData,
      };
}

// Main model for all energy data categories
class EnergyData {
  final Map<String, EnergyReading> generation;
  final Map<String, EnergyReading> kakulaMAndI;
  final Map<String, EnergyReading> kansokoMAndI;
  final Map<String, EnergyReading> kmcsLineFeeders;
  final Map<String, EnergyReading> kakulaKCS;

  EnergyData({
    required this.generation,
    required this.kakulaMAndI,
    required this.kansokoMAndI,
    required this.kmcsLineFeeders,
    required this.kakulaKCS,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      generation: _parseReadings(json['generation'] as Map<dynamic, dynamic>),
      kakulaMAndI: _parseReadings(json['kakulaM&I'] as Map<dynamic, dynamic>),
      kansokoMAndI: _parseReadings(json['kansokoM&I'] as Map<dynamic, dynamic>),
      kmcsLineFeeders: _parseReadings(json['kmcsLineFeeders'] as Map<dynamic, dynamic>),
      kakulaKCS: _parseReadings(json['kakulaKCS'] as Map<dynamic, dynamic>),
    );
  }

  static Map<String, EnergyReading> _parseReadings(Map<dynamic, dynamic> data) {
    final Map<String, EnergyReading> readings = {};
    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        readings[key.toString()] = EnergyReading.fromJson(Map<String, dynamic>.from(value));
      }
    });
    return readings;
  }

  Map<String, dynamic> toJson() => {
        'generation': generation,
        'kakulaM&I': kakulaMAndI,
        'kansokoM&I': kansokoMAndI,
        'kmcsLineFeeders': kmcsLineFeeders,
        'kakulaKCS': kakulaKCS,
      };
}