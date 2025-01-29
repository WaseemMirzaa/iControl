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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SpeedometerWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton1(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'START'),
                CustomButton1(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'STOP'),
                CustomButton1(
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'RESET'),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

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
        // ..._buildPermissionData(homeController),
        // ..._buildEnergyData(homeController),
        // ..._buildEnergyShiftData(homeController),

        // const Text(
        //   'Generators Data',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // GeneratorsDashboard(
        //   generatorsData: homeController.generatorsData.value,
        //   isLoading: homeController.isLoading.value,
        //   errorMessage: homeController.errorMessage.value,
        // ),
        // const Text(
        //   'PHASE 1 Data',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Phase1Dashboard(
        //     phase1Data: homeController.phase1Data.value,
        //     isLoading: homeController.isLoading.value,
        //     errorMessage: homeController.errorMessage.value),
        // const Text(
        //   'PHASE 2 Data',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Phase1Dashboard(
        //     phase1Data: homeController.phase2Data.value,
        //     isLoading: homeController.isLoading.value,
        //     errorMessage: homeController.errorMessage.value),
        // const Text(
        //   'PHASE 3 Data',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Phase1Dashboard(
        //     phase1Data: homeController.phase3Data.value,
        //     isLoading: homeController.isLoading.value,
        //     errorMessage: homeController.errorMessage.value),
      ],
    );
  }

  // List<Widget> _buildEnergyData(HomeController homeController) {
  //   return homeController.energyData.map((energyData) {
  //     return Card(
  //       margin: const EdgeInsets.all(8.0),
  //       child: ExpansionTile(
  //         title: const Text(
  //           'Energy Data',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         children: [
  //           // Generation Section
  //           _buildCategorySection(
  //             'Generation',
  //             energyData.generation,
  //           ),
  //
  //           // Kakula KCS Section
  //           _buildCategorySection(
  //             'Kakula KCS',
  //             energyData.kakulaKCS,
  //           ),
  //
  //           // Kakula M&I Section
  //           _buildCategorySection(
  //             'Kakula M&I',
  //             energyData.kakulaMAndI,
  //           ),
  //
  //           // Kansoko M&I Section
  //           _buildCategorySection(
  //             'Kansoko M&I',
  //             energyData.kansokoMAndI,
  //           ),
  //
  //           // KMCS Line Feeders Section
  //           _buildCategorySection(
  //             'KMCS Line Feeders',
  //             energyData.kmcsLineFeeders,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }

  // Widget _buildCategorySection(
  //     String title, Map<String, EnergyReading> readings) {
  //   // Get the latest reading
  //   final latestReading = _getLatestReading(readings);
  //
  //   if (latestReading == null) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         // Display each energy data reading
  //         ...latestReading.energyData
  //             .map((data) => Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                   child: Text(data),
  //                 ))
  //             .toList(),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Timestamp: ${latestReading.timestamp}',
  //           style: const TextStyle(
  //             fontSize: 12,
  //             fontStyle: FontStyle.italic,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // EnergyReading? _getLatestReading(Map<String, EnergyReading> readings) {
  //   if (readings.isEmpty) return null;
  //
  //   // Find the reading with the latest timestamp
  //   return readings.values
  //       .reduce((a, b) => a.timestampServer > b.timestampServer ? a : b);
  // }
  //
  // List<Widget> _buildEnergyShiftData(HomeController homeController) {
  //   return homeController.energyDataSihftChanging.map((energyData) {
  //     return Card(
  //       margin: const EdgeInsets.all(8.0),
  //       child: ExpansionTile(
  //         title: const Text(
  //           'Energy Data Shift Changing',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         children: [
  //           // Kakula KCS Section
  //           _buildCategorySection(
  //             'Kakula KCS',
  //             energyData.kakulaKCS,
  //           ),
  //
  //           // Kakula M&I Section
  //           _buildCategorySection(
  //             'Kakula M&I',
  //             energyData.kakulaMAndI,
  //           ),
  //
  //           // KMCS Line Feeders Section
  //           _buildCategorySection(
  //             'KMCS Line Feeders',
  //             energyData.kmcsLineFeeders,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
  //
  Widget _buildInverterCard(InverterData inverter) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child:  Text(
                'Inverter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('ID: ${inverter.id}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Data: ${inverter.data}',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
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
  //
  List<Widget> _buildMorgensonData(HomeController homeController) {
    return homeController.spData.entries.map((entry) {
      final sp = entry.value;
      return _buildSPCard(entry.key, sp);
    }).toList();
  }

// SP Widget
  Widget _buildSPCard(String spName, SPData sp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
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

          // fist row
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const  TextSpan(
                      text: 'Status: ',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextSpan(
                      text: '${sp.appStatus}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),

              RichText(text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Run Freq: ',
                        style:  TextStyle(fontSize: 14, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.runFreq}HZ',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),

              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text: 'Output: ',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                TextSpan(
                  text: '${sp.outputVoltage}kW',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]))
            ],
          ),


          // const SizedBox(height: 4),
          // Text(
          //   'Center: Lat = ${sp.lat}, Long = ${sp.long}',
          //   style: const TextStyle(fontSize: 14),
          // ),

          // second row
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Fault Status: ',
                        style:  TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.faultStatus}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Torque: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.torqueOutput}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),

            ],
          ),


          // third Row
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'DC Bus: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.bsVoltage} VDC',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Temp: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.temp}°C',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),

            ],
          ),

          // Last Row
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Pwr On Time: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.currentPowerOnTime} min',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Run Time: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black)
                    ), TextSpan(
                      text: '${sp.currentRunTime} min',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ]
              )),
            ],
          ),

          const SizedBox(height: 30),
          RichText(text: TextSpan(
            children: [
              const TextSpan(
                text: 'Pump Start Time: ',
                style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              const TextSpan(
                text: '              ',
                style: TextStyle(fontSize: 20),
              ),
              TextSpan(
                text: '${sp.pumpStartTime}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              )
            ]
          )),
        ],
      ),
    );
  }

// Builds the permission data section
// List<Widget> _buildPermissionData(HomeController homeController) {
//   return homeController.permissionData.entries.map((entry) {
//     final permission = entry.value;
//     return _buildPermissionCard(entry.key, permission);
//   }).toList();
// }

// Builds a single permission card
// Widget _buildPermissionCard(String userName, PermissionData permission) {
//   return Card(
//     margin: const EdgeInsets.only(bottom: 16),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'User: $userName',
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text('Directory: ${permission.directory}',
//               style: const TextStyle(fontSize: 14)),
//           const SizedBox(height: 4),
//           Text('Page: ${permission.page}',
//               style: const TextStyle(fontSize: 14)),
//         ],
//       ),
//     ),
//   );
// }
}
