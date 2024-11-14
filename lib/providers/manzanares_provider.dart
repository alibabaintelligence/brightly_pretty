import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class ManzanaresUser with ChangeNotifier {
  final int userId;
  final String email;
  final String name;
  final List<int> groups;
  final List<int> finishedTopics;

  ManzanaresUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.groups,
    required this.finishedTopics,
  });
}

class ManzanaresProvider with ChangeNotifier {
  ManzanaresUser? get currentUser => _currentUser;
  ManzanaresUser? _currentUser = null;

  final List<Course> _courses = [];
  List<Course> get courses => [..._courses];

  Future<void> getUser({
    required String email,
  }) async {
    String emailQuery = Uri.encodeQueryComponent(email);

    final url = Uri.parse(
        'http://10.22.140.168:8000/eddata/userdata/?email=$emailQuery');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      print('Respuesta exitosa: $decodedResponse');

      _currentUser = ManzanaresUser(
        userId: decodedResponse['id'],
        email: decodedResponse['email'],
        name: decodedResponse['name'],
        finishedTopics: decodedResponse['finished_topics'],
        groups: [decodedResponse['groups'][0]],
      );

      print(currentUser);

      notifyListeners();
    } else {
      print(response.body);
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> getCourses() async {
    final url = Uri.parse(
        'http://10.22.140.168:8000/eddata/courses-listview/?user_id=${currentUser!.userId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponseMap = json.decode(utf8.decode(response.bodyBytes));
      final course = decodedResponseMap[0];

      _courses.add(
        Course(
          courseId: course['id'],
          name: course['name'],
          desc: course['description'],
          topics: [],
        ),
      );

      notifyListeners();
    } else {
      print(response.body);
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> getTopics(int courseId) async {
    print('GET TOPICS RUNNING');

    final course = _courses.firstWhere(
      (course) => course.courseId == courseId,
    );

    final url = Uri.parse(
        'http://10.22.140.168:8000/eddata/topics-listview/?course_id=$courseId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponseMap = json.decode(utf8.decode(response.bodyBytes));

      print('Respuesta exitosa: $decodedResponseMap');
      print(decodedResponseMap.runtimeType);

      course.topics.clear();

      decodedResponseMap.forEach(
        (topic) {
          course.topics.add(
            Topic(
              topicId: topic['id'],
              name: topic['name'],
              desc: topic['description'],
              quizzes: [],
            ),
          );
        },
      );

      notifyListeners();
    } else {
      print(response.body);
      print('Error: ${response.statusCode}');
    }
  }
}
