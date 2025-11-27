import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FinalSummary extends StatefulWidget {
  const FinalSummary({super.key});

  @override
  State<FinalSummary> createState() => _FinalSummaryState();
}

class _FinalSummaryState extends State<FinalSummary> {
  Map<String, dynamic>? prescriptionData;

  @override
  void initState() {
    super.initState();
    loadPrescription();
  }

  // 🔹 Fetch Data from DB
  void loadPrescription() async {
    final data = await context.read<DbProvider>().getFullPrescription();
    setState(() {
      prescriptionData = data;
    });
  }

  // 🔹 Safe string converter
  String safeString(dynamic value) =>
      (value == null || value.toString().trim().isEmpty)
          ? "-"
          : value.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5146F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Prescription Summary",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
      ),
      body: prescriptionData == null
          ? const Center(child: CircularProgressIndicator())
          : buildSummaryUI(),
    );
  }

  // 🔹 MAIN UI
  Widget buildSummaryUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          //* PERSONAL INFORMATION

          sectionTitle("Personal Information"),
          infoRow("Patient Name", safeString(prescriptionData!['patient_name'])),
          infoRow("Age", safeString(prescriptionData!['age'])),
          infoRow("Doctor Name", safeString(prescriptionData!['doctor_name'])),
          infoRow("Exam Date", safeString(prescriptionData!['exam_date'])),
          infoRow("Reminder Date", safeString(prescriptionData!['reminder_date'])),
          infoRow("Lens Type", safeString(prescriptionData!['lens_type'])),
          const SizedBox(height: 20),

          // ============================================================
          //* SPHERE
          sectionTitle("Sphere (SPH)"),
          buildTable(
            headerTitles: ["Eye", "Value"],
            rows: [
              {"dir": "Right", "val": safeString(prescriptionData!['right_sphere'])},
              {"dir": "Left", "val": safeString(prescriptionData!['left_sphere'])},
            ],
          ),
          const SizedBox(height: 20),

          //* CYL & AXIS
          sectionTitle("Cylinder (CYL) & Axis"),
          buildTable(
            headerTitles: ["Eye", "CYL", "Axis"],
            rows: [
              {
                "dir": "Right",
                "cyl": safeString(prescriptionData!['right_cylinder']),
                "axis": safeString(prescriptionData!['right_axis']),
              },
              {
                "dir": "Left",
                "cyl": safeString(prescriptionData!['left_cylinder']),
                "axis": safeString(prescriptionData!['left_axis']),
              }
            ],
          ),
          const SizedBox(height: 20),

          //* NEAR ADD

          sectionTitle("Near Add"),
          buildTable(
            headerTitles: ["Eye", "Add"],
            rows: [
              {"dir": "Right", "add": safeString(prescriptionData!['right_near_add'])},
              {"dir": "Left", "add": safeString(prescriptionData!['left_near_add'])},
            ],
          ),
          const SizedBox(height: 20),

          //* PRISM DETAILS

          sectionTitle("Prism Details"),
          infoRow("Prism Enabled", prescriptionData!['prism'] == 1 ? "Yes" : "No"),
          infoRow("Right Horizontal Prism",
              safeString(prescriptionData!['right_horizontal_prism'])),
          infoRow("Left Horizontal Prism",
              safeString(prescriptionData!['left_horizontal_prism'])),
          infoRow("Right Vertical Prism",
              safeString(prescriptionData!['right_vertical_prism'])),
          infoRow("Left Vertical Prism",
              safeString(prescriptionData!['left_vertical_prism'])),
          const SizedBox(height: 20),

          sectionTitle("Pupillary Distance (PD)"),
          infoRow("Single PD", safeString(prescriptionData!['single_pd'])),
          infoRow("Right Distance PD",
              safeString(prescriptionData!['right_distance_pd'])),
          infoRow("Left Distance PD",
              safeString(prescriptionData!['left_distance_pd'])),
          const SizedBox(height: 20),

          sectionTitle("Intermediate Add"),
          infoRow("Intermediate Add",
              prescriptionData!['intermediate_add'] == 1 ? "Yes" : "No"),
          const SizedBox(height: 20),

  
          sectionTitle("Notes"),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              safeString(prescriptionData!['note']),
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),

          const SizedBox(height: 40),
          backButton(),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          Text(value, style: GoogleFonts.inter(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildTable({
    required List<String> headerTitles,
    required List<Map<String, String?>> rows,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: headerTitles
              .map((h) => Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Table rows
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: rows.map((map) {
              return Row(
                children: map.values.map((v) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black26),
                        ),
                      ),
                      child: Text(
                        safeString(v),
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget backButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5146F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HomeScreen())),
        child: Text(
          "Go Back",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
