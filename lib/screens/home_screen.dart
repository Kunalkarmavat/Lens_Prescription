import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/personal_info.dart';
import 'package:eye_prescription/screens/prescription_details.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/image_strings.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<DbProvider>(context, listen: false).loadPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: Sizes.appBarHeight,
        title: Text(
          'Lens Prescription',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeLg,
            fontWeight: FontWeight.w500,
            color: TColors.textDarkPrimary,
          ),
        ),
        backgroundColor: TColors.primary,
      ),

      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          return provider.filteredPrescriptions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(TImages.noData, width: 200, height: 200),
                      const SizedBox(height: 20),
                      const Text('No prescriptions', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    /// ✅ Search Bar
                    Padding(
                      padding: const EdgeInsets.all(Sizes.gridViewSpacing),
                      child: TextField(
                        onChanged: provider.filterPrescriptions,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.borderRadiusSm),
                            ),
                          ),
                          hintText: 'Search patient...',
                          suffixIcon: Icon(Icons.filter_list),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    /// ✅ Prescription List
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.filteredPrescriptions.length,
                        itemBuilder: (context, index) {
                          final pres = provider.filteredPrescriptions[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrescriptionDetails(prescription: pres),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: Sizes.gridViewSpacing,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  Sizes.borderRadiusMd,
                                ),
                                border: Border.all(
                                  color: TColors.borderSecondary,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  pres['patient_name'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.fontSizeMd,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Doctor: ${pres['doctor_name'] ?? '-'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Sizes.fontSizeSm,
                                      ),
                                    ),
                                    Text(
                                      'Lens Type: ${pres['lens_type'] ?? '-'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Sizes.fontSizeSm,
                                      ),
                                    ),
                                    Text(
                                      'Exam Date: ${pres['exam_date'] ?? '-'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Sizes.fontSizeSm,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
