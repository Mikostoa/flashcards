import '../entities/collection.dart';
import '../repositories/flashcard_repository.dart';

class UpdateCollection {
  final FlashcardRepository repository;

  UpdateCollection(this.repository);

  Future<void> call(Collection collection) async {
    await repository.updateCollection(collection);
  }
}
