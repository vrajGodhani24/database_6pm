import 'package:get/get.dart';
import 'package:untitled/helper/dbhelper.dart';
import 'package:untitled/model/student.dart';

class StudentController extends GetxController {
  List<Student> allStudent = [];

  @override
  void onInit() async {
    super.onInit();

    List<Student> data = await DBHelper.dbHelper.fetchStudentData();
    setStudentData(data);
  }

  void setStudentData(List<Student> students) {
    allStudent = students;
    update();
  }
}
