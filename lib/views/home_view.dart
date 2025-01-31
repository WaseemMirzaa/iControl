import 'package:app_name/model/kamoa.dart';
import 'package:app_name/views/phase1.dart';
import 'package:app_name/views/widgets/widgets/custom_button.dart';
import 'package:app_name/views/widgets/widgets/generator_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final AuthController authController = Get.find<AuthController>();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05;
    final double buttonWidth = screenWidth * 0.25;

    return Scaffold(
      appBar: _buildAppBar(authController),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SpeedometerWidget(),

            _buildButtonRow(context, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            const Center(
              child:  Text(
                'Inverter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    return SizedBox(
      height: screenHeight * 0.8,
      width: screenWidth * 0.95,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                ..._buildInverterList(homeController),
                // ..._buildMorgensonData(homeController),
              ],
            ),
          ),

          // Tab Bar Container
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300], // Background color for the tab container
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white, // Text color when selected
              unselectedLabelColor: Colors.black, // Text color when not selected
              indicator: BoxDecoration(
                color: Colors.green, // Selected tab background color
                borderRadius: BorderRadius.circular(20), // Makes it round
              ),
              indicatorSize: TabBarIndicatorSize.tab, // Ensures full height indicator
              dividerColor: Colors.transparent, // Hides the bottom line
              overlayColor: MaterialStateProperty.all(Colors.transparent), // No highlight effect
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, // 60% width of tab
                  child: Tab(text: 'SP-01'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, // 60% width of tab
                  child: Tab(text: 'SP-02'),
                ),
              ],
            ),
          ),


          // Tab Bar View
          Expanded(
            flex: 5,
            child: TabBarView(
              controller: _tabController,
              children: [
                // First Tab - SP-01
                ListView(
                  children: [
                    ...homeController.spData.entries
                        .where((entry) => entry.key == 'SP-01')
                        .map((entry) => _buildSPCard(entry.key, entry.value)),
                  ],
                ),
                // Second Tab - SP-02
                ListView(
                  children: [
                    ...homeController.spData.entries
                        .where((entry) => entry.key == 'SP-02')
                        .map((entry) => _buildSPCard(entry.key, entry.value)),
                  ],
                ),
              ],
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




