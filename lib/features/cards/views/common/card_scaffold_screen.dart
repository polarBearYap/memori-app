import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class CardScreenScaffold extends StatelessWidget {
  final ScrollController _scrollController;
  final String _scrollbarKey;
  final String? _appBarTitle;
  final Widget? _appBarLeadingWidget;
  final List<Widget>? _appBarActionWidgets;
  final List<Widget> _bodyWidgets;
  final double? _toolbarHeight;
  final Widget? _customTitleWidget;
  final double? _titleSpacing;
  final bool _hideAppBar;
  final bool _hideScrollView;

  const CardScreenScaffold({
    required final ScrollController scrollController,
    required final String scrollbarKey,
    required final List<Widget> bodyWidgets,
    final String? appBarTitle,
    final Widget? appBarLeadingWidget,
    final List<Widget>? appBarActionWidgets,
    final double? toolbarHeight,
    final Widget? customTitleWidget,
    final double? titleSpacing,
    final bool hideAppBar = false,
    final bool hideScrollView = false,
    super.key,
  })  : _scrollController = scrollController,
        _scrollbarKey = scrollbarKey,
        _bodyWidgets = bodyWidgets,
        _appBarTitle = appBarTitle,
        _appBarLeadingWidget = appBarLeadingWidget,
        _appBarActionWidgets = appBarActionWidgets,
        _toolbarHeight = toolbarHeight,
        _customTitleWidget = customTitleWidget,
        _titleSpacing = titleSpacing,
        _hideAppBar = hideAppBar,
        _hideScrollView = hideScrollView;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return Scaffold(
            appBar: _hideAppBar
                ? null
                : AppBar(
                    leadingWidth: getAppBarLeadingWidth(isPortrait: isPortrait),
                    toolbarHeight: _toolbarHeight ??
                        getAppBarHeight(isPortrait: isPortrait),
                    leading: _appBarLeadingWidget,
                    title: _customTitleWidget ??
                        (_appBarTitle == null
                            ? null
                            : LayoutBuilder(
                                builder: (final context, final constraints) {
                                  final isPortrait =
                                      MediaQuery.of(context).orientation ==
                                          Orientation.portrait;
                                  final textTheme = Theme.of(context).textTheme;
                                  return Text(
                                    _appBarTitle,
                                    style: TextStyle(
                                      fontSize: isPortrait
                                          ? textTheme
                                              .titleMedium!.fontSize!.scaledSp
                                          : textTheme.titleSmall!.fontSize!
                                                  .scaledSp *
                                              0.6,
                                    ),
                                  );
                                },
                              )),
                    actions: [
                      if (_appBarActionWidgets != null) ..._appBarActionWidgets,
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                    elevation: 10.0,
                    titleSpacing: _titleSpacing,
                  ),
            body: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: _hideScrollView
                    ? Column(
                        children: _bodyWidgets,
                      )
                    : Scrollbar(
                        key: Key(_scrollbarKey),
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: _bodyWidgets,
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      );
}
