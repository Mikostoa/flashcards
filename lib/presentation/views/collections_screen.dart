

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/collection.dart';
import '../viewmodels/flashcard_viewmodel.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  void _showAddCollectionDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая коллекция'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Название коллекции'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await Provider.of<FlashcardViewModel>(context, listen: false)
                    .addNewCollection(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showAddFlashcardDialog(BuildContext context, int collectionId) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая карточка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(hintText: 'Вопрос'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(hintText: 'Ответ'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                await Provider.of<FlashcardViewModel>(context, listen: false)
                    .addNewFlashcard(
                  questionController.text,
                  answerController.text,
                  collectionId: collectionId,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditCollectionDialog(BuildContext context, Collection collection) {
    final nameController = TextEditingController(text: collection.name);
    bool isActive = collection.isActive;
    final intervalController = TextEditingController(
      text: collection.customIntervalFactor.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Редактировать коллекцию'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Название коллекции'),
              ),
              CheckboxListTile(
                title: const Text('Использовать в обучении'),
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value ?? true;
                  });
                },
              ),
              TextField(
                controller: intervalController,
                decoration: const InputDecoration(hintText: 'Множитель интервала (0.5-2.0)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final updatedCollection = Collection(
                    id: collection.id,
                    name: nameController.text,
                    isActive: isActive,
                    customIntervalFactor: double.tryParse(intervalController.text)?.clamp(0.5, 2.0) ?? 1.0,
                  );
                  await Provider.of<FlashcardViewModel>(context, listen: false)
                      .updateCollection(updatedCollection);
                  Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    viewModel.loadCollections();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллекции'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCollectionDialog(context),
          ),
        ],
      ),
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.collections.isEmpty) {
            return const Center(child: Text('Нет коллекций'));
          }
          return ListView.builder(
            itemCount: viewModel.collections.length,
            itemBuilder: (context, index) {
              final collection = viewModel.collections[index];
              return ListTile(
                title: Text(collection.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddFlashcardDialog(context, collection.id!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditCollectionDialog(context, collection),
                    ),
                  ],
                ),
                onTap: () async {
                  await viewModel.loadFlashcards(collectionId: collection.id);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: viewModel.flashcards.isEmpty
                          ? const Center(child: Text('Нет карточек в коллекции'))
                          : ListView.builder(
                              itemCount: viewModel.flashcards.length,
                              itemBuilder: (context, idx) {
                                final flashcard = viewModel.flashcards[idx];
                                return ListTile(
                                  title: Text(flashcard.question),
                                  subtitle: Text(flashcard.answer),
                                );
                              },
                            ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


