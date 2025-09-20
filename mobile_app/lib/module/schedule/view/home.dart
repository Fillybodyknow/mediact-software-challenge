import 'package:flutter/material.dart';
import 'package:mediact_app/module/authication/controller/login_controller.dart';
import 'package:mediact_app/module/schedule/view/leave-request.dart';
import 'package:mediact_app/module/schedule/view/my-schedule.dart';
import 'package:mediact_app/utility/textstyle.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [MySchedule(), LeaveRequest()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ระบบจัดเวรพยาบาล',
            style: AppTextStyles.large(color: Colors.white),
          ),
        ),
        foregroundColor: Colors.white, // สีตัวอักษร
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 63, 160, 123),
                Color.fromARGB(255, 110, 204, 168),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() => pages[selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onItemTapped(0),
                  icon: const Icon(Icons.calendar_month, size: 30),
                  label: const SizedBox.shrink(), // ถ้าไม่ต้องการ label
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex.value != 0
                        ? Color.fromARGB(255, 63, 160, 123)
                        : Colors.white,
                    foregroundColor: selectedIndex.value != 0
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onItemTapped(1),
                  icon: const Icon(Icons.assignment_late, size: 30),
                  label: const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex.value != 1
                        ? Color.fromARGB(255, 63, 160, 123)
                        : Colors.white,
                    foregroundColor: selectedIndex.value != 1
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => LoginController().logout(),
                  icon: const Icon(Icons.logout, size: 30),
                  label: const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 63, 160, 123),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
