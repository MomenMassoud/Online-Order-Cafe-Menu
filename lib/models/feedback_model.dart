class FeedbackModel {
  final String? feedbackId;
  final String title;
  final String feedback;
  final int dt;

  FeedbackModel({
    this.feedbackId,
    required this.title,
    required this.feedback,
    required this.dt,
  });

  factory FeedbackModel.fromJSON(Map<String, dynamic> map) {
    return FeedbackModel(
      feedbackId: map['id'],
      title: map['title'],
      feedback: map['feedback'],
      dt: map['dt'],
    );
  }
}
