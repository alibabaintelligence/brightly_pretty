import 'package:brightly_pretty/providers/manzanares_provider.dart';
import 'package:brightly_pretty/screens/topic_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Schedule the scroll to happen after the layout is fully built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

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
              controller: _scrollController,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400.0,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 34, 82, 241),
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
                        height: 110,
                        width: 110,
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
                        child: SvgPicture.asset(
                          'assets/svgs/crown.svg',
                          height: 60.0,
                          width: 60.0,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ...course.topics.reversed.map(
                        (topic) {
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.shade100,
                                    offset: const Offset(0, 0),
                                    blurRadius: 5,
                                  ),
                                ],
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
                                    color: Color.fromARGB(255, 125, 14, 244),
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    topic.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: const Color.fromARGB(
                                          255, 125, 14, 244),
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
