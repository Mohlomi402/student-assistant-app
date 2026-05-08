import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/application_viewmodel.dart';
import 'application_form_screen.dart';
import 'home_screen.dart';

class ApplicationDetailScreen extends StatelessWidget {

  final Map<String, dynamic> application;

  const ApplicationDetailScreen({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {

    final applicationVM =
        Provider.of<ApplicationViewModel>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Application Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Student Assistant Application',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [
                        const Icon(Icons.school),
                        const SizedBox(width: 10),
                        Text(
                          'Year: ${application['year']}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.book),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Module 1: ${application['module1']}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(Icons.book_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Module 2: ${application['module2']}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(width: 10),
                        Text(
                          'Status: ${application['status']}',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                application['status'] ==
                                        'Approved'
                                    ? Colors.green
                                    : application['status'] ==
                                            'Rejected'
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
            const SizedBox(height: 40),
            if (application['status'] == 'Pending')

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),

                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),

                  label: const Text(
                    'Edit Application',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ApplicationFormScreen(
                          application: application,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (application['status'] == 'Pending')

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(
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

                      builder: (context) =>
                          AlertDialog(

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

                          TextButton(

                            onPressed: () async {

                              await applicationVM
                                  .deleteApplication(
                                application['id']
                                    .toString(),
                              );
                              Navigator.pop(context);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const HomeScreen(),
                                ),
                              );
                            },

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

