import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/repositories/flashcard_repository_impl.dart';
import 'domain/usecases/add_flashcard.dart';
import 'domain/usecases/get_flashcards.dart';
import 'domain/usecases/add_collection.dart';
import 'domain/usecases/get_collections.dart';
import 'domain/usecases/update_flashcard.dart';
import 'domain/usecases/update_collection.dart';
import 'presentation/viewmodels/flashcard_viewmodel.dart';
import 'presentation/views/collections_screen.dart';
import 'presentation/views/learn_words_screen.dart';
import 'presentation/views/settings_screen.dart';
import 'presentation/widgets/custom_bottom_navigation_bar.dart';
import 'presentation/views/constants/custom_colors.dart';

void main() {
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FlashcardViewModel(
            GetFlashcards(FlashcardRepositoryImpl(LocalDataSource())),
            AddFlashcard(FlashcardRepositoryImpl(LocalDataSource())),
            GetCollections(FlashcardRepositoryImpl(LocalDataSource())),
            AddCollection(FlashcardRepositoryImpl(LocalDataSource())),
            UpdateFlashcard(FlashcardRepositoryImpl(LocalDataSource())),
            UpdateCollection(FlashcardRepositoryImpl(LocalDataSource())),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flashcards App',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: CustomColors.background,
          primaryColor: CustomColors.primary,
          colorScheme: const ColorScheme.dark(
            primary: CustomColors.primary,
            secondary: CustomColors.secondary,
            surface: CustomColors.surface,
            error: CustomColors.error,
            onPrimary: CustomColors.textPrimary,
            onSecondary: CustomColors.textSecondary,
            onSurface: CustomColors.textPrimary,
            onError: CustomColors.textPrimary,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: CustomColors.textPrimary),
            bodyMedium: TextStyle(color: CustomColors.textSecondary),
            headlineSmall: TextStyle(color: CustomColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          cardTheme: CardThemeData(
            color: CustomColors.surface,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: CustomColors.surface,
            foregroundColor: CustomColors.textPrimary,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: CustomColors.primary,
            foregroundColor: CustomColors.textPrimary,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: CustomColors.surface,
            titleTextStyle: const TextStyle(color: CustomColors.textPrimary, fontSize: 20),
            contentTextStyle: const TextStyle(color: CustomColors.textSecondary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [    CollectionsScreen(),    LearnWordsScreen(),    SettingsScreen(),  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          icons: const [
            Icons.collections,
            Icons.school,
            Icons.settings,
          ],
        ),
      ),
    );
  }
}


