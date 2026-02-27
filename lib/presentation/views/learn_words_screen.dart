
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/flashcard_viewmodel.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/flashcard_swipe_widget.dart';

class LearnWordsScreen extends StatelessWidget {
  const LearnWordsScreen({super.key});
  static const routeName = '/learn-words-screen';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    viewModel.loadFlashcards();

    return Scaffold(
      appBar: const CustomAppBar(text: 'Учим слова'),
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.flashcards.isEmpty) {
            return const Center(child: Text('Нет карточек для обучения'));
          }
          final currentFlashcard = viewModel.flashcards[viewModel.currentIndex];
          return FlashcardSwipeWidget(
            flashcard: currentFlashcard,
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

