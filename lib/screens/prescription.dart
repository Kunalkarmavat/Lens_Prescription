import 'package:eye_prescription/db/db_helper.dart';
import 'package:eye_prescription/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrescriptionScreen extends StatefulWidget {
  PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
  
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  List<Map<String, dynamic>> prescriptions = [];
  @override
    void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final db = DBHelper.getInstance;
    final data = await db.getAllPrescriptions();
    setState(() {
      prescriptions = data;
      
    });
  }



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
          "New Prescription",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            const SizedBox(height: 24),

            infoRow("Prescription Name", prescriptions[1]['prescriptionName'] ?? "NA" ),
            const SizedBox(height: 12),
            infoRow("Prescription Date", "14 , July , 2025"),
            const SizedBox(height: 12),
            infoRow("Set Reminder Date", "19 , Feb , 2025"),
            const SizedBox(height: 12),
            infoRow("Doctor’s Name (Optional)", "19 , Feb , 2025"),
            const SizedBox(height: 12),
            infoRow("Lense type", "Spherecal"),
            const SizedBox(height: 20),

            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
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
                  tableRow("Right", "0.00", "0.00", "0.00"),
                  Container(height: 0.8, color: Colors.black54),
                  tableRow("Left", "0.00", "0.00", "0.00"),
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
                  Text(
                    "Note",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "+ Add",
                    style: GoogleFonts.inter(
                        color: Colors.black, fontWeight: FontWeight.w500),
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                )),
                child: Text(
                  "Got Back To Home",
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
    return 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
           
            const SizedBox(width: 10),
            Text(
              value,
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ],
        );
      
    
  }

  // 🔹 Table Header
  Widget tableHeader(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
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
          style: GoogleFonts.inter(
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
