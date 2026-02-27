import '../entities/collection.dart';
import '../repositories/flashcard_repository.dart';

class AddCollection {
  final FlashcardRepository repository;

  AddCollection(this.repository);

  Future<void> call(Collection collection) async {
    await repository.addCollection(collection);
  }
}
