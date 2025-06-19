import 'dart:developer';

import 'package:app_name/model/genrator_model.dart';
import 'package:app_name/model/kamoa.dart';
import 'package:app_name/model/phase_model.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class InverterData {
  final String id;
  final String data;

  InverterData({required this.id, required this.data});

  factory InverterData.fromMap(Map<String, dynamic> map) {
    return InverterData(
      id: map['id'] ?? '',
      data: map['data'] ?? '',
    );
  }
}

class PermissionData {
  final String directory;
  final String page;

  PermissionData({
    required this.directory,
    required this.page,
  });

  factory PermissionData.fromMap(Map<String, dynamic> map) {
    return PermissionData(
      directory: map['directory'] ?? '',
      page: map['page'] ?? '',
    );
  }
}

class SPData {
  final String appStatus;
  final String faultStatus;
  final int torqueOutput;
  final int currentPowerOnTime;
  final int currentRunTime;
  final int runFreq;
  final int bsVoltage;
  final int temp;
  final double lat;
  final double long;
  final int outputVoltage;
  final int outputCurrent;
  final String pumpStartTime;

  SPData({
    required this.appStatus,
    required this.faultStatus,
    required this.torqueOutput,
    required this.currentPowerOnTime,
    required this.currentRunTime,
    required this.runFreq,
    required this.bsVoltage,
    required this.temp,
    required this.lat,
    required this.long,
    required this.outputVoltage,
    required this.outputCurrent,
    required this.pumpStartTime,
  });

  factory SPData.fromMap(Map<String, dynamic> map) {
    return SPData(
      appStatus: map['statusDescription'] ?? '',
      faultStatus: map['fault_info']?['description'] ?? '',
      torqueOutput: map['Output_Torque'] ?? 0.0,
      currentPowerOnTime: map['Current_Power_ON_Time'] ?? 0.0,
      currentRunTime: map['Current_Run_Time'] ?? 0.0,
      runFreq: map['Running_Frequency'] ?? 0.0,
      bsVoltage: map['Bus_voltage'] ?? 0.0,
      temp: map['VSD_temp'] ?? 0.0,
      lat: map['center']?['lat']?.toDouble() ?? 0.0,
      long: map['center']?['long']?.toDouble() ?? 0.0,
      outputVoltage: map['Output_Voltage'] ?? 0.0,
      outputCurrent: map['Output_Current'] ?? 0.0,
      pumpStartTime: map['pump_start_time'] ?? '',
    );
  }
}

class HomeController extends GetxController {
  final _db = FirebaseDatabase.instance.ref();
  final inverterData = <InverterData>[].obs; // Observable list of InverterData
  final spData = <String, SPData>{}.obs; // Observable map for Morgenson data
  final isLoading = true.obs; // Observable to track loading state
  final errorMessage = ''.obs; // Observable for error messages
  final permissionData =
      <String, PermissionData>{}.obs; // Observable map for PermissionData
  final energyData = <EnergyData>[].obs; // Observable list of EnergyData
  final energyDataSihftChanging =
      <EnergyData>[].obs; // Observable list of EnergyData

