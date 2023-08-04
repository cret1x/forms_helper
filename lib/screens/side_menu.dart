import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forms_helper/google_api/auth.dart';

import '../common/strings.dart';
import '../common/themes.dart';

class MenuWidget extends StatefulWidget {
  final PageController pageController;
  final SideMenuController menuController;

  const MenuWidget({
    required this.pageController,
    required this.menuController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _MenuWidgetState();
  }
}

class _MenuWidgetState extends State<MenuWidget> {
  final GoogleAuthApi _api = GoogleAuthApi();

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
        unselectedIconColor: Theme.of(context).colorScheme.onPrimary,
        selectedIconColor: Theme.of(context).colorScheme.onPrimary,
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
          onTap: (_, __) async {
            bool? res = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: const EdgeInsets.all(12),
                  title: const Text(
                    Strings.confirmLogout,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(Strings.yes),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(Strings.no),
                    ),
                  ],
                );
              },
            );
            if (res == null) {
              return;
            }
            await _api.logout();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
      controller: widget.menuController,
    );
  }

  void _itemFunc(int index, SideMenuController controller) {
    controller.changePage(index);
    widget.pageController.jumpToPage(index);
  }
}
