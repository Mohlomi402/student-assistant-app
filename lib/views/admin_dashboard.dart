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
import '../viewmodels/auth_viewmodel.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {

  String selectedFilter = "all";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<ApplicationViewModel>()
          .fetchAllApplications();
    });
  }

  // =====================================================
  // FILTER APPLICATIONS
  // =====================================================
  List<Map<String, dynamic>>
      filteredApplications(
    List<Map<String, dynamic>> apps,
  ) {

    if (selectedFilter == "all") {
      return apps;
    }

    return apps.where((app) {

      return app['status']
              .toString()
              .toLowerCase() ==
          selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final authVm =
        context.watch<AuthViewModel>();

    // =====================================================
    // SECURITY CHECK
    // =====================================================
    if (authVm.role != 'admin') {

      return const Scaffold(
        body: Center(
          child: Text(
            "Access Denied",
          ),
        ), 
      );
    }

    return Scaffold(

      appBar: AppBar(
       automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,

        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Consumer<ApplicationViewModel>(

        builder: (context, vm, child) {

          if (vm.isLoading) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final apps =
              filteredApplications(
                  vm.applications);

          if (apps.isEmpty) {

            return const Center(
              child: Text(
                "No applications found",
              ),
            );
          }

          return Column(

            children: [

              // =================================================
              // FILTERS
              // =================================================
              Padding(

                padding:
                const EdgeInsets.all(10),

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceEvenly,

                  children: [

                    filterChip("all"),
                    filterChip("pending"),
                    filterChip("approved"),
                    filterChip("rejected"),
                  ],
                ),
              ),

              // =================================================
              // APPLICATIONS LIST
              // =================================================
              Expanded(

                child: ListView.builder(

                  itemCount: apps.length,

                  itemBuilder:
                      (context, index) {

                    final app =
                        apps[index];

                    final status =
                        app['status']
                            .toString()
                            .toLowerCase();

                    return Card(

                      margin:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      elevation: 3,

                      child: Padding(

                        padding:
                        const EdgeInsets
                            .all(15),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            // =====================================
                            // APPLICANT INFO
                            // =====================================
                            Text(
                              "${app['first_name']} ${app['last_name']}",
                              style:
                              const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              "Year Level: ${app['year_level']}",
                            ),

                            Text(
                              "Module 1: ${app['module1']} (${app['module1_level']})",
                            ),

                            Text(
                              "Module 2: ${app['module2'] ?? 'N/A'} (${app['module2_level'] ?? '-'})",
                            ),

                            const SizedBox(
                                height: 10),

                            // =====================================
                            // STATUS
                            // =====================================
                            Container(

                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal:
                                12,
                                vertical: 6,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                status ==
                                    "approved"
                                    ? Colors
                                    .green
                                    : status ==
                                    "rejected"
                                    ? Colors
                                    .red
                                    : Colors
                                    .orange,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                status
                                    .toUpperCase(),

                                style:
                                const TextStyle(
                                  color:
                                  Colors
                                      .white,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 15),

                            // =====================================
                            // VIEW DOCUMENT
                            // =====================================
                            if (app['cv_url'] !=
                                null)

                              TextButton.icon(

                                onPressed: () {

                                  // later:
                                  // open document
                                },

                                icon: const Icon(
                                  Icons
                                      .description,
                                ),

                                label: const Text(
                                  "View Supporting Document",
                                ),
                              ),

                            const Divider(),

                            // =====================================
                            // ACTION BUTTONS
                            // =====================================
                            Row(

                              children: [

                                Expanded(

                                  child:
                                  ElevatedButton(

                                    style:
                                    ElevatedButton
                                        .styleFrom(
                                      backgroundColor:
                                      Colors.green,
                                    ),

                                    onPressed:
                                        () async {

                                      await vm
                                          .updateApplicationStatus(

                                        app['id'],

                                        "approved",
                                      );
                                    },

                                    child:
                                    const Text(
                                      "Approve",
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    width: 10),

                                Expanded(

                                  child:
                                  ElevatedButton(

                                    style:
                                    ElevatedButton
                                        .styleFrom(
                                      backgroundColor:
                                      Colors.red,
                                    ),

                                    onPressed:
                                        () async {

                                      await vm
                                          .updateApplicationStatus(

                                       app['id'], 
                                        "rejected",
                                      );
                                    },

                                    child:
                                    const Text(
                                      "Reject",
                                    ),
                                  ),
                                ),

                                IconButton(

                                  onPressed:
                                      () async {

                                    await vm
                                        .deleteApplication(

                                      app['id'],
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.delete,
                                    color:
                                    Colors.red,
                                  ),
                                ),
                              ],
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
    );
  }

  // =====================================================
  // FILTER CHIP
  // =====================================================
  Widget filterChip(String value) {

    final isSelected =
        selectedFilter == value;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedFilter = value;
        });
      },

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.black
              : Colors.grey[300],

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Text(

          value.toUpperCase(),

          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}