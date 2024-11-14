import 'package:brightly_pretty/providers/manzanares_provider.dart';
import 'package:brightly_pretty/screens/topic_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';

class CourseScreen extends StatefulWidget {
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
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400.0,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 600.0,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 123, 213, 255),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: const BoxDecoration(
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(),
                      const SizedBox(height: 50),
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(900),
                          color: Colors.amberAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.shade200,
                              offset: const Offset(0, 0),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ...course.topics.reversed.map(
                        (topic) {
                          print(topic.topicId);

                          final _manzanaresProvider =
                              context.read<ManzanaresProvider>();

                          return CupertinoButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopicScreen(
                                    courseId: course.courseId,
                                    topicId: topic.topicId,
                                  ),
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            minSize: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 125, 14, 244),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 35,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 18,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.book_solid,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    topic.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
