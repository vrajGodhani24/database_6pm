import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/student_controller.dart';
import 'package:untitled/helper/dbhelper.dart';
import 'package:untitled/model/student.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = '';
    int grid = 0;
    String contact = '';
    int age = 0;

    String updateName = '';
    String updateContact = '';
    int updateAge = 0;

    StudentController studentController = Get.put(StudentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student info"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12),
        child: GetBuilder<StudentController>(builder: (controller) {
          return ListView(
            children: studentController.allStudent
                .map(
                  (e) => Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            "${e.grid}",
                            style: const TextStyle(color: Colors.black),
                          )),
                      title: Text(e.name),
                      subtitle: Text(e.contact),
                      trailing: IconButton(
                        onPressed: () async {
                          // List<Map<String, dynamic>> data = await DBHelper
                          //     .dbHelper
                          //     .fetchSingleStudentData(e.grid);

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 400,
                                  padding: const EdgeInsets.all(25),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (val) {
                                          updateName = val;
                                        },
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: e.name,
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (val) {
                                          updateContact = val;
                                        },
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: e.contact,
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (val) {
                                          updateAge = int.parse(val);
                                        },
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '${e.age}',
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (updateContact == '' &&
                                                  updateAge == 0) {
                                                await DBHelper.dbHelper
                                                    .updateStudentData(
                                                        e.grid,
                                                        updateName,
                                                        e.contact,
                                                        e.age);
                                              } else if (updateName == '' &&
                                                  updateAge == 0) {
                                                await DBHelper.dbHelper
                                                    .updateStudentData(
                                                        e.grid,
                                                        e.name,
                                                        updateContact,
                                                        e.age);
                                              } else {
                                                await DBHelper.dbHelper
                                                    .updateStudentData(
                                                        e.grid,
                                                        e.name,
                                                        e.contact,
                                                        updateAge);
                                              }
                                              studentController.onInit();
                                              Get.back();
                                            },
                                            child: const Text('Done'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });

                          studentController.onInit();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(15),
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      onChanged: (val) {
                        name = val;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your name',
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        grid = int.parse(val);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your GRID',
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        contact = val;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Contact',
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        age = int.parse(val);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Age',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await DBHelper.dbHelper
                                .insertStudentData(name, grid, contact, age)
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                            List<Student> data =
                                await DBHelper.dbHelper.fetchStudentData();
                            studentController.setStudentData(data);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
