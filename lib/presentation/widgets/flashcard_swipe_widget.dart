import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';
import '../viewmodels/flashcard_viewmodel.dart';

// class FlashcardSwipeWidget extends StatefulWidget {
//   final Flashcard flashcard;
//   final FlashcardViewModel viewModel;

//   const FlashcardSwipeWidget({
//     super.key,
//     required this.flashcard,
//     required this.viewModel,
//   });

//   @override
//   _FlashcardSwipeWidgetState createState() => _FlashcardSwipeWidgetState();
// }

// class _FlashcardSwipeWidgetState extends State<FlashcardSwipeWidget>
//     with SingleTickerProviderStateMixin {
//   double _rotationAngle = 0.0;
//   double _translationX = 0.0;
//   double _scale = 1.0;
//   final double _rotationSensitivity = 0.001;
//   final double _translationSensitivity = 2.0;
//   final double _scaleSensitivity = 2.0;
//   double _buttonOpacity = 0.0;

//   Color _leftButtonColor = Colors.greenAccent.withOpacity(0);
//   Color _rightButtonColor = Colors.purpleAccent.withOpacity(0);

//   late AnimationController _controller;
//   late Animation<double> _translationAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _scaleAnimation;

//   final double _swipeThreshold = 150.0;
//   bool _isSwipingOut = false;
//   bool _isShowingAnswer = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _controller.addListener(() {
//       setState(() {
//         _translationX = _translationAnimation.value;
//         _rotationAngle = _rotationAnimation.value;
//         _scale = _scaleAnimation.value;
//       });
//     });
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed && _isSwipingOut) {
//         _isSwipingOut = false;
//         _isShowingAnswer = false;
//         widget.viewModel.nextCard();
//         _translationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
//           CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//         );
//         _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
//           CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//         );
//         _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//           CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//         );
//         _controller.forward(from: 0.0);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleDragEnd() {
//     if (_translationX.abs() > _swipeThreshold) {
//       _isSwipingOut = true;
//       _translationAnimation = Tween<double>(
//         begin: _translationX,
//         end: _translationX > 0 ? 800.0 : -800.0,
//       ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//       _rotationAnimation = Tween<double>(
//         begin: _rotationAngle,
//         end: _rotationAngle * 2,
//       ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//       _scaleAnimation = Tween<double>(
//         begin: _scale,
//         end: 0.5,
//       ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//     } else {
//       _isSwipingOut = false;
//       _translationAnimation = Tween<double>(begin: _translationX, end: 0.0).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//       );
//       _rotationAnimation = Tween<double>(begin: _rotationAngle, end: 0.0).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//       );
//       _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//       );
//     }
//     _controller.forward(from: 0.0);
//     _leftButtonColor = Colors.greenAccent.withOpacity(0);
//     _rightButtonColor = Colors.purpleAccent.withOpacity(0);
//     _buttonOpacity = 0.0;
//   }

//   void _horizontalDragUpdate(DragUpdateDetails details) {
//     setState(() {
//       _rotationAngle += details.delta.dx * _rotationSensitivity;
//       _rotationAngle = _rotationAngle.clamp(-0.1, 0.1);
//       _translationX += details.delta.dx * _translationSensitivity;
//       _translationX = _translationX.clamp(-200, 200);
//       _buttonOpacity = (_translationX.abs() / _swipeThreshold).clamp(0.0, 1.0);

//       if (_translationX < 0) {
//         _leftButtonColor = Colors.greenAccent.withOpacity(_buttonOpacity);
//         _rightButtonColor = Colors.purpleAccent.withOpacity(0);
//       } else if (_translationX > 0) {
//         _rightButtonColor = Colors.purpleAccent.withOpacity(_buttonOpacity);
//         _leftButtonColor = Colors.greenAccent.withOpacity(0);
//       }

//       if (_translationX <= 0) {
//         if (details.delta.dx > 0) {
//           _scale += (details.delta.dx / 1000).abs() * _scaleSensitivity;
//         } else {
//           _scale -= (details.delta.dx / 1000).abs() * _scaleSensitivity;
//         }
//       } else {
//         if (details.delta.dx < 0) {
//           _scale += (details.delta.dx / 1000).abs() * _scaleSensitivity;
//         } else {
//           _scale -= (details.delta.dx / 1000).abs() * _scaleSensitivity;
//         }
//       }
//       _scale = _scale.clamp(0.80, 1);
//     });
//   }

//   void _toggleCardSide() {
//     setState(() {
//       _isShowingAnswer = !_isShowingAnswer;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onHorizontalDragUpdate: _horizontalDragUpdate,
//         onHorizontalDragEnd: (details) => _handleDragEnd(),
//         onTap: _toggleCardSide,
//         child: Transform(
//           transform: Matrix4.identity()
//             ..scale(_scale)
//             ..translate(_translationX, 0.0)
//             ..rotateZ(_rotationAngle),
//           origin: const Offset(150, 300),
//           child: Container(
//             width: 350,
//             height: 650,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: const Color.fromARGB(255, 41, 41, 41),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     _isShowingAnswer ? widget.flashcard.answer : widget.flashcard.question,
//                     style: const TextStyle(fontSize: 24, color: Colors.white),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   child: Container(
//                     height: 100,
//                     width: 350,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _leftButtonColor,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'Запомнил, отложить для повтора',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _rightButtonColor,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'Показывать это слово еще',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class FlashcardSwipeWidget extends StatefulWidget {
  final Flashcard flashcard;
  final FlashcardViewModel viewModel;

  const FlashcardSwipeWidget({
    super.key,
    required this.flashcard,
    required this.viewModel,
  });

  @override
  _FlashcardSwipeWidgetState createState() => _FlashcardSwipeWidgetState();
}

