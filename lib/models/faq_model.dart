class FaqModel {
  final String? createdAt;
  final String? question;
  final String? answer;
  final num? id;
  final num? status;
  final String? updatedAt;

  FaqModel({
    this.createdAt,
    this.question,
    this.answer,
    this.id,
    this.status,
    this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      createdAt: json['createdAt'],
      question: json['question'],
      answer: json['answer'],
      id: json['id'],
      status: json['status'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'question': question,
        'answer': answer,
        'id': id,
        'status': status,
        'updatedAt': updatedAt,
      };
}
