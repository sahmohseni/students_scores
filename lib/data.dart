import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createdAt;
  final String updatedAt;
  StudentData(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.course,
      required this.score,
      required this.createdAt,
      required this.updatedAt});
  StudentData.parseJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        score = json['score'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}

class HttpClinet {
  static Dio dioInstance =
      Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'));
}

Future<List<StudentData>> getStudents() async {
  final getResponse = await HttpClinet.dioInstance.get('experts/student');
  List<StudentData> studentsList = [];
  if (getResponse.data is List<dynamic>) {
    (getResponse.data as List<dynamic>).forEach((element) {
      studentsList.add(StudentData.parseJson(element));
    });
  }
  print(getResponse.data);
  return studentsList;
}

Future<StudentData> postStudent(
    String firstName, String lastName, String course, int score) async {
  final postResponse = await HttpClinet.dioInstance.post('experts/student',
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "course": course,
        "score": score
      });
  if (postResponse.statusCode == 200) {
    return StudentData.parseJson(postResponse.data);
  } else {
    return throw Exception();
  }
}
