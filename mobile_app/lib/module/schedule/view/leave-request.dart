import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediact_app/module/schedule/controller/leave_request_controller.dart';
import 'package:mediact_app/module/schedule/controller/schedule_controller.dart';
import 'package:mediact_app/module/schedule/model/leave_request_model.dart';
import 'package:mediact_app/utility/textstyle.dart';
import 'package:mediact_app/module/schedule/model/schedule_model.dart';

class LeaveRequest extends StatelessWidget {
  const LeaveRequest({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึง instance ของ controller ที่มีการสร้างไว้แล้ว
    final LeaveRequestController leaveRequestController = Get.put(
      LeaveRequestController(),
    );
    final ScheduleController scheduleController = Get.put(ScheduleController());

    // โหลดข้อมูล schedule ทันทีเมื่อ widget ถูกสร้าง
    scheduleController.loadMySchedule();

    RxInt selectedPage = 0.obs;

    List<Widget> pages = [
      leaveRequestForm(leaveRequestController, scheduleController),
      LeaveRequestHistory(leaveRequestController),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => {selectedPage.value = 0},
                      icon: Icon(
                        Icons.note,
                        size: 30,
                        color: selectedPage.value == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                      label: Text(
                        "ใบแจ้งลา",
                        style: selectedPage.value == 0
                            ? AppTextStyles.small(color: Colors.black)
                            : AppTextStyles.small(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPage.value == 0
                            ? Colors.white
                            : Color.fromARGB(255, 63, 160, 123),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => {selectedPage.value = 1},
                      icon: Icon(
                        Icons.history,
                        size: 30,
                        color: selectedPage.value == 1
                            ? Colors.black
                            : Colors.white,
                      ),
                      label: Text(
                        "ประวัติการลา",
                        style: selectedPage.value == 1
                            ? AppTextStyles.small(color: Colors.black)
                            : AppTextStyles.small(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPage.value == 1
                            ? Colors.white
                            : Color.fromARGB(255, 63, 160, 123),
                        foregroundColor: selectedPage.value == 1
                            ? Colors.white
                            : Color.fromARGB(255, 63, 160, 123),
                        shape: RoundedRectangleBorder(),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              pages[selectedPage.value],
            ],
          ),
        ),
      ),
    );
  }
}

Widget leaveRequestForm(
  LeaveRequestController leaveRequestController,
  ScheduleController scheduleController,
) {
  return SizedBox(
    width: double.infinity,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        // ตรวจสอบว่าข้อมูล schedule โหลดเสร็จหรือยัง
        if (scheduleController.scheduleList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.redAccent),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูลกะทำงาน...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'เลือกกะที่ต้องการลา:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                hint: const Text('กรุณาเลือกกะ'),
                value: leaveRequestController.selectedAssignmentId.value,
                items: scheduleController.scheduleList.map((schedule) {
                  return DropdownMenuItem<int>(
                    value: schedule.id,
                    child: Text(
                      '${schedule.date} - ${schedule.startTime} ถึง ${schedule.endTime}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    leaveRequestController.selectedAssignmentId.value =
                        newValue;
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            // ช่องกรอกเหตุผล
            const Text(
              'เหตุผลในการขอลา:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: TextField(
                maxLines: 5,
                onChanged: (text) => leaveRequestController.reason.value = text,
                decoration: const InputDecoration(
                  hintText: 'กรุณาอธิบายเหตุผลในการขอลา',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // ปุ่มส่งคำขอ
            ElevatedButton.icon(
              onPressed: leaveRequestController.isLoading.value
                  ? null
                  : () {
                      leaveRequestController.SendLeaveRequest();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: leaveRequestController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.send, color: Colors.white),
              label: Text(
                leaveRequestController.isLoading.value
                    ? 'กำลังส่ง...'
                    : 'ส่งคำขอลา',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        );
      }),
    ),
  );
}

Widget LeaveRequestHistory(LeaveRequestController leaveRequestController) {
  return Expanded(
    child: FutureBuilder(
      future: leaveRequestController.fetchNurseLeaveRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final leaveRequests =
              snapshot.data as List<LeaveRequestResponseModel>;
          if (leaveRequests.isEmpty) {
            return const Center(
              child: Text(
                'ไม่พบข้อมูลการลา',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              final leaveRequest = leaveRequests[index];
              String dateOnly = leaveRequest.date.split('T')[0];
              String THStatus = '';
              switch (leaveRequest.status) {
                case 'pending':
                  THStatus = 'รอดำเนินการ';
                  break;
                case 'approved':
                  THStatus = 'อนุมัติ';
                  break;
                case 'rejected':
                  THStatus = 'ไม่อนุมัติ';
                  break;
              }
              final statusColor = _getStatusColor(THStatus);
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              leaveRequest.reason,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              THStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${dateOnly} • ${leaveRequest.startTime} - ${leaveRequest.endTime}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('ไม่พบข้อมูลการลา'));
        }
      },
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'อนุมัติ':
      return Colors.green;
    case 'ไม่อนุมัติ':
      return Colors.red;
    case 'รอดำเนินการ':
      return Colors.orange;
    default:
      return Colors.blueGrey;
  }
}
