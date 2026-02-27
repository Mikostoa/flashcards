
import '../entities/flashcard.dart';
import '../entities/collection.dart';
import '../repositories/flashcard_repository.dart';

class UpdateFlashcard {
  final FlashcardRepository repository;

  UpdateFlashcard(this.repository);

  Future<void> call(Flashcard flashcard, int quality) async {
    // Параметры алгоритма SM-2
    const double initialEase = 2.5;
    const int minInterval = 1;
    const int maxInterval = 365;

    // Получение коллекции для customIntervalFactor
    final collections = await repository.getCollections();
    final collection = collections.firstWhere(
      (c) => c.id == flashcard.collectionId,
      orElse: () => const Collection(name: '', customIntervalFactor: 1.0),
    );

    // Расчет easiness factor (EF)
    double easeFactor = flashcard.interval == 1 ? initialEase : flashcard.interval.toDouble();
    easeFactor = (easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))).clamp(1.3, 2.5);

    // Расчет нового интервала и даты повторения
    int newInterval;
    DateTime? nextReviewDate;
    if (quality < 3) {
      // При "не запомнил" сохраняем интервал и устанавливаем повторение в тот же день
      newInterval = flashcard.interval;
      nextReviewDate = DateTime.now(); // Повторение в текущий день
    } else {
      // Логика SM-2 для успешных повторений
      if (flashcard.interval == 1) {
        newInterval = 1; // Первый повтор через 1 день
      } else if (flashcard.interval <= 2) {
        newInterval = 6; // Второй повтор через 6 дней
      } else {
        newInterval = (flashcard.interval * easeFactor * collection.customIntervalFactor)
            .round()
            .clamp(minInterval, maxInterval);
      }
      nextReviewDate = DateTime.now().add(Duration(days: newInterval));
    }

    // Обновленная карточка
    final updatedFlashcard = Flashcard(
      id: flashcard.id,
      question: flashcard.question,
      answer: flashcard.answer,
      collectionId: flashcard.collectionId,
      nextReviewDate: nextReviewDate,
      interval: newInterval,
    );

    await repository.updateFlashcard(updatedFlashcard);
  }
}

