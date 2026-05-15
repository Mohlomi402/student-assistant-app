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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/application_view_model.dart';

class EditApplicationScreen extends StatefulWidget {

  final Map<String, dynamic> application;

  const EditApplicationScreen({
    super.key,
    required this.application,
  });

  @override
  State<EditApplicationScreen> createState() =>
      _EditApplicationScreenState();
}

class _EditApplicationScreenState
    extends State<EditApplicationScreen> {

  // =====================================================
  // CONTROLLERS
  // =====================================================
  late TextEditingController module1Controller;
  late TextEditingController module2Controller;

  // =====================================================
  // DROPDOWN VALUES
  // =====================================================
  late String yearLevel;
  late String module1Level;
  late String module2Level;

  // =====================================================
  // LOADING
  // =====================================================
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // ===============================================
    // PRE-FILL EXISTING DATA
    // ===============================================
    module1Controller =
        TextEditingController(
      text: widget.application['module1'],
    );

    module2Controller =
        TextEditingController(
      text:
      widget.application['module2'] ?? '',
    );

    yearLevel =
        widget.application['year_level'];

    module1Level =
        widget.application['module1_level'];

    module2Level =
        widget.application['module2_level']
            ?? '1';
  }

  // =====================================================
  // UPDATE APPLICATION
  // =====================================================
  Future<void> updateApplication() async {

    // ===============================================
    // MODULE 1 REQUIRED
    // ===============================================
    if (module1Controller.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Module 1 is required",
          ),
        ),
      );

      return;
    }

    // ===============================================
    // MODULES CANNOT MATCH
    // ===============================================
    if (module2Controller.text
            .trim()
            .isNotEmpty &&
        module1Controller.text
                .trim()
                .toLowerCase() ==
            module2Controller.text
                .trim()
                .toLowerCase()) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Modules cannot be the same",
          ),
        ),
      );

      return;
    }

    setState(() {

      isLoading = true;
    });

    // ===============================================
    // CALL VIEWMODEL
    // ===============================================
    final success =
        await context
            .read<ApplicationViewModel>()
            .updateApplication(

      id:
      widget.application['id'],

      module1:
      module1Controller.text.trim(),

      module1Level:
      module1Level,

      module2:
      module2Controller.text
              .trim()
              .isEmpty
          ? null
          : module2Controller.text.trim(),

      module2Level:
      module2Controller.text
              .trim()
              .isEmpty
          ? null
          : module2Level,

      yearLevel:
      yearLevel,
    );

    setState(() {

      isLoading = false;
    });

    if (!mounted) return;

    // ===============================================
    // SUCCESS
    // ===============================================
    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Application updated successfully",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Failed to update application",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {

    module1Controller.dispose();
    module2Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Edit Application",
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ===========================================
            // YEAR LEVEL
            // ===========================================
            const Text(
              "Current Year of Study",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(

              value: yearLevel,

              decoration:
              const InputDecoration(

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

            const SizedBox(height: 25),

            // ===========================================
            // MODULE 1
            // ===========================================
            const Text(
              "Module Application 1",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 25),

            // ===========================================
            // MODULE 2
            // ===========================================
            const Text(
              "Module Application 2 (Optional)",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 40),

            // ===========================================
            // UPDATE BUTTON
            // ===========================================
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : updateApplication,

                child: isLoading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(
                  "Update Application",
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