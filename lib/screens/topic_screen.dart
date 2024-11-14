import 'package:brightly_pretty/widgets/feedback_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/course.dart';
import '../providers/manzanares_provider.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({
    super.key,
    required this.courseId,
    required this.topicId,
  });

  final int courseId;
  final int topicId;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late final _manzanaresProvider = context.read<ManzanaresProvider>();
  late final _getQuestionsFuture = _manzanaresProvider.getQuestions(
    courseId: course.courseId,
    topicId: topic.topicId,
  );

  Course get course => _manzanaresProvider.courses.firstWhere(
        (course) => course.courseId == widget.courseId,
      );

  Topic get topic => course.topics.firstWhere(
        (topic) => topic.topicId == widget.topicId,
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
      body: FutureBuilder(
        future: _getQuestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          print("questions: ${topic.questions}");

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 30.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.desc,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                ...(topic.questions..shuffle()).map(
                  (question) {
                    final _manzanaresProvider =
                        context.read<ManzanaresProvider>();

                    print(question.correctAnswer);

                    return QuestionWidget(question: question);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;

  late final correctAnswer = widget.question.correctAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 218, 182, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.only(
            top: 25,
            bottom: 15,
            left: 10,
            right: 10,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.question_mark_rounded,
                  color: Color.fromARGB(255, 90, 0, 180),
                  size: 18.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    widget.question.question,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: const Color.fromARGB(255, 90, 0, 180),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ...widget.question.availableAnswers.map(
          (ans) => CupertinoButton(
            onPressed: selectedAnswer != null
                ? null
                : () {
                    final player = AudioPlayer();

                    Future.delayed(const Duration(milliseconds: 10), () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (selectedAnswer == correctAnswer) {
                          player.play(AssetSource('audio/win.mp3'));

                          showFeedbackPopup(
                            context,
                            'Correct!',
                            Icons
                                .check_rounded, // Your SVG icon for correct answers
                            Color.fromARGB(255, 0, 177, 68),
                            'assets/sounds/correct.mp3', // Sound for correct answer
                          );
                        } else {
                          showFeedbackPopup(
                            context,
                            'Wrong!',
                            Icons
                                .close_rounded, // Your SVG icon for incorrect answers
                            Color.fromARGB(255, 213, 0, 35),
                            'assets/sounds/wrong.mp3', // Sound for incorrect answer
                          );

                          player.play(AssetSource('audio/fail.mp3'));
                        }
                      });
                    });

                    selectedAnswer = ans.substring(0, 2);

                    setState(() {});
                  },
            padding: EdgeInsets.zero,
            minSize: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: selectedAnswer == ans.substring(0, 2)
                    ? selectedAnswer == correctAnswer
                        ? const Color.fromARGB(255, 128, 255, 155)
                        : const Color.fromARGB(255, 254, 156, 173)
                    : const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 11,
              ),
              child: Expanded(
                child: Text(
                  ans,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