class _FlashcardSwipeWidgetState extends State<FlashcardSwipeWidget>
    with SingleTickerProviderStateMixin {
  double _rotationAngle = 0.0;
  double _translationX = 0.0;
  double _scale = 1.0;
  final double _rotationSensitivity = 0.001;
  final double _translationSensitivity = 2.0;
  final double _scaleSensitivity = 2.0;
  double _buttonOpacity = 0.0;

  Color _leftButtonColor = Colors.greenAccent.withOpacity(0);
  Color _rightButtonColor = Colors.purpleAccent.withOpacity(0);

  late AnimationController _controller;
  late Animation<double> _translationAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  final double _swipeThreshold = 150.0;
  bool _isSwipingOut = false;
  bool _isShowingAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        _translationX = _translationAnimation.value;
        _rotationAngle = _rotationAnimation.value;
        _scale = _scaleAnimation.value;
      });
    });
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed && _isSwipingOut) {
    //     _isSwipingOut = false;
    //     _isShowingAnswer = false;
    //     // Оценка в зависимости от направления свайпа
    //     final quality = _translationX > 0 ? 4 : 1;
    //     widget.viewModel.rateFlashcard(quality);
    //     widget.viewModel.nextCard();
    //   }
    // });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isSwipingOut) {
        _isSwipingOut = false;
        _isShowingAnswer = false;
        final quality = _translationX > 0 ? 4 : 1;
        widget.viewModel.rateFlashcard(quality);
        widget.viewModel.nextCard();
        _translationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragEnd() {
    if (_translationX.abs() > _swipeThreshold) {
      _isSwipingOut = true;
      _translationAnimation = Tween<double>(
        begin: _translationX,
        end: _translationX > 0 ? 800.0 : -800.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _rotationAnimation = Tween<double>(
        begin: _rotationAngle,
        end: _rotationAngle * 2,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _scaleAnimation = Tween<double>(
        begin: _scale,
        end: 0.5,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    } else {
      _isSwipingOut = false;
      _translationAnimation =
          Tween<double>(begin: _translationX, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _rotationAnimation =
          Tween<double>(begin: _rotationAngle, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    }
    _controller.forward(from: 0.0);
    _leftButtonColor = Colors.greenAccent.withOpacity(0);
    _rightButtonColor = Colors.purpleAccent.withOpacity(0);
    _buttonOpacity = 0.0;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationAngle += details.delta.dx * _rotationSensitivity;
      _rotationAngle = _rotationAngle.clamp(-0.1, 0.1);
      _translationX += details.delta.dx * _translationSensitivity;
      _translationX = _translationX.clamp(-200, 200);
      _buttonOpacity = (_translationX.abs() / _swipeThreshold).clamp(0.0, 1.0);

      if (_translationX < 0) {
        _leftButtonColor = Colors.greenAccent.withOpacity(_buttonOpacity);
        _rightButtonColor = Colors.purpleAccent.withOpacity(0);
      } else if (_translationX > 0) {
        _rightButtonColor = Colors.purpleAccent.withOpacity(_buttonOpacity);
        _leftButtonColor = Colors.greenAccent.withOpacity(0);
      }

      if (_translationX <= 0) {
        if (details.delta.dx > 0) {
          _scale += (details.delta.dx / 1000).abs() * _scaleSensitivity;
        } else {
          _scale -= (details.delta.dx / 1000).abs() * _scaleSensitivity;
        }
      } else {
        if (details.delta.dx < 0) {
          _scale += (details.delta.dx / 1000).abs() * _scaleSensitivity;
        } else {
          _scale -= (details.delta.dx / 1000).abs() * _scaleSensitivity;
        }
      }
      _scale = _scale.clamp(0.80, 1);
    });
  }

  void _toggleCardSide() {
    setState(() {
      _isShowingAnswer = !_isShowingAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onHorizontalDragUpdate: _horizontalDragUpdate,
        onHorizontalDragEnd: (details) => _handleDragEnd(),
        onTap: _toggleCardSide,
        child: Transform(
          transform: Matrix4.identity()
            ..scale(_scale)
            ..translate(_translationX, 0.0)
            ..rotateZ(_rotationAngle),
          origin: const Offset(150, 300),
          child: Container(
            width: 350,
            height: 650,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 41, 41, 41),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    _isShowingAnswer
                        ? widget.flashcard.answer
                        : widget.flashcard.question,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    height: 100,
                    width: 350,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _leftButtonColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Не запомнил',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _rightButtonColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Запомнил',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
