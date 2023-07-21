import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/screens/construct.dart';
import 'package:forms_helper/screens/import/import_widget.dart';
import 'package:forms_helper/screens/side_menu.dart';
import 'package:forms_helper/screens/storage/storage.dart';

import '../common/themes.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends ConsumerState<HomeWidget> {
  final PageController _pageController = PageController();
  final SideMenuController _menuController = SideMenuController();

  @override
  void initState() {
    ref.read(disciplinesProvider.notifier).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Scaffold(
        body: Row(
          children: [
            MenuWidget(
              pageController: _pageController,
              menuController: _menuController,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  ImportWidget(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  StorageWidget(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  FormConstructor(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  Container(
                    color: Colors.green,
                  ),
                  Container(
                    color: Colors.orange,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
