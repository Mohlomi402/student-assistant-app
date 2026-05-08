import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application_model.dart';
import '../viewmodels/application_viewmodel.dart';
import 'home_screen.dart';

class ApplicationFormScreen extends StatefulWidget {

  final Map<String, dynamic>? application;

  const ApplicationFormScreen({
    super.key,
    this.application,
  });

  @override
  State<ApplicationFormScreen> createState() =>
      _ApplicationFormScreenState();
}

class _ApplicationFormScreenState
    extends State<ApplicationFormScreen> {

  final formKey = GlobalKey<FormState>();

  final yearController =
      TextEditingController();

  final module1Controller =
      TextEditingController();

  final module2Controller =
      TextEditingController();

  bool eligible = false;

  @override
  void initState() {
    super.initState();

    if (widget.application != null) {

      yearController.text =
          widget.application!['year'];

      module1Controller.text =
          widget.application!['module1'];

      module2Controller.text =
          widget.application!['module2'];

      eligible =
          widget.application!['eligible'] ??
              false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final applicationVM =
        Provider.of<ApplicationViewModel>(
      context,
    );

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.application == null
              ? 'New Application'
              : 'Edit Application',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: ListView(
            children: [

              TextFormField(
                controller: yearController,

                decoration: const InputDecoration(
                  labelText:
                      'Current Year of Study',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Please enter year';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: module1Controller,

                decoration: const InputDecoration(
                  labelText: 'Module 1',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Please enter module';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: module2Controller,

                decoration: const InputDecoration(
                  labelText:
                      'Module 2 (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              CheckboxListTile(

                value: eligible,

                title: const Text(
                  'I confirm that I meet the requirements',
                ),

                onChanged: (value) {

                  setState(() {

                    eligible = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                onPressed: () async {

                  if (formKey.currentState!
                      .validate()) {

                    final user =
                        Supabase.instance.client
                            .auth.currentUser;

                    ApplicationModel application =
                        ApplicationModel(

                      id: '',

                      studentId:
                          user?.id ?? '',

                      year:
                          yearController.text,

                      module1:
                          module1Controller.text,

                      module2:
                          module2Controller.text,

                      status: 'Pending',

                      eligible: eligible,
                    );

                    if (widget.application ==
                        null) {

                      await applicationVM
                          .addApplication(
                        application,
                      );

                    }

                    else {

                      await applicationVM
                          .updateApplication(
                        widget.application!['id']
                            .toString(),
                        application,
                      );
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HomeScreen(),
                      ),
                    );
                  }
                },

                child: Text(

                  widget.application == null
                      ? 'Submit Application'
                      : 'Update Application',

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
