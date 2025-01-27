// phase1_widget.dart
import 'package:app_name/model/phase_model.dart';
import 'package:flutter/material.dart';

class Phase1Dashboard extends StatelessWidget {
  final PhaseData? phase1Data;
  final bool isLoading;
  final String errorMessage;

  const Phase1Dashboard({
    Key? key,
    required this.phase1Data,
    required this.isLoading,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (phase1Data == null) {
      return const Center(child: Text('No Phase 1 data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpandableSection(
            'Running Equipment',
            phase1Data!.getRunningEquipment(),
            Colors.green,
          ),
          const SizedBox(height: 20),
          _buildExpandableSection(
            'Stopped Equipment',
            phase1Data!.getStoppedEquipment(),
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
      String title, List<PhaseReading> readings, Color color) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      children: readings.map((reading) => _buildReadingCard(reading)).toList(),
    );
  }

  Widget _buildReadingCard(PhaseReading reading) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reading.status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Running Time:',
                '${reading.totalRunningTime.toStringAsFixed(2)} hrs'),
            _buildInfoRow('Not Running Time:',
                '${reading.totalNotRunningTime.toStringAsFixed(2)} hrs'),
            _buildInfoRow('Last Status Change:', reading.lastStatusChange),
            _buildInfoRow('Last Updated:', reading.timestamp),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
