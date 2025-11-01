import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/utils/constants/colors.dart';
import 'package:eye_prescription/utils/constants/image_strings.dart';
import 'package:eye_prescription/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:eye_prescription/screens/personal_info.dart';
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
    context.read<DbProvider>().getAllPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Sizes.appBarHeight,
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(Icons.arrow_back),
        // ),
        // iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Lens Prescription',
          style: GoogleFonts.inter(
            fontSize: Sizes.fontSizeLg,
            fontWeight: FontWeight.w400,
            color: TColors.textDarkPrimary,
          ),
        ),
        backgroundColor: TColors.primary,
      ),

      body: Consumer<DbProvider>(
        builder: (ctx, provider, child) {
          List<Map<String, dynamic>> prescriptions = provider.mData;
          return prescriptions.isEmpty
              ? Center(
                  child: Container(
                    height: 300,
                    child: Column(
                      children: [
                        Image.asset(
                          TImages.noData,
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'No prescriptions',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(Sizes.gridViewSpacing),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(Sizes.borderRadiusMd))
                            
                          ),
                          hintText: 'Search prescriptions...',
                          suffixIcon: Icon(Icons.filter_list),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: prescriptions.isEmpty
                          ? const Center(child: Text('No prescriptions yet'))
                          : ListView.builder(
                              itemCount: prescriptions.length,
                              itemBuilder: (context, index) {
                                final pres = prescriptions[index];
                                return Container(
                                  height: 90,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      // BoxShadow(
                                      //   color: TColors.borderDark,
                                      //   spreadRadius: 1,
                                      //   offset: const Offset(
                                      //     1,
                                      //     2,
                                      //   ), // changes position of shadow
                                      // ),
                                    ],
                                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                                    border: Border.all(
                                      color: TColors.borderSecondary,
                                      width: 1,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: Sizes.gridViewSpacing,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      pres['prescription_name'] ?? '',

                                      
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Sizes.fontSizeMd
                                        ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${pres['lens_type']}',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Sizes.fontSizeSm
                                        ),
                                        
                                        
                                        ),
                                        Text(
                                          pres['prescription_date'] ?? '',
                                          
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Sizes.fontSizeSm
                                        ),
                                        
                                        ),
                                      ],
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalInfo()),
          );
          context.read<DbProvider>().getAllPrescription();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
