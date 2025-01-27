import 'package:app_name/model/kamoa.dart';
import 'package:app_name/views/phase1.dart';
import 'package:app_name/views/widgets/widgets/custom_button.dart';
import 'package:app_name/views/widgets/widgets/generator_widget.dart';
import 'package:app_name/views/widgets/widgets/speed_meter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: _buildAppBar(authController),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (homeController.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(homeController.errorMessage.value),
                  );
                }

                if (homeController.inverterData.isEmpty &&
                    homeController.spData.isEmpty &&
                    homeController.permissionData.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }

                return _buildDataList(homeController);
              }),
            ),
            // SpeedometerWidget(),
            // CustomButton1(
            //     color: Colors.blue,
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     text: 'START'),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(AuthController authController) {
    return AppBar(
      title: const Text('iCloud Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await authController.logout();
          },
        ),
      ],
    );
  }

  Widget _buildDataList(HomeController homeController) {
    return ListView(
      children: [
        ..._buildInverterList(homeController),
        ..._buildMorgensonData(homeController),
        ..._buildPermissionData(homeController),
        ..._buildEnergyData(homeController),
        ..._buildEnergyShiftData(homeController),
        const Text(
          'Generators Data',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        GeneratorsDashboard(
          generatorsData: homeController.generatorsData.value,
          isLoading: homeController.isLoading.value,
          errorMessage: homeController.errorMessage.value,
        ),
        const Text(
          'PHASE 1 Data',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Phase1Dashboard(
            phase1Data: homeController.phase1Data.value,
            isLoading: homeController.isLoading.value,
            errorMessage: homeController.errorMessage.value),
        const Text(
          'PHASE 2 Data',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Phase1Dashboard(
            phase1Data: homeController.phase2Data.value,
            isLoading: homeController.isLoading.value,
            errorMessage: homeController.errorMessage.value),
        const Text(
          'PHASE 3 Data',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Phase1Dashboard(
            phase1Data: homeController.phase3Data.value,
            isLoading: homeController.isLoading.value,
            errorMessage: homeController.errorMessage.value),
      ],
    );
  }

  List<Widget> _buildEnergyData(HomeController homeController) {
    return homeController.energyData.map((energyData) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: const Text(
            'Energy Data',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            // Generation Section
            _buildCategorySection(
              'Generation',
              energyData.generation,
            ),

            // Kakula KCS Section
            _buildCategorySection(
              'Kakula KCS',
              energyData.kakulaKCS,
            ),

            // Kakula M&I Section
            _buildCategorySection(
              'Kakula M&I',
              energyData.kakulaMAndI,
            ),

            // Kansoko M&I Section
            _buildCategorySection(
              'Kansoko M&I',
              energyData.kansokoMAndI,
            ),

            // KMCS Line Feeders Section
            _buildCategorySection(
              'KMCS Line Feeders',
              energyData.kmcsLineFeeders,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCategorySection(
      String title, Map<String, EnergyReading> readings) {
    // Get the latest reading
    final latestReading = _getLatestReading(readings);

    if (latestReading == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Display each energy data reading
          ...latestReading.energyData
              .map((data) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(data),
                  ))
              .toList(),
          const SizedBox(height: 8),
          Text(
            'Timestamp: ${latestReading.timestamp}',
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  EnergyReading? _getLatestReading(Map<String, EnergyReading> readings) {
    if (readings.isEmpty) return null;

    // Find the reading with the latest timestamp
    return readings.values
        .reduce((a, b) => a.timestampServer > b.timestampServer ? a : b);
  }

  List<Widget> _buildEnergyShiftData(HomeController homeController) {
    return homeController.energyDataSihftChanging.map((energyData) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: const Text(
            'Energy Data Shift Changing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            // Kakula KCS Section
            _buildCategorySection(
              'Kakula KCS',
              energyData.kakulaKCS,
            ),

            // Kakula M&I Section
            _buildCategorySection(
              'Kakula M&I',
              energyData.kakulaMAndI,
            ),

            // KMCS Line Feeders Section
            _buildCategorySection(
              'KMCS Line Feeders',
              energyData.kmcsLineFeeders,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInverterCard(InverterData inverter) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inverter ${inverter.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('ID: ${inverter.id}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Data: ${inverter.data}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInverterList(HomeController homeController) {
    return homeController.inverterData.map((inverter) {
      return _buildInverterCard(inverter);
    }).toList();
  }

  List<Widget> _buildMorgensonData(HomeController homeController) {
    return homeController.spData.entries.map((entry) {
      final sp = entry.value;
      return _buildSPCard(entry.key, sp);
    }).toList();
  }

  Widget _buildSPCard(String spName, SPData sp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('App Status: ${sp.appStatus}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Center: Lat = ${sp.lat}, Long = ${sp.long}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text('Has Output Dash: ${sp.hasOutputDash ? "Yes" : "No"}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Pump Start Time: ${sp.pumpStartTime}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // Builds the permission data section
  List<Widget> _buildPermissionData(HomeController homeController) {
    return homeController.permissionData.entries.map((entry) {
      final permission = entry.value;
      return _buildPermissionCard(entry.key, permission);
    }).toList();
  }

  // Builds a single permission card
  Widget _buildPermissionCard(String userName, PermissionData permission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: $userName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Directory: ${permission.directory}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Page: ${permission.page}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
