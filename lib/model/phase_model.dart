class PhaseReading {
  final String status;
  final double totalRunningTime;
  final double totalNotRunningTime;
  final String lastStatusChange;
  final String timestamp;

  PhaseReading({
    required this.status,
    required this.totalRunningTime,
    required this.totalNotRunningTime,
    required this.lastStatusChange,
    required this.timestamp,
  });

  factory PhaseReading.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null || json.isEmpty) {
      print('Warning: Null or empty JSON provided for PhaseReading');
      return PhaseReading(
        status: 'Unknown Status',
        totalRunningTime: 0.0,
        totalNotRunningTime: 0.0,
        lastStatusChange: 'No date',
        timestamp: 'No timestamp',
      );
    }

    print('Parsing reading with data: $json'); // Debug print

    return PhaseReading(
      status: json['Status']?.toString() ?? 'Unknown Status',
      totalRunningTime: _parseDouble(json['TotalRunningTime']),
      totalNotRunningTime: _parseDouble(json['TotalNotRunningTime']),
      lastStatusChange: json['LastStatusChange']?.toString() ?? 'No date',
      timestamp: json['Timestamp']?.toString() ?? 'No timestamp',
    );
  }

  static double _parseDouble(dynamic value) {
    print(
        'Parsing double value: $value (type: ${value.runtimeType})'); // Debug print
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    return 0.0;
  }

  bool get isRunning =>
      status.toLowerCase().contains('running') &&
      !status.toLowerCase().contains('not running');

  @override
  String toString() {
    return 'PhaseReading(status: $status, totalRunningTime: $totalRunningTime, totalNotRunningTime: $totalNotRunningTime, lastStatusChange: $lastStatusChange, timestamp: $timestamp)';
  }
}

class PhaseData {
  final Map<String, PhaseReading> readings;

  PhaseData({required this.readings});

  factory PhaseData.fromJson(Map<dynamic, dynamic>? json) {
    print('Received json for PhaseData: $json'); // Debug print

    if (json == null || json.isEmpty) {
      print('Warning: Null or empty JSON provided for PhaseData');
      return PhaseData(readings: {});
    }

    final Map<String, PhaseReading> readingsMap = {};

    final statusMap = json['Status'] as Map<dynamic, dynamic>?;
    if (statusMap == null) {
      print('Warning: Missing "Status" key in JSON');
      return PhaseData(readings: {});
    }

    statusMap.forEach((key, value) {
      print('Processing key: $key with value: $value'); // Debug print
      if (value is Map<dynamic, dynamic>) {
        try {
          final reading = PhaseReading.fromJson(value);
          readingsMap[key.toString()] = reading;
          print('Successfully parsed reading for key $key: $reading');
        } catch (e) {
          print('Error parsing PhaseReading for key $key: $e');
        }
      } else {
        print('Warning: Value for key $key is not a Map: ${value.runtimeType}');
      }
    });

    print('Final readings map size: ${readingsMap.length}');
    return PhaseData(readings: readingsMap);
  }

  List<PhaseReading> getRunningEquipment() {
    return readings.values.where((reading) => reading.isRunning).toList();
  }

  List<PhaseReading> getStoppedEquipment() {
    return readings.values.where((reading) => !reading.isRunning).toList();
  }

  @override
  String toString() {
    return 'PhaseData(readings: ${readings.length} items)';
  }
}
