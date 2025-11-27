import 'package:eye_prescription/models/personal_info_model.dart';
import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/vision_details.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());

  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController doctor = TextEditingController();
  final TextEditingController examDate = TextEditingController();
  final TextEditingController reminderDate = TextEditingController();

  String? selectedLens;

  final List<String> lensTypes = [
    'Distance',
    'Reading',
    'Computer',
    'Trifocal',
    'Bifocal',
    'Progressive',
  ];

  @override
    void dispose() {
    name.dispose();
    age.dispose();
    doctor.dispose();
    examDate.dispose();
    reminderDate.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    examDate.text = currentDate;
    reminderDate.text = currentDate;
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
          'Personal Information',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: TColors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.defaultSpace),
              const StepProgressIndicator(
                totalSteps: 2,
                currentStep: 1,
                size: 8,
                selectedColor: TColors.primary,
                unselectedColor: TColors.borderDark,
                roundedEdges: Radius.circular(4),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              inputField(name, "Patient Name", "Enter patient name"),
              inputField(
                age,
                "Age",
                "Enter patient age",
                keyboardType: TextInputType.number,
              ),
              inputField(doctor, "Doctor's Name", "Dr. Kunal Karmavat"),
              inputField(
                examDate,
                "Date of Examination",
                currentDate,
                isDateField: true,
              ),
              inputField(
                reminderDate,
                "Reminder Date",
                currentDate,
                isDateField: true,
              ),

              Text(
                "Lens Type",
                style: GoogleFonts.inter(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwItems),

              Wrap(
                spacing: 8,
                children: lensTypes.map((type) {
                  final isSelected = selectedLens == type;
                  return ChoiceChip(
                    label: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: TColors.primary,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedLens = selected ? type : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      bottomSheet: saveButton(context),
    );
  }

  // 🔹 Reusable Input Field
  Widget inputField(
    TextEditingController controller,
    String title,
    String hint, {
    bool isDateField = false,
    TextInputType keyboardType = TextInputType.text,
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
        TextFormField(
          controller: controller,
          readOnly: isDateField,
          keyboardType: keyboardType,
          cursorColor: TColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: TColors.primary, width: 1),
            ),
            suffixIcon: isDateField
                ? IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        controller.text = DateFormat(
                          'dd MMM yyyy',
                        ).format(pickedDate);
                      }
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  // 🔹 Save Button
  Widget saveButton(BuildContext context) {
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

          if (name.text.isEmpty ||
              age.text.isEmpty ||
              doctor.text.isEmpty ||
              examDate.text.isEmpty ||
              reminderDate.text.isEmpty ||
              selectedLens == null) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(message: "Please fill all fields",
              backgroundColor: TColors.red,
              ),
            );
            return;
          }

          final personalInfo = PersonalInfoModel(
            patientName: name.text,
            age: int.tryParse(age.text) ?? 0,
            doctorName: doctor.text,
            examDate: examDate.text,
            reminderDate: reminderDate.text,
            lensType: selectedLens ?? '',
          );

          int check = await dbProvider.insertPersonalInfo(personalInfo);

          if (check > 0) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(message: " Personal Info Saved ✅",
              backgroundColor: TColors.primary,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VisionDetailsScreen(),
              ),
            );
          }
        },
        child: Text(
          'Save',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
