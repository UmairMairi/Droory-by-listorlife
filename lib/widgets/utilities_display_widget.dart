import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/utils/utils.dart';

class UtilitiesDisplayWidget extends StatelessWidget {
  final String utilitiesString;
  final bool isDetailView;

  const UtilitiesDisplayWidget({
    Key? key,
    required this.utilitiesString,
    this.isDetailView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (utilitiesString.isEmpty) {
      return const SizedBox.shrink();
    }

    // Parse the utilities from the comma-separated string
    final List<String> utilities = utilitiesString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDetailView) ...[
          Text(
            StringHelper.accessToUtilities,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
        ],
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: utilities.map((utility) {
            // Important: Use the getUtilityTyp method to properly translate each utility
            String displayName = Utils.getUtilityTyp(utility);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getUtilityIcon(utility),
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method to get appropriate icon for each utility
  IconData _getUtilityIcon(String utility) {
    String normalizedUtility = utility.trim().toLowerCase();

    // Map utility types to their corresponding icons
    final Map<String, IconData> utilityIcons = {
      "water supply": Icons.water_drop_outlined,
      "electricity": Icons.electric_bolt_outlined,
      "gas": Icons.local_fire_department_outlined,
      "sewage system": Icons.water_damage_outlined,
      "road access": Icons.route_outlined,
      "off plan": Icons.engineering_outlined,
      "ready": Icons.check_circle_outlined,
    };

    return utilityIcons[normalizedUtility] ?? Icons.check_circle_outline;
  }
}
