
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetFlashcards {
  final FlashcardRepository repository;

  GetFlashcards(this.repository);

  Future<List<Flashcard>> call({int? collectionId}) async {
    return await repository.getFlashcards(collectionId: collectionId);
  }
}

