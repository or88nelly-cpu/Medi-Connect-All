import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/widgets/scaffold/background_wrapper.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/core/widgets/ads/google_ad_banner.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? customAppbar;
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final showAd = authState is Authenticated && authState.user.role != 'admin';

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: appBarNeeded == false
                  ? null
                  : customAppbar ?? const CommonAppBar(),
              drawer: drawer,
              body: showAd
                  ? Column(
                      children: [
                        Expanded(child: body ?? const SizedBox.shrink()),
                        const GoogleAdBanner(),
                      ],
                    )
                  : body,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
            );
          },
        ),
      ),
    );
  }
}
