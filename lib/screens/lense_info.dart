import 'package:eye_prescription/db/db_helper.dart';
import 'package:eye_prescription/screens/prescription.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class LenseInfo extends StatefulWidget {
  @override
  State<LenseInfo> createState() => _LenseInfoState();
}

class _LenseInfoState extends State<LenseInfo> {
  // Controllers
  final TextEditingController rightSphere = TextEditingController();
  final TextEditingController leftSphere = TextEditingController();
  final TextEditingController rightNearAdd = TextEditingController();
  final TextEditingController leftNearAdd = TextEditingController();
  final TextEditingController rightCylinder = TextEditingController();
  final TextEditingController leftCylinder = TextEditingController();
  final TextEditingController rightAxis = TextEditingController();
  final TextEditingController leftAxis = TextEditingController();
  final TextEditingController note = TextEditingController();

  bool intermediateAdd = false;
  String prism =  "No";
  String pd = "No";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Sizes.appBarHeight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Lens Info',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeLg,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: TColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Sphere"),
            SizedBox(height: Sizes.spaceBtwItems),
            buildDualInputRow("Right", rightSphere, "Left", leftSphere),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            buildSectionTitle("Near Add"),
            SizedBox(height: Sizes.spaceBtwItems),
            buildDualInputRow("Right", rightNearAdd, "Left", leftNearAdd),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Row(
              children: [
                Checkbox(
                  value: intermediateAdd,
                  onChanged: (val) {
                    setState(() {
                      intermediateAdd = val ?? false;
                    });
                  },
                ),
                const Text("Intermediate Add"),
              ],
            ),
            const Divider(height: 30),

            buildSectionTitle("Cylinder"),
            SizedBox(height: Sizes.spaceBtwItems),

            buildDualInputRow("Right", rightCylinder, "Left", leftCylinder),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            buildSectionTitle("Axis"),
            SizedBox(height: Sizes.spaceBtwItems),
            buildDualInputRow("Right", rightAxis, "Left", leftAxis),

            const Divider(height: 30),

            buildRadioGroup("Prism", (val) {
              setState(() => prism = val);
            }, prism),

            buildRadioGroup("Pupillary Distance (PD)", (val) {
              setState(() => pd = val);
            }, pd),

            const Divider(height: 30),

            buildSectionTitle("Note"),
            const SizedBox(height: Sizes.spaceBtwItems),
            TextField(
              controller: note,
              decoration: InputDecoration(
                hintText: "Add your notes here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),

      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          onPressed: () async {
            DBHelper dbHelper = DBHelper.getInstance;

            String rightSphere = this.rightSphere.text;
            String leftSphere =
                this.leftSphere.text; // <- also mistake here (see next)
            String rightCylinder = this.rightCylinder.text;
            String leftCylinder = this.leftCylinder.text;
            String rightAxis = this.rightAxis.text;
            String leftAxis = this.leftAxis.text;

            // Validation
            if (rightSphere.isEmpty ||
                leftSphere.isEmpty ||
                rightCylinder.isEmpty ||
                leftCylinder.isEmpty ||
                rightAxis.isEmpty ||
                leftAxis.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please fill all required fields."),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }

            bool check = await dbHelper.addLensInfo(
              rightSphere: rightSphere,
              leftSphere: leftSphere,
              rightNearAdd: this.rightNearAdd.text,
              leftNearAdd: this.leftNearAdd.text,
              intermediateAdd: intermediateAdd ? "Yes" : "No",
              rightCylinder: rightCylinder,
              leftCylinder: leftCylinder,
              rightAxis: rightAxis,
              leftAxis: leftAxis,
              prism: prism,
              pupillaryDistance: pd,
              note: note.text,
            );

            if (check) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Prescription Saved Successfully ✅"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrescriptionScreen(),
                ), // <- Navigate next
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to Save Prescription ❌"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },

          child: Text(
            'Save & Next',
            style: GoogleFonts.inter(
              color: TColors.textWhite,
              fontSize: Sizes.fontSizeMd,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.inter(
      fontSize: Sizes.fontSizeMd,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget buildDualInputRow(
    String label1,
    TextEditingController c1,
    String label2,
    TextEditingController c2,
  ) {
    return Row(
      children: [
        Expanded(child: buildTextField(label1, c1)),
        const SizedBox(width: 10),
        Expanded(child: buildTextField(label2, c2)),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget buildRadioGroup(
    String title,
    Function(String) onChanged,
    String groupValue,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: Sizes.fontSizeMd,
          ),
        ),
        Row(
          children: [
            Radio(
              activeColor: TColors.primary,
              value: "Yes",
              groupValue: groupValue,
              onChanged: (val) => onChanged(val!),
            ),
            const Text("Yes"),
            Radio(
              activeColor: TColors.primary,
              value: "No",
              groupValue: groupValue,
              onChanged: (val) => onChanged(val!),
            ),
            const Text("No"),
          ],
        ),
      ],
    );
  }
}
