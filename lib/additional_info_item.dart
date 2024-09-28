import 'package:flutter/material.dart';
class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenwidth*0.25,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            icon, 
            size: 32,
            ),
          const SizedBox(height: 8),         // take everything here from constructor
          Text(label),
          const SizedBox(height: 8),
          Text(value, 
          style:  const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
        ],
      ),
    );
  }
}

