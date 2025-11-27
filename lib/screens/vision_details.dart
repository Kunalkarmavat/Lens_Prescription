import 'package:eye_prescription/models/vision_details_model.dart';
import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/final_summary.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VisionDetailsScreen extends StatefulWidget {
  const VisionDetailsScreen({super.key});

  @override
  State<VisionDetailsScreen> createState() => _VisionDetailsScreenState();
}

class _VisionDetailsScreenState extends State<VisionDetailsScreen> {
  // 🔹 Controllers
  final TextEditingController rightSphere = TextEditingController();
  final TextEditingController leftSphere = TextEditingController();
  final TextEditingController rightNearAdd = TextEditingController();
  final TextEditingController leftNearAdd = TextEditingController();
  final TextEditingController rightCylinder = TextEditingController();
  final TextEditingController leftCylinder = TextEditingController();
  final TextEditingController rightAxis = TextEditingController();
  final TextEditingController leftAxis = TextEditingController();
  final TextEditingController note = TextEditingController();

  // 🔹 Prism Controllers
  final TextEditingController rightHorizontalPrism = TextEditingController();
  final TextEditingController leftHorizontalPrism = TextEditingController();
  final TextEditingController rightVerticalPrism = TextEditingController();
  final TextEditingController leftVerticalPrism = TextEditingController();

  // 🔹 PD Controllers
  final TextEditingController singlePd = TextEditingController();
  final TextEditingController distancePd = TextEditingController();
  final TextEditingController nearPd = TextEditingController();

  bool intermediateAdd = false;
  bool prism = false;
  bool pd = false;

