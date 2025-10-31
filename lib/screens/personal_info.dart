import 'package:eye_prescription/db/db_helper.dart';
import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/lense_info.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({super.key});

  final String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  final dbHelper = DBHelper.getInstance;


  @override
  Widget build(BuildContext context) {
    TextEditingController _name = TextEditingController();
    TextEditingController _doctor = TextEditingController();
    TextEditingController _currentDate = TextEditingController(
      text: currentDate,
    );
    TextEditingController _reminder = TextEditingController(text: currentDate);

    // Selected lens type
    ValueNotifier<String?> selectedLens = ValueNotifier<String?>(null);

    final List<String> lensTypes = [
      'Distance',
      'Reading',
      'Computer',
      'Trifocal',
      'Bifocal',
      'Progressive',
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Sizes.appBarHeight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Prescription Info',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeLg,
            fontWeight: FontWeight.w400,
            color: TColors.textDarkPrimary,
          ),
        ),
        backgroundColor: TColors.primary,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.defaultSpace),

              // Prescription Name
              presInput(context, _name, "Prescription Name", "Prescription 1"),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // Doctor Name
              presInput(
                context,
                _doctor,
                "Doctor's Name",
                "Dr. Kunal Karmavat",
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              presInput(
                context,
                _currentDate,
                "Prescription Date",
                currentDate,
                isDateField: true,
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // Reminder Date
              presInput(
                context,
                _reminder,
                "Reminder Date",
                currentDate,
                isDateField: true,
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // Lens Type Selector
              Text(
                "Select Lenses Type",
                style: GoogleFonts.inter(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              ValueListenableBuilder<String?>(
                valueListenable: selectedLens,
                builder: (context, value, _) {
                  return Wrap(
                    spacing: 4,
                    children: lensTypes.map((type) {
                      final isSelected = value == type;
                      return ChoiceChip(
                        label: Text(
                          type,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          selectedLens.value = selected ? type : null;
                        },
                        selectedColor: TColors.primary,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // 🧩 Bottom Sheet Button
      bottomSheet: bottomButton(
        context,
        _name,
        _doctor,
        _currentDate,
        _reminder,
        selectedLens,
      ),
    );
  }

  // 🔹 Reusable Input Field
  Column presInput(
    BuildContext context,
    TextEditingController controller,
    String title,
    String hint, {
    bool isDateField = false,
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
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
      ],
    );
  }

  // 🔹 Bottom Sheet Button
  Container bottomButton(
    BuildContext context,
    TextEditingController name,
    TextEditingController doctor,
    TextEditingController presDate,
    TextEditingController reminder,
    ValueNotifier<String?> lens,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (name.text.isEmpty || doctor.text.isEmpty || lens.value == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please fill all required fields."),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          }


          // Save Data to DB and get inserted prescription ID
          bool check = await dbHelper.addPrescription(
            prescriptionName: name.text,
            prescriptionDate: presDate.text,
            reminderDate: reminder.text,
            doctorName: doctor.text,
            lensType: lens.value ?? '',
          );

          if (check) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Prescription Saved Successfully ✅"),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to LenseInfo screen with prescriptionId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LenseInfo(),
              ),
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
          'Next & Save',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.w400,
            color: TColors.textWhite,
          ),
        ),
      ),
    );
  }
}
