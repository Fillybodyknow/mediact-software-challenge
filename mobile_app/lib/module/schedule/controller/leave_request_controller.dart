import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mediact_app/module/schedule/model/leave_request_model.dart';
import 'package:mediact_app/utility/https.dart';
import 'package:mediact_app/utility/notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestController extends GetxController {
  RxnInt selectedAssignmentId = RxnInt();
  RxString reason = ''.obs;
  RxBool isLoading = false.obs; // Added: Reactive state for loading

  Future<String> LoadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> SendLeaveRequest() async {
    isLoading.value = true; // Start loading state
    final token = await LoadToken();
    String leaveRequestEndpoint = '${Https.developerUrl}/leave-requests';

    try {
      final response = await http.post(
        Uri.parse(leaveRequestEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'shift_assignment_id': selectedAssignmentId!.value,
          'reason': reason.value,
        }),
      );

      if (response.statusCode == 200) {
        Notify.success('ส่งคําร้องขอลาสําเร็จ', title: 'สําเร็จ');
      } else {
        final errorData = jsonDecode(response.body);
        Notify.alert('${errorData['error']}');
      }
    } catch (e) {
      Notify.alert('เกิดข้อผิดพลาด: $e');
    } finally {
      isLoading.value = false; // Stop loading state
    }
  }

  Future<List<LeaveRequestResponseModel>> fetchNurseLeaveRequests() async {
    final token = await LoadToken();
    String leaveRequestEndpoint =
        '${Https.developerUrl}/leave-requests/history';

    try {
      final response = await http.get(
        Uri.parse(leaveRequestEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body)['leave_requests'] as List<dynamic>;
        return data
            .map((item) => LeaveRequestResponseModel.fromJson(item))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        Notify.alert('${errorData['error']}');
        return [];
      }
    } catch (e) {
      Notify.alert('เกิดข้อผิดพลาด: $e');
      return [];
    }
  }
}
