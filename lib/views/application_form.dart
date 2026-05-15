//Members
// 220044173 Mohlomi_T
// 221013252 Kwetle_ME
// 221019628 Makhetha_L
// 223008010 Brits_T
// 221008431 Choane SRT
// 221003714 Leeuw SA
// 221027626 Mokhele M
// 223043312 Choeu TM
// 223038645 Ndlovu N

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/application_view_model.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() =>
      _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {

  // =====================================================
  // CONTROLLERS
  // =====================================================
  final TextEditingController module1Controller =
      TextEditingController();

  final TextEditingController module2Controller =
      TextEditingController();

  // =====================================================
  // DROPDOWNS
  // =====================================================
  String yearLevel = "1";
  String module1Level = "1";
  String module2Level = "1";

  // =====================================================
  // FILE VARIABLES
  // =====================================================
  Uint8List? selectedFileBytes;
  String? selectedFileName;
  PlatformFile? selectedFile;
  // =====================================================
  // OTHER VARIABLES
  // =====================================================
  bool confirmEligibility = false;
  bool isLoading = false;

  // =====================================================
  // FILE PICKER
  // =====================================================
  Future<void> pickFile() async {

    try {

      final result =
          await FilePicker.platform.pickFiles(

        type: FileType.custom,

        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
        ],

        withData: true,
      );

      // USER CANCELLED
      if (result == null ||
          result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      // SAFETY CHECK
      if (file.bytes == null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Could not read file",
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      setState(() {

        selectedFileBytes = file.bytes!;
        selectedFileName = file.name;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Selected: $selectedFileName",
          ),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "File picker error: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // SUBMIT APPLICATION
  // =====================================================
  Future<void> submitApplication() async {

  // VALIDATION FIRST (NO NULLS ALLOWED)
  if (module1Controller.text.trim().isEmpty ||
      selectedFileBytes == null ||
      selectedFileName == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please complete all required fields"),
      ),
    );
    return;
  }

  if (!confirmEligibility) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please confirm eligibility"),
      ),
    );
    return;
  }

  setState(() => isLoading = true);

  try {

    final success =
        await context.read<ApplicationViewModel>().submitApplication(
          module1: module1Controller.text.trim(),
          module1Level: module1Level,
          module2: module2Controller.text.trim().isEmpty
              ? null
              : module2Controller.text.trim(),
          module2Level: module2Controller.text.trim().isEmpty
              ? null
              : module2Level,
          yearLevel: yearLevel,

          // 🔥 NEVER NULL HERE
          cvBytes: selectedFileBytes!,
          fileName: selectedFileName!,
        );

    setState(() => isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Application submitted successfully"
              : "Application submission failed",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);

  } catch (e) {
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Student Assistant Application",
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =================================================
            // STUDENT INFORMATION
            // =================================================
            const Text(
              "Student Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value: yearLevel,

              decoration:
              const InputDecoration(

                labelText:
                "Current Year of Study",

                border:
                OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: "1",
                  child:
                  Text("1st Year"),
                ),

                DropdownMenuItem(
                  value: "2",
                  child:
                  Text("2nd Year"),
                ),

                DropdownMenuItem(
                  value: "3",
                  child:
                  Text("3rd Year"),
                ),

                DropdownMenuItem(
                  value: "4",
                  child:
                  Text("4th Year"),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  yearLevel = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            // =================================================
            // MODULE APPLICATION 1
            // =================================================
            const Text(
              "Module Application 1",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(

              controller:
              module1Controller,

              decoration:
              const InputDecoration(

                labelText:
                "Module Name",

                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value:
              module1Level,

              decoration:
              const InputDecoration(

                labelText:
                "Academic Level",

                border:
                OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: "1",
                  child:
                  Text("Level 1"),
                ),

                DropdownMenuItem(
                  value: "2",
                  child:
                  Text("Level 2"),
                ),

                DropdownMenuItem(
                  value: "3",
                  child:
                  Text("Level 3"),
                ),

                DropdownMenuItem(
                  value: "4",
                  child:
                  Text("Level 4"),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  module1Level =
                      value!;
                });
              },
            ),

            const SizedBox(height: 30),

            // =================================================
            // MODULE APPLICATION 2
            // =================================================
            const Text(
              "Module Application 2 (Optional)",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(

              controller:
              module2Controller,

              decoration:
              const InputDecoration(

                labelText:
                "Module Name",

                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value:
              module2Level,

              decoration:
              const InputDecoration(

                labelText:
                "Academic Level",

                border:
                OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: "1",
                  child:
                  Text("Level 1"),
                ),

                DropdownMenuItem(
                  value: "2",
                  child:
                  Text("Level 2"),
                ),

                DropdownMenuItem(
                  value: "3",
                  child:
                  Text("Level 3"),
                ),

                DropdownMenuItem(
                  value: "4",
                  child:
                  Text("Level 4"),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  module2Level =
                      value!;
                });
              },
            ),

            const SizedBox(height: 30),

            // =================================================
            // ELIGIBILITY
            // =================================================
            CheckboxListTile(

              value:
              confirmEligibility,

              onChanged: (value) {

                setState(() {

                  confirmEligibility =
                      value ?? false;
                });
              },

              title: const Text(
                "I confirm that I meet the eligibility requirements",
              ),

              controlAffinity:
              ListTileControlAffinity
                  .leading,
            ),

            const SizedBox(height: 20),

            // =================================================
            // FILE PICKER
            // =================================================
            const Text(
              "Supporting Document",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(15),

              decoration: BoxDecoration(

                border: Border.all(
                  color: Colors.grey,
                ),

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),

              child: Column(

                children: [

                  ElevatedButton.icon(

                    onPressed:
                    pickFile,

                    icon: const Icon(
                      Icons.upload_file,
                    ),

                    label: const Text(
                      "Upload CV / Document",
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    selectedFileName ??
                        "No file selected",

                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =================================================
            // SUBMIT BUTTON
            // =================================================
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : submitApplication,

                child: isLoading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(
                  "Submit Application",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}