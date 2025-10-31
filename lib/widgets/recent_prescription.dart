
import 'package:eye_prescription/models/prescription.dart';
import 'package:flutter/material.dart';

class RecentPrescriptionScreen extends StatelessWidget {
  final List<Prescription> prescriptions;
  const RecentPrescriptionScreen(this.prescriptions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Prescriptions")),
      body: prescriptions.isEmpty
          ? const Center(
              child: Text(
                "No prescriptions found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                Prescription p = prescriptions[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) =>
                    //         FinalSummaryScreen(prescription: p),
                    //   ),
                    // );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p.patientName ?? ''),
                          Text(p.lensType != null
                              ? p.lensType.toString().split('.').last
                              : ''),
                          Text(p.date ?? ''),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
