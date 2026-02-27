

import 'package:flutter/material.dart';
import '../../domain/usecases/update_flashcard.dart';
import '../../domain/usecases/update_collection.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/collection.dart';
import '../../domain/usecases/add_flashcard.dart';
import '../../domain/usecases/get_flashcards.dart';
import '../../domain/usecases/add_collection.dart';
import '../../domain/usecases/get_collections.dart';

class FlashcardViewModel extends ChangeNotifier {
  final GetFlashcards getFlashcards;
  final AddFlashcard addFlashcard;
  final GetCollections getCollections;
  final AddCollection addCollection;
  final UpdateFlashcard updateFlashcard;
  final UpdateCollection updateCollection;
  List<Flashcard> _flashcards = [];
  List<Collection> _collections = [];
  int _currentIndex = 0;
  bool _isFlipped = false;

  FlashcardViewModel(
    this.getFlashcards,
    this.addFlashcard,
    this.getCollections,
    this.addCollection,
    this.updateFlashcard,
    this.updateCollection,
  );

  Future<void> rateFlashcard(int quality) async {
    if (_flashcards.isNotEmpty) {
      final currentFlashcard = _flashcards[_currentIndex];
      await updateFlashcard(currentFlashcard, quality);
      // await loadFlashcards(collectionId: currentFlashcard.collectionId);
      await loadFlashcards();
    }
  }

  List<Flashcard> get flashcards => _flashcards;
  List<Collection> get collections => _collections;
  int get currentIndex => _currentIndex;
  bool get isFlipped => _isFlipped;

  Future<void> loadFlashcards({int? collectionId}) async {
    _flashcards = await getFlashcards(collectionId: collectionId);
    _currentIndex = 0;
    notifyListeners();
  }

  Future<void> loadCollections() async {
    _collections = await getCollections();
    notifyListeners();
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void nextCard() {
    _isFlipped = false;
    _currentIndex = (_currentIndex + 1) % _flashcards.length;
    notifyListeners();
  }

  void previousCard() {
    _isFlipped = false;
    _currentIndex = (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
    notifyListeners();
  }

  Future<void> addNewFlashcard(String question, String answer, {int? collectionId}) async {
    final flashcard = Flashcard(
      question: question,
      answer: answer,
      collectionId: collectionId,
    );
    await addFlashcard(flashcard);
    await loadFlashcards(collectionId: collectionId);
  }

  Future<void> addNewCollection(String name) async {
    final collection = Collection(name: name);
    await addCollection(collection);
    await loadCollections();
  }

  Future<void> updateCollections(Collection collection) async {
    await updateCollection(collection);
    await loadCollections();
  }
}


