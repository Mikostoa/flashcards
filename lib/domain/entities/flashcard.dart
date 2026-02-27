import 'package:equatable/equatable.dart';

class Flashcard extends Equatable {
  final int? id;
  final String question;
  final String answer;
  final int? collectionId;
  final DateTime? nextReviewDate;
  final int interval;

  const Flashcard({
    this.id,
    required this.question,
    required this.answer,
    this.collectionId,
    this.nextReviewDate,
    this.interval = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'collection_id': collectionId,
      'next_review_date': nextReviewDate?.toIso8601String(),
      'interval': interval,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as int?,
      question: map['question'] as String,
      answer: map['answer'] as String,
      collectionId: map['collection_id'] as int?,
      nextReviewDate: map['next_review_date'] != null
          ? DateTime.parse(map['next_review_date'] as String)
          : null,
      interval: map['interval'] as int? ?? 1,
    );
  }

  @override
  List<Object?> get props =>
      [id, question, answer, collectionId, nextReviewDate, interval];
}