  @override
  void dispose() {
    rightSphere.dispose();
    leftSphere.dispose();
    rightNearAdd.dispose();
    leftNearAdd.dispose();
    rightCylinder.dispose();
    leftCylinder.dispose();
    rightAxis.dispose();
    leftAxis.dispose();
    note.dispose();

    rightHorizontalPrism.dispose();
    leftHorizontalPrism.dispose();
    rightVerticalPrism.dispose();
    leftVerticalPrism.dispose();

    singlePd.dispose();
    distancePd.dispose();
    nearPd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Sizes.appBarHeight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: TColors.buttonSecondary),
        ),
        title: Text(
          'Vision Details',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: TColors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.defaultSpace),

            StepProgressIndicator(
              totalSteps: 2,
              currentStep: 2,
              size: 8,
              selectedColor: TColors.primary,
              unselectedColor: TColors.borderDark,
              roundedEdges: const Radius.circular(4),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            buildDualInputRow(
              "Right (+/-)",
              rightSphere,
              "Left (+/-)",
              leftSphere,
              title: "Sphere",
            ),
            buildDualInputRow(
              "Right",
              rightNearAdd,
              "Left",
              leftNearAdd,
              title: "Near Add",
            ),

            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: TColors.primary,
                  side: const BorderSide(color: TColors.darkGrey),
                  value: intermediateAdd,
                  onChanged: (val) => setState(() => intermediateAdd = val!),
                ),
                Text(
                  "Intermediate Add",
                  style: GoogleFonts.inter(
                    fontSize: Sizes.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const Divider(),
            buildDualInputRow(
              "Right",
              rightCylinder,
              "Left",
              leftCylinder,
              title: "Cylinder",
            ),
            buildDualInputRow(
              "Right",
              rightAxis,
              "Left",
              leftAxis,
              title: "Axis",
            ),
            const Divider(),

            // ✅ Prism (Boolean)
            buildBoolRadioGroup(
              "Prism",
              (val) => setState(() => prism = val),
              prism,
            ),

            if (prism)
              Column(
                children: [
                  buildDualInputRow(
                    "Right",
                    rightHorizontalPrism,
                    "Left",
                    leftHorizontalPrism,
                    title: "Horizontal Prism (Δ)",
                  ),
                  buildDualInputRow(
                    "Right",
                    rightVerticalPrism,
                    "Left",
                    leftVerticalPrism,
                    title: "Vertical Prism (Δ)",
                  ),
                ],
              ),

            const Divider(),

            // ✅ Pupillary Distance (Boolean)
            buildBoolRadioGroup(
              "Pupillary Distance",
              (val) => setState(() => pd = val),
              pd,
            ),

            if (pd)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Single PD',
                          style: GoogleFonts.inter(
                            fontSize: Sizes.fontSizeMd,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: buildTextField("PD (mm)", singlePd)),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Or',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: TColors.darkGrey,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  buildDualInputRow(
                    "Distance PD (mm)",
                    distancePd,
                    "Near PD (mm)",
                    nearPd,
                    title: "Dual PD",
                  ),
                ],
              ),

            const Divider(),
            buildSectionTitle("Note"),
            TextField(
              controller: note,
              cursorColor: TColors.primary,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                  borderSide: const BorderSide(
                    color: TColors.primary,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                  borderSide: const BorderSide(color: TColors.darkGrey),
                ),
                hintText: "Add your notes here",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: saveButton(),
    );
  }

  // 🟩 Section Title
  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: Sizes.fontSizeMd,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // 🟩 Dual Input Row
  Widget buildDualInputRow(
    String label1,
    TextEditingController c1,
    String label2,
    TextEditingController c2, {
    String title = "Not Specified",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Row(
          children: [
            Expanded(child: buildTextField(label1, c1)),
            const SizedBox(width: 10),
            Expanded(child: buildTextField(label2, c2)),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  // 🟩 Text Field
  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      cursorColor: TColors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: "+1.25 or -0.75",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TColors.primary, width: 1),
        ),
      ),
    );
  }

  // 🟩 Boolean Radio Group (Yes / No)
  Widget buildBoolRadioGroup(
    String title,
    Function(bool) onChanged,
    bool groupValue,
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
            Radio<bool>(
              value: true,
              groupValue: groupValue,
              activeColor: TColors.primary,
              onChanged: (val) => onChanged(val!),
            ),
            const Text("Yes"),
            Radio<bool>(
              value: false,
              groupValue: groupValue,
              activeColor: TColors.primary,
              onChanged: (val) => onChanged(val!),
            ),
            const Text("No"),
          ],
        ),
      ],
    );
  }

  // 🟩 Save Button
  Container saveButton() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 60,
      width: double.infinity,
      color: Colors.transparent,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
          ),
        ),
        onPressed: () async {
          DbProvider dbProvider = context.read<DbProvider>();

          if (rightSphere.text.isEmpty ||
              leftSphere.text.isEmpty ||
              rightNearAdd.text.isEmpty ||
              leftNearAdd.text.isEmpty ||
              rightCylinder.text.isEmpty ||
              leftCylinder.text.isEmpty ||
              rightAxis.text.isEmpty ||
              leftAxis.text.isEmpty) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "Please fill all vision details",
                backgroundColor: TColors.red,
              ),
            );
            return;
          }
          final visionInfo = VisionDetails(
            rightSphere: double.tryParse(rightSphere.text),
            leftSphere: double.tryParse(leftSphere.text),
            rightNearAdd: double.tryParse(rightNearAdd.text),
            leftNearAdd: double.tryParse(leftNearAdd.text),
            intermediateAdd: intermediateAdd, // ✅ bool → int
            rightCylinder: double.tryParse(rightCylinder.text),
            leftCylinder: double.tryParse(leftCylinder.text),
            rightAxis: int.tryParse(rightAxis.text),
            leftAxis: int.tryParse(leftAxis.text),
            prism: prism, // ✅ bool → int
            rightHorizontalPrism:   rightHorizontalPrism.text.isEmpty
                ? "-"
                : rightHorizontalPrism.text,
            leftHorizontalPrism: leftHorizontalPrism.text.isEmpty
                ? "-"
                : leftHorizontalPrism.text,
            rightVerticalPrism: rightVerticalPrism.text.isEmpty
                ? "-"
                : rightVerticalPrism.text,
            leftVerticalPrism: leftVerticalPrism.text.isEmpty
                ? "-"
                : leftVerticalPrism.text,
            pupillaryDistance: pd, // ✅ bool → int
            singlePd: int.tryParse(singlePd.text),
            
            rightDistancePd: distancePd.text.isNotEmpty
                ? double.tryParse(distancePd.text)
                : null,
            leftDistancePd: nearPd.text.isNotEmpty
                ? double.tryParse(nearPd.text)
                : null,
            note: note.text,
          );

          int check = await dbProvider.insertVisionDetails(visionInfo);

          if (check > 0) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: "Vision Details Saved ✅",
                backgroundColor: TColors.primary,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FinalSummary(),
              ),
            );
          }
        },
        child: Text(
          'Save',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.w500,
            color: TColors.textWhite,
          ),
        ),
      ),
    );
  }
}
