import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/config/bottom_navigation_bar_icons.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/l10n/generated/app_localizations.dart';
import 'package:synamyk/ui/core/ui/widgets/curved_bottom_bar/curved_bottom_bar.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   const CustomBottomNavigationBar({super.key, required this.navigationShell});

//   final StatefulNavigationShell navigationShell;

//   @override
//   Widget build(BuildContext context) {
//     return CurvedNavigationBar(
//       index: navigationShell.currentIndex,
//       items: [
//         Column(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.white,
//               ),
//               child: Icon(Icons.add, size: 30),
//             ),
//             Text('Главная'),
//           ],
//         ),
//         Column(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.white,
//               ),
//               child: Icon(Icons.list, size: 30),
//             ),
//             Text('Лента'),
//           ],
//         ),
//         Column(
//           children: [Icon(Icons.compare_arrows, size: 30), Text('Профиль')],
//         ),
//       ],
//       color: Colors.blue,
//       buttonBackgroundColor: Colors.white,
//       backgroundColor: Colors.white,
//       // animationCurve: Curves.bounceIn,
//       animationDuration: Duration(milliseconds: 300),
//       onTap:
//           (index) => navigationShell.goBranch(
//             index,
//             initialLocation: index == navigationShell.currentIndex,
//           ),
//       // height: 75,
//     );
//   }
// }

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
      final l10n = S.of(context);  // ← добавь
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFDFDFDF).withOpacity(0.55),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              CurvedNavigationBar(
                index: navigationShell.currentIndex,
                items: [
                  // Icon(
                  //   SynamykBottomBarStyle.trend_up,
                  //   size: 30,
                  //   color:
                  //       navigationShell.currentIndex == 0
                  //           ? Color(0xFF7B1FA2)
                  //           : Color(0XFFB3B3B3),
                  // )
                  // ,
                  SvgPicture.asset(
                    'assets/icons/navigation_bar/home-2.svg',
                    // color: Colors.red,
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == 0
                          ? Color(0xFF7B1FA2)
                          : Color(0XFFB3B3B3),
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/navigation_bar/ranking.svg',
                    // color: Colors.red,
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == 1
                          ? Color(0xFF7B1FA2)
                          : Color(0XFFB3B3B3),
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/navigation_bar/trend-up.svg',
                    // color: Colors.red,
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == 2
                          ? Color(0xFF7B1FA2)
                          : Color(0XFFB3B3B3),
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/navigation_bar/award.svg',
                    // color: Colors.red,
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == 3
                          ? Color(0xFF7B1FA2)
                          : Color(0XFFB3B3B3),
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/navigation_bar/frame.svg',
                    // color: Colors.red,
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == 4
                          ? Color(0xFF7B1FA2)
                          : Color(0XFFB3B3B3),
                      BlendMode.srcIn,
                    ),
                  ),
                ],

                color: const Color(0xFFFFFFFF),
                // color: Theme.of(context).scaffoldBackgroundColor, //
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // buttonBackgroundColor: const Color(0xFFFFFFFF),
                backgroundColor: Colors.transparent,
                animationDuration: const Duration(milliseconds: 300),
                onTap: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                animationCurve: Curves.easeOutBack,
              ),

              /// ТЕКСТ ВНУТРИ БАРА
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  // spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavLabel(
                      title: l10n.navHome,
                      offsetY: 0,
                      color:
                          navigationShell.currentIndex == 0
                              ? Color(0xFF7B1FA2)
                              : Color(0XFFB3B3B3),
                    ),
                    _NavLabel(
                      title: l10n.navFeed,
                      offsetY: 0,
                      color:
                          navigationShell.currentIndex == 1
                              ? Color(0xFF7B1FA2)
                              : Color(0XFFB3B3B3),
                    ),
                    _NavLabel(
                      title: l10n.navAnalysis,
                      offsetY: 0,
                      color:
                          navigationShell.currentIndex == 2
                              ? Color(0xFF7B1FA2)
                              : Color(0XFFB3B3B3),
                    ),
                    _NavLabel(
                      title: 'Игра',
                      offsetY: 0,
                      color:
                          navigationShell.currentIndex == 3
                              ? Color(0xFF7B1FA2)
                              : Color(0XFFB3B3B3),
                    ),
                    _NavLabel(
                      title: l10n.navProfile,
                      offsetY: 0,
                      color:
                          navigationShell.currentIndex == 4
                              ? Color(0xFF7B1FA2)
                              : Color(0XFFB3B3B3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: const Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}

class _NavLabel extends StatelessWidget {
  const _NavLabel({
    required this.title,
    required this.offsetY,
    required this.color,
  });

  final String title;
  final double offsetY;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
