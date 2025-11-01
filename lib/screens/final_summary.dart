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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescriptionData();
  }

  Future<void> _loadPrescriptionData() async {
    final provider = Provider.of<DbProvider>(context, listen: false);
    final data = await provider.getSinglePrescriptionData();

    setState(() {
      prescriptionData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5146F0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Prescription Details",
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.edit_document, color: Colors.white),
                SizedBox(width: 12),
                Icon(Icons.share, color: Colors.white),
              ],
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : prescriptionData == null
              ? const Center(child: Text("No Data Found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      infoRow("Prescription Name", prescriptionData!['name'] ?? "N/A"),
                      const SizedBox(height: 12),
                      infoRow("Prescription Date", prescriptionData!['date'] ?? "N/A"),
                      const SizedBox(height: 12),
                      infoRow("Doctor’s Name", prescriptionData!['doctor'] ?? "N/A"),
                      const SizedBox(height: 12),
                      infoRow("Lens Type", prescriptionData!['lensType'] ?? "N/A"),
                      const SizedBox(height: 20),

                      Container(height: 1, color: Colors.grey.shade300),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tableHeader("Direction"),
                          tableHeader("Sphere"),
                          tableHeader("Cylinder"),
                          tableHeader("Axis"),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            tableRow(
                              "Right",
                              prescriptionData!['rightSphere'] ?? "0.00",
                              prescriptionData!['rightCylinder'] ?? "0.00",
                              prescriptionData!['rightAxis'] ?? "0.00",
                            ),
                            Container(height: 0.8, color: Colors.black54),
                            tableRow(
                              "Left",
                              prescriptionData!['leftSphere'] ?? "0.00",
                              prescriptionData!['leftCylinder'] ?? "0.00",
                              prescriptionData!['leftAxis'] ?? "0.00",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        color: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Note", style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                            Text(
                              prescriptionData!['note'] ?? "+ Add",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
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
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          ),
                          child: Text(
                            "Go Back To Home",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // 🔹 Info Row
  Widget infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        Text(value, style: GoogleFonts.inter(fontSize: 14)),
      ],
    );
  }

  // 🔹 Table Header
  Widget tableHeader(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  // 🔹 Table Row
  Widget tableRow(String direction, String sphere, String cyl, String axis) {
    return Row(
      children: [
        tableCell(direction, isBold: true),
        tableCell(sphere),
        tableCell(cyl),
        tableCell(axis),
      ],
    );
  }

  // 🔹 Table Cell
  Widget tableCell(String text, {bool isBold = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.black54, width: 0.8),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontWeight: isBold ? FontWeight.w500 : FontWeight.w400),
        ),
      ),
    );
  }
}
