class ScheduleModel {
  final int id;
  final String date;
  final String startTime;
  final String endTime;

  ScheduleModel(this.id, this.date, this.startTime, this.endTime);

  ScheduleModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      date = json['date'],
      startTime = json['start_time'],
      endTime = json['end_time'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'start_time': startTime,
    'end_time': endTime,
  };
}
