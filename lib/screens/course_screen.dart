import 'package:brightly_pretty/providers/manzanares_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';

class CourseScreen extends StatefulWidget {
  static const routeName = '/course-screen';

  const CourseScreen({
    super.key,
    required this.courseId,
  });

  final int courseId;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late final _manzanaresProvider = context.read<ManzanaresProvider>();
  late final _getTopicsFuture = _manzanaresProvider.getTopics(course.courseId);

  Course get course => _manzanaresProvider.courses.firstWhere(
        (course) => course.courseId == widget.courseId,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          course.name,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getTopicsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            print(course.topics);

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...course.topics.map(
                    (topic) => Text(topic.name),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
