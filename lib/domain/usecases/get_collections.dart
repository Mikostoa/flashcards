import '../entities/collection.dart';
import '../repositories/flashcard_repository.dart';

class GetCollections {
  final FlashcardRepository repository;

  GetCollections(this.repository);

  Future<List<Collection>> call() async {
    return await repository.getCollections();
  }
}
