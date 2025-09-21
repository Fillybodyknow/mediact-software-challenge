import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mediact_app/module/schedule/model/schedule_model.dart';
import 'package:mediact_app/utility/https.dart';
import 'package:mediact_app/utility/notify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ScheduleController extends GetxController {
  RxList<ScheduleModel> scheduleList = RxList<ScheduleModel>([]);

  /// โหลดข้อมูล schedule จาก API
  Future<void> loadMySchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Notify.alert('กรุณาเข้าสู่ระบบ');
      Get.offAllNamed('/login');
      return;
    }

    String scheduleEndpoint = '${Https.developerUrl}/my-schedule';

    try {
      final response = await http
          .get(
            Uri.parse(scheduleEndpoint),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          final data = body['schedule'];

          if (data == null) {
            scheduleList.value = [];
          } else {
            scheduleList.value = (data as List)
                .map<ScheduleModel>((item) => ScheduleModel.fromJson(item))
                .toList();
          }
        } catch (e) {
          await Notify.alert('ข้อมูลไม่ถูกต้องจากเซิร์ฟเวอร์');
          print('JSON Parse Error: $e');
          print('BODY: ${response.body}');
          Get.offAllNamed('/login');
        }
      } else {
        print('Error Response: ${response.body}');
        Notify.alert('โหลดข้อมูลไม่สำเร็จ: ${response.statusCode}');
      }
    } catch (e) {
      await Notify.alert('เกิดข้อผิดพลาดในการโหลดข้อมูล\nerror: $e');
      print(e);
      Get.offAllNamed('/login');
    }
  }

  /// ชื่อวันในสัปดาห์
  final List<String> weekDays = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัส',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์',
  ];

  /// กำหนดสีตามช่วงเวลา
  final Map<String, int> periodRanges = {
    'เช้า': 6,
    'บ่าย': 12,
    'เย็น': 17,
    'ดึก': 21,
  };

  final Map<String, int> periodEndHour = {
    'เช้า': 11,
    'บ่าย': 16,
    'เย็น': 20,
    'ดึก': 5,
  };

  final Map<String, int> periodOrder = {
    'เช้า': 0,
    'บ่าย': 1,
    'เย็น': 2,
    'ดึก': 3,
  };

  final Map<String, String> periodLabels = {
    'เช้า': 'เช้า',
    'บ่าย': 'บ่าย',
    'เย็น': 'เย็น',
    'ดึก': 'ดึก',
  };

  final Map<String, Color> periodColors = {
    'เช้า': Color.fromARGB(255, 144, 238, 144), // สีเขียวอ่อน
    'บ่าย': Color.fromARGB(255, 255, 200, 0), // สีส้ม
    'เย็น': Color.fromARGB(255, 70, 130, 180), // สีฟ้าเข้ม
    'ดึก': Color.fromARGB(255, 138, 43, 226), // สีม่วง
  };

  /// ตรวจสอบช่วงเวลา
  String getPeriod(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 6 && hour <= 11) return 'เช้า';
    if (hour >= 12 && hour <= 16) return 'บ่าย';
    if (hour >= 17 && hour <= 20) return 'เย็น';
    return 'ดึก';
  }

  /// จัด schedule เป็น map ตามวันของสัปดาห์
  Map<String, List<ScheduleModel>> getScheduleByWeek() {
    Map<String, List<ScheduleModel>> scheduleByDate = {};

    for (var s in scheduleList) {
      scheduleByDate[s.date] ??= [];
      scheduleByDate[s.date]!.add(s);
    }

    return scheduleByDate;
  }

  /// หา start ของสัปดาห์ (จันทร์)
  DateTime getStartOfWeek() {
    DateTime now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  /// คืน list วันและ schedule ตามสัปดาห์ปัจจุบัน
  List<Map<String, dynamic>> getWeekSchedule() {
    DateTime monday = getStartOfWeek();
    Map<String, List<ScheduleModel>> scheduleByDate = getScheduleByWeek();

    List<Map<String, dynamic>> weekSchedule = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = monday.add(Duration(days: i));
      String dayStr = DateFormat('yyyy-MM-dd').format(day);
      weekSchedule.add({
        'date': dayStr,
        'weekDay': weekDays[i],
        'schedule': scheduleByDate[dayStr] ?? [],
      });
    }

    return weekSchedule;
  }

  /// คืน list ของสัปดาที่มีเวร
  List<Map<String, dynamic>> getWeeksWithSchedule() {
    Map<int, List<ScheduleModel>> weeksMap = {};

    for (var s in scheduleList) {
      int weekNum = weekNumber(DateTime.parse(s.date));
      weeksMap[weekNum] ??= [];
      weeksMap[weekNum]!.add(s);
    }

    // สร้าง list ของ week ที่มีเวร
    List<Map<String, dynamic>> result = [];

    weeksMap.forEach((weekNum, schedules) {
      if (schedules.isNotEmpty) {
        schedules.sort((a, b) => a.date.compareTo(b.date));
        result.add({'weekNumber': weekNum, 'schedules': schedules});
      }
    });

    result.sort(
      (a, b) => (a['weekNumber'] ?? 0).compareTo(b['weekNumber'] ?? 0),
    );

    return result;
  }

  /// หาเลขสัปดาปีปัจจุบัน
  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    return ((daysPassed + firstDayOfYear.weekday) / 7).ceil();
  }

  String weekDayName(int weekday) {
    return weekDays[weekday - 1]; // DateTime.weekday: จันทร์ = 1
  }

  DateTime getStartOfWeekFromDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  RxInt currentWeekIndex = 0.obs;

  RxInt currentDayIndex = 0.obs;

  void nextWeek(int maxIndex) {
    if (currentWeekIndex.value < maxIndex) {
      currentWeekIndex.value++;
    }
  }

  void prevWeek() {
    if (currentWeekIndex.value > 0) {
      currentWeekIndex.value--;
    }
  }
}
