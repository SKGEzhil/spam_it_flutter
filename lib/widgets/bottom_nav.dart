import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/pages/search_page.dart';

import '../pages/home.dart';
import '../pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {


  final BottomNavController bottom_nav_controller = Get.put(BottomNavController());
  final currentIndex = Get.find<BottomNavController>().currentIndex;
  late Widget currentWidget;


  void setBottomBarIndex(index) {
    bottom_nav_controller.changeIndex(index);
    switch (index) {
      case 0:
        currentWidget = Home();
        break;
      case 1:
        currentWidget = SearchPage();
        break;
      case 2:
        currentWidget = Home();
        break;
      case 3:
        currentWidget = Profile();
        break;
    }
    // Navigator.push(context,
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation1, animation2) => currentWidget,
    //     // transitionDuration: Duration(seconds: 1),
    //     // reverseTransitionDuration: Duration.zero,
    //
    //     transitionsBuilder: (context, animation1, animation2, child) {
    //       const begin = Offset(1.0, 0.0);
    //       const end = Offset.zero;
    //       const curve = Curves.easeInOutCubic;
    //
    //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //
    //       var offsetAnimation = animation1.drive(tween);
    //
    //       return SlideTransition(
    //         position: offsetAnimation,
    //         child: child,
    //       );
    //     },
    //     transitionDuration: Duration(milliseconds: 500),
    //
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: size.width,
        height: 80,
        child: Stack(
          // overflow: Overflow.visible,
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: CustomPaint(
                  size: Size(size.width, 80),
                  painter: BNBCustomPainter(),
                ),
              ),
            ),
            Center(
              heightFactor: 0.6,
              child: SizedBox(
                height: 65,
                child: FittedBox(
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.deepOrangeAccent,
                      child: Icon(Icons.add), elevation: 0.1,
                      onPressed: () {
                        Navigator.pushNamed(context, '/create_post');
                      }
                  ),
                ),
              ),
            ),
            Obx(() {
              return Container(
                width: size.width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(0);
                      },
                      splashColor: Colors.white,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(1);
                        }),
                    Container(
                      width: size.width * 0.20,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.comment,
                          color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(2);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.person,
                          color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(3);
                        }),
                  ],
                ),
              );},
            )
          ],
        ),
      ),
    );

  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // var path = Path();
    // path.lineTo(0.0, size.height - 30);
    //
    // var firstControlPoint = Offset(size.width / 4, size.height);
    // var firstPoint = Offset(size.width / 2, size.height);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstPoint.dx, firstPoint.dy);
    //
    // var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    // var secondPoint = Offset(size.width, size.height - 30);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondPoint.dx, secondPoint.dy);
    //
    // path.lineTo(size.width, 0.0);
    // path.close();

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.8)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

