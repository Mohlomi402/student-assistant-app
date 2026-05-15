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
import 'package:student_assistant_app/views/application_form.dart';
import '../viewmodels/application_view_model.dart';
import 'package:student_assistant_app/views/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      // ignore: use_build_context_synchronously
      context
          .read<ApplicationViewModel>()
          .fetchMyApplications();
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
    context.watch<ApplicationViewModel>();

    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
        title: const Text(
          "Student Dashboard",
        ),
      ),
      // =====================================================
      // ADD APPLICATION BUTTON
      // =====================================================
      floatingActionButton:
      FloatingActionButton.extended(

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(
              builder: (_) =>
              const ApplicationFormScreen(),
            ),
          ).then((_) {

            vm.fetchMyApplications();
          });
        },

        icon: const Icon(Icons.add),

        label: const Text(
          "Apply",
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: vm.isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : vm.applications.isEmpty

          ? const Center(
        child: Text(
          "No applications submitted yet",
        ),
      )

          : RefreshIndicator(

        onRefresh: () async {

          await vm.fetchMyApplications();
        },

        child: ListView.builder(

          padding:
          const EdgeInsets.all(16),

          itemCount:
          vm.applications.length,

          itemBuilder:
              (context, index) {

            final application =
            vm.applications[index];

            final status =
                application['status']
                    .toString();

            return Card(
             color: Colors.lightBlueAccent,
              elevation: 4,

              margin:
              const EdgeInsets.only(
                bottom: 16,
              ),

              shape:
              RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),

              child: Padding(
                
                padding:
                const EdgeInsets.all(
                  16,
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    // =====================================
                    // HEADER
                    // =====================================
                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        const Text(
                          "Student Assistant Card",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

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
                                "Approved"

                                ? Colors.green

                                : status ==
                                "Rejected"

                                ? Colors.red

                                : Colors.grey,

                            borderRadius:
                            BorderRadius
                                .circular(
                              20,
                            ),
                          ),

                          child: Text(

                            status,

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
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =====================================
                    // YEAR LEVEL
                    // =====================================
                    Text(
                      "Year Level: ${application['year_level']}",
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // =====================================
                    // MODULE 1
                    // =====================================
                    Text(
                      "Module 1: ${application['module1']}",
                    ),

                    Text(
                      "Level: ${application['module1_level']}",
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // =====================================
                    // MODULE 2
                    // =====================================
                    if (application['module2'] !=
                        null &&
                        application['module2']
                            .toString()
                            .isNotEmpty)

                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(
                            "Module 2: ${application['module2']}",
                          ),

                          Text(
                            "Level: ${application['module2_level']}",
                          ),
                        ],
                      ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =====================================
                    // ACTION BUTTONS
                    // =====================================
                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.end,

                      children: [

                       if (status == "pending")
                        IconButton(
                             icon: const Icon(
                             Icons.edit,
                            color: Colors.black45,
                         ),
                           onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (_) => EditApplicationScreen(
                          application: application,
                         ),
                         ),
                        ).then((_) {
                        vm.fetchMyApplications();
                      });
                     },
                     ),
                        // ============================
                        // DELETE BUTTON
                        // ============================
                        IconButton(

                          icon: const Icon(
                            Icons.delete,
                            color:
                            Colors.red,
                          ),

                          onPressed: () async {

                            final confirm =
                            await showDialog<bool>(

                              context:
                              context,

                              builder:
                                  (context) {

                                return AlertDialog(

                                  title:
                                  const Text(
                                    "Delete Application",
                                  ),

                                  content:
                                  const Text(
                                    "Are you sure you want to delete this application?",
                                  ),

                                  actions: [

                                    TextButton(

                                      onPressed:
                                          () {

                                        Navigator.pop(
                                          context,
                                          false,
                                        );
                                      },

                                      child:
                                      const Text(
                                        "Cancel",
                                      ),
                                    ),

                                    ElevatedButton(

                                      onPressed:
                                          () {

                                        Navigator.pop(
                                          context,
                                          true,
                                        );
                                      },

                                      child:
                                      const Text(
                                        "Delete",
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm ==
                                true) {

                              await vm
                                  .deleteApplication(

                                application['id'],
                              );
                            }
                          },
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
    );
  }
}