  final Rx<AllGeneratorsData?> generatorsData = Rx<AllGeneratorsData?>(null);
  final Rx<PhaseData?> phase1Data = Rx<PhaseData?>(null);
  final Rx<PhaseData?> phase2Data = Rx<PhaseData?>(null);
  final Rx<PhaseData?> phase3Data = Rx<PhaseData?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchInverterData();
    fetchMorgensonData();
    fetchPermissionsData();
    fetchEnergyData();
    fetchEnergySifhtChangingData();
    fetchGeneratorsData();
    fetchPhase1Data();
    fetchPhase2Data();
    fetchPhase3Data();
  }

  Future<void> fetchPhase1Data() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Fetching phase 1 data...');
      final snapshot = await _db.child('Kamoa/PlantPhase1').get();

      if (snapshot.exists && snapshot.value != null) {
        print('Raw snapshot value: ${snapshot.value}');

        final data = snapshot.value as Map<dynamic, dynamic>;
        phase1Data.value = PhaseData.fromJson(data);
      } else {
        print('Snapshot does not exist or is null');
        errorMessage.value = 'No data available';
        phase1Data.value = null;
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'Error fetching data: $e';
      phase1Data.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPhase2Data() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Fetching phase 1 data...');
      final snapshot = await _db.child('Kamoa/PlantPhase2').get();

      if (snapshot.exists && snapshot.value != null) {
        print('Raw snapshot value: ${snapshot.value}');

        final data = snapshot.value as Map<dynamic, dynamic>;
        phase2Data.value = PhaseData.fromJson(data);
      } else {
        print('Snapshot does not exist or is null');
        errorMessage.value = 'No data available';
        phase2Data.value = null;
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'Error fetching data: $e';
      phase2Data.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPhase3Data() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Fetching phase 1 data...');
      final snapshot = await _db.child('Kamoa/PlantPhase3').get();

      if (snapshot.exists && snapshot.value != null) {
        print('Raw snapshot value: ${snapshot.value}');

        final data = snapshot.value as Map<dynamic, dynamic>;
        phase3Data.value = PhaseData.fromJson(data);
      } else {
        print('Snapshot does not exist or is null');
        errorMessage.value = 'No data available';
        phase3Data.value = null;
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'Error fetching data: $e';
      phase3Data.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEnergySifhtChangingData() async {
    try {
      print('Fetching energy data...');
      final snapshot = await _db.child('Kamoa/EnergyData').get();

      if (snapshot.exists) {
        print('Snapshot exists, data found: ${snapshot.value}');

        final data = snapshot.value as Map<dynamic, dynamic>;
        energyDataSihftChanging.clear();

        // Convert and add the entire data structure as one EnergyData object
        try {
          final typedData = Map<String, dynamic>.from(data);
          final parsedData = EnergyData.fromJson(typedData);
          energyDataSihftChanging.add(parsedData);
          print('Energy data loaded successfully');
        } catch (e) {
          print('Error parsing energy data: $e');
        }

        print('Energy data loaded, count: ${energyDataSihftChanging.length}');
      } else {
        errorMessage.value = 'No data available';
        print('No data found in snapshot');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
      print('Data fetching completed, loading state: ${isLoading.value}');
    }
  }

  Future<void> fetchEnergyData() async {
    try {
      print('Fetching energy data...');
      final snapshot = await _db.child('Kamoa/EnergyData').get();

      if (snapshot.exists) {
        print('Snapshot exists, data found: ${snapshot.value}');

        final data = snapshot.value as Map<dynamic, dynamic>;
        energyData.clear();

        // Convert and add the entire data structure as one EnergyData object
        try {
          final typedData = Map<String, dynamic>.from(data);
          final parsedData = EnergyData.fromJson(typedData);
          energyData.add(parsedData);
          print('Energy data loaded successfully');
        } catch (e) {
          print('Error parsing energy data: $e');
        }

        print('Energy data loaded, count: ${energyData.length}');
      } else {
        errorMessage.value = 'No data available';
        print('No data found in snapshot');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
      print('Data fetching completed, loading state: ${isLoading.value}');
    }
  }

  Future<void> fetchGeneratorsData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Fetching generators data...');
      final snapshot = await _db.child('Kamoa/genRunHours').get();

      if (snapshot.exists && snapshot.value != null) {
        print('Generators data found');

        try {
          final data = snapshot.value as Map<dynamic, dynamic>;
          generatorsData.value = AllGeneratorsData.fromJson(data);
          print('Generators data parsed successfully');
        } catch (e) {
          print('Error parsing generators data: $e');
          errorMessage.value = 'Error parsing data: $e';
          generatorsData.value = null;
        }
      } else {
        errorMessage.value = 'No generators data available';
        generatorsData.value = null;
        print('No generators data found');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching generators data: $e';
      generatorsData.value = null;
      print('Error fetching generators data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch permissions data from Firebase
  void fetchPermissionsData() {
    isLoading.value = true;

    _db.child('permissions').onValue.listen(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          permissionData.clear();
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              permissionData[key] =
                  PermissionData.fromMap(Map<String, dynamic>.from(value));
            }
          });
        }
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Error fetching permissions data: $error';
      },
    );
  }

  // Fetch inverter data from Firebase
  void fetchInverterData() {
    isLoading.value = true;

    _db.child('JKSigns/Inverter').onValue.listen(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          inverterData.clear();
          data.forEach((key, value) {
            if (value is int) {
              inverterData.add(InverterData(
                id: key,
                data: value.toString(),
              ));
            }
          });
        }
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Error fetching inverter data: $error';
      },
    );
  }

  // Fetch Morgenson SP data from Firebase
  void fetchMorgensonData() {
    isLoading.value = true;

    _db.child('Morgenson').onValue.listen(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          spData.clear();
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              final sp = SPData.fromMap(Map<String, dynamic>.from(value));
              spData[key] = sp;
            }
          });
        }
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Error fetching Morgenson data: $error';
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
