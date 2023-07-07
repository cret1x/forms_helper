import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../common/themes.dart';

class MenuWidget extends StatefulWidget {
  final PageController _pageController;

  const MenuWidget(this._pageController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenuWidgetState();
  }
}

class _MenuWidgetState extends State<MenuWidget> {
  final SideMenuController _sideMenuController = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      style: SideMenuStyle(
        itemBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        itemInnerSpacing: 12,
        itemOuterPadding: EdgeInsets.all(0),
        backgroundColor: Theme.of(context).colorScheme.surface,
        openSideMenuWidth: 250,
        selectedColor: Color.fromRGBO(59, 63, 82, 1),
        hoverColor: Color.fromRGBO(59, 63, 82, 0.4),
        displayMode: SideMenuDisplayMode.compact,
        unselectedIconColor: Theme.of(context).colorScheme.onSurface,
        selectedIconColor: Theme.of(context).colorScheme.onSurface,
        selectedTitleTextStyle: Theme.of(context).textTheme.titleMedium,
        unselectedTitleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
      items: [
        SideMenuItem(
          priority: 0,
          onTap: _itemFunc,
          icon: const Icon(Icons.download),
        ),
        SideMenuItem(
          priority: 1,
          onTap: _itemFunc,
          icon: const Icon(Icons.storage),
        ),
        SideMenuItem(
          priority: 2,
          onTap: _itemFunc,
          icon: const Icon(Icons.construction),
        ),
        SideMenuItem(
          priority: 3,
          onTap: _itemFunc,
          icon: const Icon(Icons.upload),
        ),
        SideMenuItem(
          priority: 4,
          onTap: _itemFunc,
          icon: const Icon(Icons.settings),
        ),
      ],
      controller: _sideMenuController,
    );
  }

  void _itemFunc(int index, SideMenuController controller) {
    controller.changePage(index);
    widget._pageController.jumpToPage(index);
  }
}
