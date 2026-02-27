import 'package:equatable/equatable.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardModel extends Equatable {
  final int? id;
  final String question;
  final String answer;

  const FlashcardModel({this.id, required this.question, required this.answer});

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'] as int?,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  Flashcard toEntity() {
    return Flashcard(id: id, question: question, answer: answer);
  }

  @override
  List<Object?> get props => [id, question, answer];
}
