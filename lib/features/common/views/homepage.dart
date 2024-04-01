import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/bloc/signup_cubit.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/models/showcase_keys.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/views/help_dialog.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/common/views/sync_dialog.dart';
import 'package:memori_app/features/decks/views/deck_screen.dart';
import 'package:memori_app/features/sync/bloc/sync_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void showHelpDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (final BuildContext context) => HelpDialog(
        onPressedShowCase: () {
          ShowcaseKey().isShowcasingAddDeck = true;
          startShowcase(
            ShowcaseKey().scaffoldContext ?? context,
            [
              ShowcaseKey().addFab,
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<SyncBloc, SyncState>(
            listenWhen: (final previous, final current) => current.showInitSync,
            listener: (final context, final state) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (final BuildContext context) => const SyncDialog(),
              );
            },
          ),
          BlocListener<SignUpCubit, bool>(
            listenWhen: (final previous, final current) => current,
            listener: (final context, final state) {
              showHelpDialog(context);
              context
                  .read<SignUpCubit>()
                  .setFirstSignedUp(firstSignedUp: false);
            },
          ),
        ],
        child: BlocBuilder<FontSizeCubit, FontSizeState>(
          builder: (final context, final state) {
            final theme = Theme.of(context);
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = theme.textTheme;
            final fontSize = isPortrait
                ? textTheme.titleLarge!.fontSize!.scaledSp
                : textTheme.titleSmall!.fontSize!.scaledSp;
            final iconSize = isPortrait ? 20.scaledSp : 15.scaledSp;
            /*final textFieldBorder = OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            );*/
            return Padding(
              padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: isFontSizeBig() ? 80.h : (isPortrait ? 40.h : 50.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const MemoriLogo(
                        //   scaleFactor: 0.8,
                        // ),
                        Text(
                          localized(context).deck_title,
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => {
                            context.push('/deck/browse'),
                          },
                          icon: Icon(
                            Icons.search,
                            size: iconSize,
                          ),
                        ),
                        _SyncIconButton(),
                        IconButton(
                          onPressed: () => {
                            showHelpDialog(context),
                          },
                          icon: Icon(
                            Icons.help,
                            size: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  /*
                      TextField(
                        decoration: InputDecoration(
                          border: textFieldBorder,
                          enabledBorder: textFieldBorder,
                          focusedBorder: textFieldBorder,
                          hintText: localized(context).deck_form_search_hint,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (final value) => {},
                      ),
                      SizedBox(
                        height: 15.h,
                      ),*/
                  const Expanded(
                    child: DeckListViewScreen(
                      pageSize: 10,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class _SyncIconButton extends StatefulWidget {
  @override
  State<_SyncIconButton> createState() => _SyncIconButtonState();
}

class _SyncIconButtonState extends State<_SyncIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  bool _checkIsAnimating(final SyncProgress curProgress) {
    switch (curProgress) {
      case SyncProgress.init:
      case SyncProgress.pulledCreate:
      case SyncProgress.pulledUpdate:
      case SyncProgress.pulledDelete:
      case SyncProgress.pushedCreate:
      case SyncProgress.pushedUpdate:
      case SyncProgress.pushedDelete:
        return true;
      case SyncProgress.none:
      case SyncProgress.successful:
      case SyncProgress.conflicted:
      case SyncProgress.failed:
      case SyncProgress.backendNotAvailable:
        return false;
    }
  }

  @override
  Widget build(final BuildContext context) => BlocBuilder<SyncBloc, SyncState>(
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final iconSize = isPortrait ? 20.scaledSp : 15.scaledSp;
            final isDarkMode = checkIsDarkMode(context: context);
            final icon = Icon(
              Icons.sync,
              size: iconSize,
              color: isDarkMode ? Colors.white : Colors.black,
            );
            final isAnimating = _checkIsAnimating(state.curProgress);
            final hoverColor = isDarkMode ? Colors.white24 : Colors.black12;
            return IconButton(
              hoverColor: hoverColor,
              splashColor: hoverColor,
              highlightColor: hoverColor,
              focusColor: hoverColor,
              onPressed: isAnimating
                  ? null
                  : () {
                      context.read<SyncBloc>().add(
                            const SyncInit(
                              overrideLocalWithCloudCopy: false,
                              overrideCloudWithLocalCopy: false,
                            ),
                          );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (final BuildContext context) =>
                            const SyncDialog(),
                      );
                    },
              icon: isAnimating
                  ? RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                      child: icon,
                    )
                  : icon,
            );
          },
        ),
      );
}
