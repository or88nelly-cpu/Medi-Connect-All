import 'package:flutter/material.dart';
import 'package:medi_connect/core/common_widgets/background_wrapper.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final AppBar? customAppbar;
  final bool? appBarNeeded;
  final Widget? body;
  final Widget?
  bottomNavigationBar; // Changing type to Widget? to allow premium custom navigations
  final FloatingActionButton? floatingActionButton;
  final Widget? drawer;

  const CustomScaffold({
    super.key,
    this.customAppbar,
    this.appBarNeeded,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBarNeeded == false
              ? null
              : customAppbar ?? const CommonAppBar(),
          drawer: drawer,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
