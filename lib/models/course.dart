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
  final List<Question> questions;

  Topic({
    required this.topicId,
    required this.name,
    required this.desc,
    this.docLink,
    required this.questions,
  });
}

class Question {
  final int questionId;
  final String question;
  final List<String> availableAnswers;
  final String correctAnswer;

  Question({
    required this.questionId,
    required this.question,
    required this.availableAnswers,
    required this.correctAnswer,
  });
}
