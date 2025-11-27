import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class PrescriptionDetails extends StatelessWidget {
  
  final Map<String, dynamic> prescription;

  const PrescriptionDetails({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${prescription['patient_name'] ?? '-'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text('Right Sphere: ${prescription['right_sphere'] ?? '-'}'),
            Text('Left Sphere: ${prescription['left_sphere'] ?? '-'}'),
            Text('Right Cylinder: ${prescription['right_cylinder'] ?? '-'}'),
            Text('Left Cylinder: ${prescription['left_cylinder'] ?? '-'}'),
            Text('Right Axis: ${prescription['right_axis'] ?? '-'}'),
            Text('Left Axis: ${prescription['left_axis'] ?? '-'}'),

            const SizedBox(height: 10),
            Text('Add (Near): ${prescription['right_near_add'] ?? '-'}'),
            Text('Intermediate Add: ${prescription['intermediate_add'] ?? '-'}'),

            const SizedBox(height: 10),
            Text('Lens Type: ${prescription['lens_type'] ?? '-'}'),
            Text('Exam Date: ${prescription['exam_date'] ?? '-'}'),
            Text('Reminder Date: ${prescription['reminder_date'] ?? '-'}'),

            const SizedBox(height: 10),
            Text('Note: ${prescription['note'] ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
