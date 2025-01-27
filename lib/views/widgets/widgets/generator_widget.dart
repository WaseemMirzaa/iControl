import 'package:app_name/model/genrator_model.dart';
import 'package:flutter/material.dart';

class GeneratorsDashboard extends StatelessWidget {
  final AllGeneratorsData? generatorsData;
  final bool isLoading;
  final String errorMessage;

  const GeneratorsDashboard({
    Key? key,
    required this.generatorsData,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (generatorsData == null) {
      return const Center(
        child: Text('No generator data available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Build cards for each site
          if (generatorsData?.kakula != null)
            _buildSiteCard(generatorsData!.kakula!),
          if (generatorsData?.kamoa != null)
            _buildSiteCard(generatorsData!.kamoa!),
          if (generatorsData?.kansoko != null)
            _buildSiteCard(generatorsData!.kansoko!),
        ],
      ),
    );
  }

  Widget _buildSiteCard(SiteGenerators site) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          site.siteName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: site.getCategoryNames().map((categoryName) {
                final category = site.getCategory(categoryName);
                if (category == null) return const SizedBox.shrink();
                return _buildCategorySection(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(GeneratorCategory category) {
    final latestReading = category.getLatestReading();
    if (latestReading == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        _buildGeneratorsList(latestReading),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildGeneratorsList(GeneratorReading reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...reading.generators.map((generator) {
          final hours = reading.getHours(generator);
          final number = reading.getGeneratorNumber(generator);
          
          if (hours == null || number == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Generator $number'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${hours.toStringAsFixed(1)} hrs',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Last updated: ${reading.timestamp}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}