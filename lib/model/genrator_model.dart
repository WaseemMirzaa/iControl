class GeneratorReading {
  final String timestamp;
  final int timestampServer;
  final List<String> generators;

  GeneratorReading({
    required this.timestamp,
    required this.timestampServer,
    required this.generators,
  });

  factory GeneratorReading.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException('Null JSON provided for GeneratorReading');
    }

    return GeneratorReading(
      timestamp: json['timestamp'] as String? ?? 'No timestamp',
      timestampServer: json['timestampServer'] as int? ?? 0,
      generators: (json['generators'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // Helper method to safely get generator hours
  double? getHours(String generatorData) {
    try {
      final parts = generatorData.split('_');
      if (parts.length != 2) return null;
      
      final hoursStr = parts[1].replaceAll('hrs', '').trim();
      return double.tryParse(hoursStr);
    } catch (e) {
      print('Error parsing generator hours: $e');
      return null;
    }
  }

  // Helper method to safely get generator number
  int? getGeneratorNumber(String generatorData) {
    try {
      final parts = generatorData.split('_');
      if (parts.length != 2) return null;
      
      final genStr = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(genStr);
    } catch (e) {
      print('Error parsing generator number: $e');
      return null;
    }
  }
}

class GeneratorCategory {
  final String name;
  final Map<String, GeneratorReading> readings;

  GeneratorCategory({
    required this.name,
    required this.readings,
  });

  factory GeneratorCategory.fromJson(String name, Map<dynamic, dynamic>? json) {
    if (json == null) {
      return GeneratorCategory(name: name, readings: {});
    }

    final Map<String, GeneratorReading> readingsMap = {};
    
    try {
      json.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          try {
            readingsMap[key.toString()] = GeneratorReading.fromJson(
              Map<String, dynamic>.from(value),
            );
          } catch (e) {
            print('Error parsing reading for key $key: $e');
          }
        }
      });
    } catch (e) {
      print('Error parsing readings for category $name: $e');
    }

    return GeneratorCategory(
      name: name,
      readings: readingsMap,
    );
  }

  GeneratorReading? getLatestReading() {
    if (readings.isEmpty) return null;
    
    try {
      return readings.values.reduce((a, b) => 
        a.timestampServer > b.timestampServer ? a : b
      );
    } catch (e) {
      print('Error getting latest reading: $e');
      return readings.values.firstOrNull;
    }
  }

  List<GeneratorReading> getSortedReadings() {
    try {
      return readings.values.toList()
        ..sort((a, b) => b.timestampServer.compareTo(a.timestampServer));
    } catch (e) {
      print('Error sorting readings: $e');
      return readings.values.toList();
    }
  }
}

class SiteGenerators {
  final String siteName;
  final Map<String, GeneratorCategory> categories;

  SiteGenerators({
    required this.siteName,
    required this.categories,
  });

  factory SiteGenerators.fromJson(String siteName, Map<dynamic, dynamic>? json) {
    if (json == null) {
      return SiteGenerators(siteName: siteName, categories: {});
    }

    final Map<String, GeneratorCategory> categoriesMap = {};
    
    try {
      json.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          try {
            categoriesMap[key.toString()] = GeneratorCategory.fromJson(
              key.toString(),
              value,
            );
          } catch (e) {
            print('Error parsing category $key for site $siteName: $e');
          }
        }
      });
    } catch (e) {
      print('Error parsing categories for site $siteName: $e');
    }

    return SiteGenerators(
      siteName: siteName,
      categories: categoriesMap,
    );
  }

  List<String> getCategoryNames() {
    return categories.keys.toList()..sort();
  }

  GeneratorCategory? getCategory(String categoryName) {
    return categories[categoryName];
  }
}

class AllGeneratorsData {
  final SiteGenerators? kakula;
  final SiteGenerators? kamoa;
  final SiteGenerators? kansoko;

  AllGeneratorsData({
    this.kakula,
    this.kamoa,
    this.kansoko,
  });

  factory AllGeneratorsData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return AllGeneratorsData();
    }

    return AllGeneratorsData(
      kakula: json['Kakula'] != null 
          ? SiteGenerators.fromJson('Kakula', json['Kakula'] as Map<dynamic, dynamic>?)
          : null,
      kamoa: json['Kamoa'] != null 
          ? SiteGenerators.fromJson('Kamoa', json['Kamoa'] as Map<dynamic, dynamic>?)
          : null,
      kansoko: json['Kansoko'] != null 
          ? SiteGenerators.fromJson('Kansoko', json['Kansoko'] as Map<dynamic, dynamic>?)
          : null,
    );
  }

  List<String> getAvailableSites() {
    final sites = <String>[];
    if (kakula != null) sites.add('Kakula');
    if (kamoa != null) sites.add('Kamoa');
    if (kansoko != null) sites.add('Kansoko');
    return sites;
  }

  SiteGenerators? getSite(String siteName) {
    switch (siteName.toLowerCase()) {
      case 'kakula':
        return kakula;
      case 'kamoa':
        return kamoa;
      case 'kansoko':
        return kansoko;
      default:
        return null;
    }
  }
}