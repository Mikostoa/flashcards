import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/flashcard_viewmodel.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    viewModel.loadFlashcards();

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.flashcards.isEmpty) {
            return const Center(child: Text('No flashcards available'));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlashcardWidget(
                flashcard: viewModel.flashcards[viewModel.currentIndex],
                isFlipped: viewModel.isFlipped,
                onTap: viewModel.flipCard,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.previousCard,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: viewModel.nextCard,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFlashcardDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFlashcardDialog(BuildContext context) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FlashcardViewModel>(context, listen: false)
                    .addNewFlashcard(
                  questionController.text,
                  answerController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
