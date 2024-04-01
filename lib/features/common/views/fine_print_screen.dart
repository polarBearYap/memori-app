import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(final BuildContext context) => LocalWebViewScreen(
        localAssetPath: 'assets/fine_prints/privacy_policy.html',
        appBarTitle: localized(context).settings_privacy_policy,
      );
}

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(final BuildContext context) => LocalWebViewScreen(
        localAssetPath: 'assets/fine_prints/terms_condition.html',
        appBarTitle: localized(context).settings_terms_of_service,
      );
}

class LocalWebViewScreen extends StatefulWidget {
  const LocalWebViewScreen({
    super.key,
    required final String localAssetPath,
    required final String appBarTitle,
  })  : _localAssetPath = localAssetPath,
        _appBarTitle = appBarTitle;

  final String _localAssetPath;
  final String _appBarTitle;

  @override
  State<StatefulWidget> createState() => _LocalWebViewScreenState();
}

class _LocalWebViewScreenState extends State<LocalWebViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = Theme.of(context).textTheme;
        final fontSize = isPortrait
            ? textTheme.titleMedium!.fontSize!.scaledSp
            : textTheme.titleSmall!.fontSize!.scaledSp * 0.65;
        return Scaffold(
          appBar: AppBar(
            leading: const BackNavigator(),
            leadingWidth: getAppBarLeadingWidth(isPortrait: isPortrait),
            title: Text(
              widget._appBarTitle,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            toolbarHeight: getAppBarHeight(isPortrait: isPortrait),
          ),
          body: BlocBuilder<ThemeBloc, ThemeState>(
            buildWhen: (final previous, final current) =>
                previous.themeMode != current.themeMode,
            builder: (final context, final state) {
              final colorTheme = Theme.of(context).colorScheme;
              final isDarkMode = checkIsDarkMode(context: context);

              controller
                ..loadFlutterAsset(widget._localAssetPath)
                ..setBackgroundColor(
                  isDarkMode ? colorTheme.background : Colors.white,
                )
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageFinished: (final String url) {
                      String textColor = isDarkMode ? '#FFFFFF' : '#000000';
                      double fontSize = isPortrait ? 12.scaledSp : 6.scaledSp;
                      controller.runJavaScript(
                        "document.body.style.color = '$textColor';document.documentElement.style.fontSize = '${fontSize}px';",
                      );
                    },
                  ),
                );

              return WebViewWidget(
                controller: controller,
              );
            },
          ),
        );
      },
    );
  }
}
