class Course {
  final int courseId;
  final String name;
  final String desc;
  final List<Topic> topics;

  Course({
    required this.courseId,
    required this.name,
    required this.desc,
    required this.topics,
  });
}

class Topic {
  final int topicId;
  final String name;
  final String desc;
  final String? docLink;
  final List<Quiz> quizzes;

  Topic({
    required this.topicId,
    required this.name,
    required this.desc,
    this.docLink,
    required this.quizzes,
  });
}

class Quiz {
  final int quizId;
  final List<String> availableAnswers;
  final String correctAnswer;

  Quiz({
    required this.quizId,
    required this.availableAnswers,
    required this.correctAnswer,
  });
}
