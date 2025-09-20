import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediact_app/module/schedule/controller/schedule_controller.dart';
import 'package:mediact_app/utility/textstyle.dart';

class MySchedule extends StatelessWidget {
  final ScheduleController controller = Get.put(ScheduleController());

  String formatTime(String time) {
    final parts = time.split(':');
    return '${parts[0]}:${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.loadMySchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else {
            return Obx(() {
              final allWeeks = controller.getWeeksWithSchedule();

              if (allWeeks.isEmpty) {
                return const Center(child: Text('ไม่มีเวรในสัปดาห์นี้'));
              }

              final currentWeek = allWeeks[controller.currentWeekIndex.value];

              final weekDays = <DateTime>[];
              final firstDay = controller.getStartOfWeekFromDate(
                DateTime.parse(currentWeek['schedules'][0].date),
              );
              for (int i = 0; i < 7; i++) {
                weekDays.add(firstDay.add(Duration(days: i)));
              }

              final currentDay = weekDays[controller.currentDayIndex.value];
              final dayStr = currentDay.toIso8601String().substring(0, 10);
              final daySchedules = currentWeek['schedules']
                  .where((s) => s.date == dayStr)
                  .toList();

              return Column(
                children: [
                  // Header สัปดาห์
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: controller.currentWeekIndex.value > 0
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: controller.currentWeekIndex.value > 0
                                ? controller.prevWeek
                                : null,
                          ),
                        ),
                        Text(
                          'สัปดาห์ ${currentWeek['weekNumber']}',
                          style: AppTextStyles.header(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color:
                                  controller.currentWeekIndex.value <
                                      allWeeks.length - 1
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed:
                                controller.currentWeekIndex.value <
                                    allWeeks.length - 1
                                ? () => controller.nextWeek(allWeeks.length - 1)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // เนื้อหาเวร
                  Expanded(
                    child: ListView.builder(
                      itemCount: weekDays.length,
                      itemBuilder: (context, index) {
                        final currentDay = weekDays[index];
                        final dayStr = currentDay.toIso8601String().substring(
                          0,
                          10,
                        );
                        final daySchedules = currentWeek['schedules']
                            .where((s) => s.date == dayStr)
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: _buildDayCard(
                            day: currentDay,
                            schedules: daySchedules,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            });
          }
        },
      ),
    );
  }

  Widget _buildDayCard({required DateTime day, required List schedules}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${controller.weekDayName(day.weekday)} (${day.day}/${day.month})',
              style: AppTextStyles.medium(),
            ),
          ),
          schedules.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('วันหยุด', style: TextStyle(color: Colors.grey)),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: schedules.map<Widget>((s) {
                      final period = controller.getPeriod(s.startTime);
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: controller.periodColors[period],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$period: ${formatTime(s.startTime)} - ${formatTime(s.endTime)}',
                          style: AppTextStyles.small(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
