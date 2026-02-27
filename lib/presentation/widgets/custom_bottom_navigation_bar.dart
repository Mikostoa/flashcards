import 'package:flutter/material.dart';
import '../views/constants/custom_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function onTap;
  final List<IconData> icons;
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
  });
  @override
  _CustomBottomAppBar createState() => _CustomBottomAppBar();
}

class _CustomBottomAppBar extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late List<IconData> _icons;
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  double _currentPosition = 0;

  @override
  void initState() {
    _icons = widget.icons;
    _currentIndex = widget.currentIndex;
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _positionAnimation =
        Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() {
            _currentPosition = _positionAnimation.value;
          });
        });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final screenWidth = MediaQuery.of(context).size.width;
    //   final itemWidth = screenWidth / _icons.length;
    //   _currentPosition = _selectedIndex * itemWidth + (itemWidth - 40) / 2;
    // });
    const screenWidth = 400;
    final itemWidth = screenWidth / _icons.length;
    _currentPosition = _currentIndex * itemWidth + (itemWidth - 60) / 2;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateIndex(int newIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / _icons.length;
    final targetPosition = newIndex * itemWidth + (itemWidth - 60) / 2;

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _positionAnimation = Tween<double>(
      begin: _currentPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);
    setState(() {
      _currentIndex = newIndex;
    });
    widget.onTap(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / _icons.length;

    final isWideScreen = screenWidth > 600;
    final crossAxisCount = isWideScreen ? 2 : 1;

    // Получаем высоту системной навигации
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Если отступа нет (старые Android), добавим небольшой зазор вручную (например, 10-15)
    final safeBottomPadding = bottomPadding > 0 ? bottomPadding : 15.0;

    return Positioned(
      bottom: 0,
      left: 0, 
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        height: 120 + safeBottomPadding,
        padding: EdgeInsets.only(top: 10, bottom: safeBottomPadding),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: Size(screenWidth, 100),
              painter: CurvedNavigationPainter(
                currentPosition: _currentPosition,
                itemWidth: itemWidth,
                itemCount: _icons.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_icons.length, (index) {
                return GestureDetector(
                  onTap: () => _updateIndex(index),
                  child: Opacity(
                    opacity: _currentIndex == index
                        ? _opacityAnimation.value
                        : 1,
                    child: Center(
                      child: SizedBox(
                        width: itemWidth,
                        height: double.infinity,
                        child: Center(
                          child: Icon(
                            _icons[index],
                            color: _currentIndex == index
                                ? Colors.blue
                                : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Positioned(
              left: _currentPosition,
              top: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.primary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _icons[_currentIndex],
                    color: CustomColors.textPrimary,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedNavigationPainter extends CustomPainter {
  final double currentPosition;
  final double itemWidth;
  final int itemCount;

  CurvedNavigationPainter({
    required this.currentPosition,
    required this.itemWidth,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CustomColors.surface
      ..style = PaintingStyle.fill;

    final path = Path();
    const ballRadius = 50.0;
    const cornerRadius = 30.0;

    // Начало с верхнего левого угла
    path.moveTo(cornerRadius, 0);

    final centerX = currentPosition + 30; // Смещение для центра круга

    // Верхняя часть с вырезом
    path.lineTo(centerX - ballRadius - cornerRadius, 0);
    path.arcToPoint(
      Offset(centerX - ballRadius, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(centerX + ballRadius, cornerRadius),
      radius: Radius.circular(ballRadius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(centerX + ballRadius + cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(size.width - cornerRadius, 0);

    // Правый верхний угол
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Правая сторона
    path.lineTo(size.width, size.height - cornerRadius);

    // Правый нижний угол
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Нижняя часть
    path.lineTo(cornerRadius, size.height);

    // Левый нижний угол
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Левая сторона
    path.lineTo(0, cornerRadius);

    // Левый верхний угол
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedNavigationPainter oldDelegate) {
    return oldDelegate.currentPosition != currentPosition;
  }
}
