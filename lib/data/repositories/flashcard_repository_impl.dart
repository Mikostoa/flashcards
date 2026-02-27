

import '../../domain/entities/flashcard.dart';
import '../../domain/entities/collection.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/local_datasource.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final LocalDataSource dataSource;

  FlashcardRepositoryImpl(this.dataSource);

  @override
  Future<List<Flashcard>> getFlashcards({int? collectionId}) async {
    return await dataSource.getFlashcards(collectionId: collectionId);
  }

  @override
  Future<void> addFlashcard(Flashcard flashcard) async {
    await dataSource.addFlashcard(flashcard);
  }

  @override
  Future<List<Collection>> getCollections({bool onlyActive = false}) async {
    return await dataSource.getCollections(onlyActive: onlyActive);
  }

  @override
  Future<void> addCollection(Collection collection) async {
    await dataSource.addCollection(collection);
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    await dataSource.updateFlashcard(flashcard);
  }

  @override
  Future<void> updateCollection(Collection collection) async {
    await dataSource.updateCollection(collection);
  }
}


