import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/congratulate_card_bloc.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({super.key});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  late final ScrollController _scrollController;
  late int _deckCount;

  @override
  void initState() {
    _scrollController = ScrollController();
    _deckCount = 0;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    final darkFilePrefix = isDarkMode ? '_dark' : '';

    return BlocListener<CongratulateCardBloc, CongratulateCardState>(
      listener: (final context, final state) {
        setState(() {
          _deckCount = state.deckCount;
        });
      },
      child: CardScreenScaffold(
        scrollController: _scrollController,
        scrollbarKey: 'congratulateLearnScrollBar',
        appBarLeadingWidget: null,
        hideAppBar: true,
        bodyWidgets: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: LayoutBuilder(
              builder: (final context, final constraints) {
                final isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                final textTheme = Theme.of(context).textTheme;
                final displaySmall = TextStyle(
                  fontSize: isPortrait
                      ? textTheme.titleLarge!.fontSize!.scaledSp * 1.2
                      : textTheme.titleMedium!.fontSize!.scaledSp,
                );
                final titleMedium = TextStyle(
                  fontSize: isPortrait
                      ? textTheme.bodyMedium!.fontSize!.scaledSp
                      : textTheme.bodySmall!.fontSize!.scaledSp * 0.7,
                );

                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: isPortrait ? 70.h : 30.h,
                    ),
                    // const Spacer(),
                    SvgPicture.asset(
                      'assets/splash_screens/celebrate_screen$darkFilePrefix.svg',
                      placeholderBuilder: (final BuildContext context) =>
                          Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator(),
                      ),
                      width: isPortrait ? 300.w : 125.w,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      localized(context).learn_card_congratulate_title,
                      textAlign: TextAlign.center,
                      style: displaySmall,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      localized(context)
                          .learn_card_congratulate_desc(_deckCount),
                      textAlign: TextAlign.center,
                      style: titleMedium,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    FilledButton(
                      onPressed: () {
                        context.read<DeckBloc>().add(const DeckReloaded());
                        context.go('/home');
                      },
                      style: getFilledButtonStyle(
                        isPortrait: isPortrait,
                      ),
                      child: Text(
                        localized(context).learn_card_congratulate_return_home,
                        style: getFilledButtonTextStyle(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
