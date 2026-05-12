import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final UserModel application;

  const ApplicationDetailScreen({
    super.key,
    required this.application,
  });

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  final supabase = Supabase.instance.client;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(
      text: widget.application.firstName,
    );

    lastNameController = TextEditingController(
      text: widget.application.lastName,
    );

    emailController = TextEditingController(
      text: widget.application.email,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();

    final status = widget.application.status ?? 'pending';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'User Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Assistant Application',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// EMAIL
                    TextField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// FIRST NAME
                    TextField(
                      controller: firstNameController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LAST NAME
                    TextField(
                      controller: lastNameController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// STATUS
                    Row(
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(width: 10),
                        const SizedBox(width: 10),
                        Text(
                          'Status: $status',
                          style: TextStyle(
                            fontSize: 18,
                            color: status == 'Approved'
                                ? Colors.green
                                : status == 'Rejected'
                                    ? Colors.red
                                    : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (status == 'Pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.green : Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    isEditing ? 'Save Changes' : 'Edit Application',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (isEditing) {
                      
                      await supabase.from('applications').update({
                        'first_name': firstNameController.text,
                        'last_name': lastNameController.text,
                        'email': emailController.text,
                        }).eq('id', widget.application.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Application Updated',
                            ),
                          ),
                        );
                      } 

                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              ),

            const SizedBox(height: 20),

            // DELETE BUTTON
            if (status == 'Pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Delete Application',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete Application',
                        ),
                        content: const Text(
                          'Are you sure you want to delete this application?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),

                          /// DELETE CONFIRM
                          TextButton(
                            onPressed: () async {
                              await supabase.from('applications')
                              .delete()
                              .eq('id', widget.application.id);

                              Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Application Deleted',
                                    ),
                                  ),
                                );
                              } ,
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
