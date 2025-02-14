import 'dart:async';

import 'package:app_name/views/widgets/widgets/custom_button.dart';
import 'package:app_name/views/widgets/widgets/speed_meter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late HomeController homeController;
  final Rx<SPData?> selectedSPData = Rx<SPData?>(null);


  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    _tabController = TabController(length: homeController.spData.length, vsync: this);

    // Initialize with sorted data
    List<MapEntry<String, dynamic>> sortedSpData = homeController.spData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    selectedSPData.value = sortedSpData[_tabController.index].value;

    _tabController.addListener(_onTabChanged);



  }

  void _onTabChanged() {
    List<MapEntry<String, dynamic>> sortedSpData = homeController.spData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    selectedSPData.value = sortedSpData[_tabController.index].value;
    print("Tab changed: ${_tabController.index}");
    print("New BS Voltage: ${selectedSPData.value?.bsVoltage}");
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final HomeController homeController = Get.find<HomeController>();
    final AuthController authController = Get.find<AuthController>();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: _buildAppBar(authController),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // speed meter
            SizedBox(
              height: screenHeight * 0.2,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6),
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      child: Obx(() {
                        if (selectedSPData.value != null) {
                          return SpeedMeter(
                            key: Key('output-${_tabController.index}'),
                            speed: selectedSPData.value!.outputVoltage.toDouble(),
                            alertSpeedArray: const [250.0, 500.0, 700.0],
                            maxSpeed: 1000.0,
                            unitOfMeasurement: 'Km/sec',
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.4,
                    child: Obx(() {
                      if (selectedSPData.value != null) {
                        return SpeedMeter(
                          key: Key('bs-${_tabController.index}'),
                          speed: selectedSPData.value!.bsVoltage.toDouble(),
                          alertSpeedArray: const [2500.0, 5000.0, 7000.0],
                          maxSpeed: 10000.0,
                          unitOfMeasurement: 'MPH',
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ),
                ],
              ),
            ),

        _buildButtonRow(context, screenWidth),

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

                if (homeController.spData.isEmpty &&
                    homeController.permissionData.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
                return _buildDataList(homeController, screenHeight, screenWidth);
              }),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildButtonRow(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton1(color: Colors.green, onPressed: () => Navigator.pop(context), text: 'START', ),
        CustomButton1(color: Colors.red, onPressed: () => Navigator.pop(context), text: 'STOP', ),
        CustomButton1(color: Colors.orange, onPressed: () => Navigator.pop(context), text: 'RESET',),
      ],
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

  Widget _buildDataList(HomeController homeController, double screenHeight, double screenWidth) {

    List<MapEntry<String, dynamic>> sortedSpData = homeController.spData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return SizedBox(
      height: screenHeight * 0.8,
      width: screenWidth * 0.95,
      child: Column(
        children: [
          // Tab Bar Container
          const SizedBox(height: 15,),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: sortedSpData.map((spEntry) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Tab(text: spEntry.key),
              )).toList(),
            ),
          ),

          // tab bar view
          Expanded(
            flex: 5,
            child: TabBarView(
              controller: _tabController,
              children: sortedSpData.map((entry) => ListView(
                children: [
                  ...homeController.spData.entries
                      .where((e) => e.key == entry.key)
                      .map((e) => _buildSPCard(e.key, e.value)),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildInverterCard(InverterData inverter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ID: ${inverter.id}', style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 4),
              Text('Data: ${inverter.data}',
                  style: const TextStyle(fontSize: 13)),
            ],
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
    return LayoutBuilder(builder: (context, constraints){
      final double fontSize = constraints.maxWidth * 0.04;
      final double spacing = constraints.maxWidth * 0.04;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing, horizontal: spacing / 2),
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
            SizedBox(height: spacing,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //***Fist section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    RichText(
                      text: TextSpan(
                        children: [
                          const  TextSpan(
                            text: 'Status: ',
                            style: TextStyle(fontSize: 14.3, color: Colors.black),
                          ),
                          TextSpan(
                            text: '${sp.appStatus}',
                            style: const TextStyle(
                                fontSize: 14.3,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Run Freq: ',
                              style:  TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.runFreq}HZ',
                            style: const TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),

                    SizedBox(height: spacing),

                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: 'Output: ',
                            style: TextStyle(fontSize: 14.3, color: Colors.black),
                          ),
                          TextSpan(
                            text: '${sp.outputVoltage}kW',
                            style: const TextStyle(
                                fontSize: 14.3,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ])),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Fault Status: ',
                              style:  TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.faultStatus}',
                            style: const TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Torque: ',
                              style: const TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.torqueOutput}',
                            style: TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),
                  ],
                ),

                //***Second section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'DC Bus: ',
                              style: const TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.bsVoltage} VDC',
                            style: TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Temp: ',
                              style:  TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.temp}°C',
                            style: const TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Pwr On Time: ',
                              style:  TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.currentPowerOnTime} min',
                            style: const TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),

                    SizedBox(height: spacing),

                    RichText(text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Run Time: ',
                              style: const TextStyle(fontSize: 14.3, color: Colors.black)
                          ), TextSpan(
                            text: '${sp.currentRunTime} min',
                            style: TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                        ]
                    )),
                  ],
                ),

              ],
            ),

             SizedBox(height: spacing),
            RichText(text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'Pump Start Time: ',
                      style: TextStyle(fontSize: 14.3, color: Colors.black)
                  ),
                  const TextSpan(
                    text: '              ',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: '${sp.pumpStartTime}',
                    style: const TextStyle(fontSize: 14.3, fontWeight: FontWeight.bold, color: Colors.black),
                  )
                ]
            )),
          ],
        ),
      );
    });
  }
}




