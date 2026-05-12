import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assistant_app/viewmodels/auth_viewmodel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationViewModel>().fetchMyApplications();
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> application) {
    final moduleController = TextEditingController(text: application['moduleName']);
    final levelController = TextEditingController(text: application['academicLevel']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: moduleController,
              decoration: const InputDecoration(
                labelText: 'Module Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(
                labelText: 'Academic Level',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),


        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ApplicationViewModel>().updateApplication(
                application['id'],
                {
                  'moduleName': moduleController.text,
                  'academicLevel': levelController.text,
                },
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Application updated'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[700],
            ),

            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: Text('Delete ${application['moduleName']} application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(

            onPressed: () {
              context.read<ApplicationViewModel>().deleteApplication(application['id']);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Application deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700], 
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<AuthViewModel>(
                    builder: (context, vm, child) {
                      final email = vm.currentUserEmail ?? 'User';
                      final name = email.split('@').first;
                      return Text(
                        'Welcome, $name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here is your application activity.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Consumer<ApplicationViewModel>(
              builder: (context, vm, child) {
                final total = vm.applications.length;
                final pending = vm.applications.where((app) => app['status'] == 'pending').length;
                final approved = vm.applications.where((app) => app['status'] == 'approved').length;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildSummaryCard('Total', total.toString(), Colors.blueGrey),
                      const SizedBox(width: 12),
                      _buildSummaryCard('Pending', pending.toString(), Colors.orange),
                      const SizedBox(width: 12),
                      _buildSummaryCard('Approved', approved.toString(), Colors.green),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Applications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),


                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: const Text('View All >'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            
            Expanded(
              child: Consumer<ApplicationViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            vm.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),

                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => vm.fetchMyApplications(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[700],
                            ),

                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (vm.applications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No applications yet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),

                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[700],
                            ),
                            child: const Text('Apply Now'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: vm.applications.length,
                    itemBuilder: (context, index) {
                      final app = vm.applications[index];
                      final isPending = app['status'] == 'pending';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[100]!,
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),


                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  child: Text(
                                    app['moduleName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),


                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),


                                  decoration: BoxDecoration(
                                    color: _getStatusColor(app['status'] ?? 'pending').withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    app['status'] ?? 'pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getStatusColor(app['status'] ?? 'pending'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Text(
                              'Level: ${app['academicLevel'] ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  app['submittedDate'] != null
                                      ? 'Submitted: ${_formatDate(app['submittedDate'])}'
                                      : 'Submission date pending',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            if (isPending)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _showEditDialog(context, app),
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Edit'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                  ),

                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () => _showDeleteDialog(context, app),
                                    icon: const Icon(Icons.delete, size: 18),
                                    label: const Text('Delete'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              
                            if (!isPending)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${app['moduleName']} is ${app['status']}'),
                                        backgroundColor: Colors.blueGrey[700],
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('View Details'),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),


        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}