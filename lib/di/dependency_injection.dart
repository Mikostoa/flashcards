// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../data/datasources/local_datasource.dart';
// import '../data/repositories/flashcard_repository_impl.dart';
// import '../domain/repositories/flashcard_repository.dart';
// import '../domain/usecases/add_flashcard.dart';
// import '../domain/usecases/get_flashcards.dart';
// import '../presentation/viewmodels/flashcard_viewmodel.dart';

// class DependencyInjection {
//   static void init(BuildContext context) {
//     final localDataSource = LocalDataSource();
//     final flashcardRepository = FlashcardRepositoryImpl(localDataSource);
//     final getFlashcards = GetFlashcards(flashcardRepository);
//     final addFlashcard = AddFlashcard(flashcardRepository);

//     Provider.of<FlashcardViewModel>(
//       context,
//       listen: false,
//     ).init(getFlashcards, addFlashcard);
//   }
// }

// extension FlashcardViewModelExtension on FlashcardViewModel {
//   void init(GetFlashcards getFlashcards, AddFlashcard addFlashcard) {
//     this.getFlashcards = getFlashcards;
//     this.addFlashcard = addFlashcard;
//   }
// }
