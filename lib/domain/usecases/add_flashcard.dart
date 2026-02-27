import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class AddFlashcard {
  final FlashcardRepository repository;

  AddFlashcard(this.repository);

  Future<void> call(Flashcard flashcard) async {
    await repository.addFlashcard(flashcard);
  }
}
