

import '../entities/flashcard.dart';
import '../entities/collection.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcards({int? collectionId});
  Future<void> addFlashcard(Flashcard flashcard);
  Future<List<Collection>> getCollections({bool onlyActive = false});
  Future<void> addCollection(Collection collection);
  Future<void> updateFlashcard(Flashcard flashcard);
  Future<void> updateCollection(Collection collection);
}


