import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';

class NearbyScreen extends StatelessWidget {
  final AppState state;

  const NearbyScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final facilities = [
      {
        'name': 'City General Hospital',
        'type': 'Hospital · 24x7 Emergency',
        'distance': '1.2 km away',
        'rating': '4.8',
        'address': 'MG Road, Indiranagar',
        'phone': '+91 80 2520 1234',
        'tone': 'mint',
      },
      {
        'name': 'Apollo Pharmacy',
        'type': 'Pharmacy · Open till 11 PM',
        'distance': '450 m away',
        'rating': '4.6',
        'address': '12th Main Road, HAL 2nd Stage',
        'phone': '+91 80 2521 5678',
        'tone': 'cream',
      },
      {
        'name': 'Dr. Ananya Roy Clinic',
        'type': 'General Physician · Consultation',
        'distance': '2.1 km away',
        'rating': '4.9',
        'address': 'Greenview Medical Centre',
        'phone': '+91 80 4112 9000',
        'tone': 'blue',
      },
      {
        'name': 'City Imaging & Diagnostics',
        'type': 'Diagnostic Lab · X-Ray, Blood Tests',
        'distance': '1.8 km away',
        'rating': '4.7',
        'address': '80 Feet Road, Koramangala',
        'phone': '+91 80 4115 4321',
        'tone': 'peach',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Care Near You'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Search hospital, pharmacy, doctor…',
                prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location, color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Category Filters
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', true),
                  _buildFilterChip('Hospitals', false),
                  _buildFilterChip('Doctors', false),
                  _buildFilterChip('Pharmacies', false),
                  _buildFilterChip('Labs', false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Recommended Near Your Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            ...facilities.map((f) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              f['name']!,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.toneCreamBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.toneCreamBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.toneCreamText),
                                const SizedBox(width: 2),
                                Text(
                                  f['rating']!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.toneCreamText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        f['type']!,
                        style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${f['address']} · ${f['distance']}',
                            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.phone, size: 16),
                              label: const Text('Call'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.directions, size: 16),
                              label: const Text('Directions'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {},
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.onSurface,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
