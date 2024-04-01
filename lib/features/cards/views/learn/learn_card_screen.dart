import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/learn_card_bloc.dart';
import 'package:memori_app/features/cards/utils/card_color.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/cards/views/flip_card_screen.dart';
import 'package:memori_app/features/cards/views/learn/card_state_button.dart';
import 'package:memori_app/features/cards/views/learn/card_state_indicator.dart';
import 'package:memori_app/features/cards/views/learn/learn_card_menu.dart';
import 'package:memori_app/features/cards/views/learn/linear_progress_indicator.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/utils/time_passed.dart';
import 'package:memori_app/features/common/views/help_end_dialog.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class LearnCardScreen extends StatefulWidget {
  const LearnCardScreen({super.key});

  @override
  State<LearnCardScreen> createState() => _LearnCardScreenState();
}

class _LearnCardScreenState extends State<LearnCardScreen> {
  late final ScrollController _scrollController;
  bool _flipToFront = true;

  late String _deckName;
  late int _newCount;
  late int _learningCount;
  late int _reviewCount;
  late int _curStep;
  late int _totalStep;

  late String _cardId;
  late Document _frontDocument;
  late Document _backDocument;
  late DateTime? _againNextDue;
  late DateTime? _hardNextDue;
  late DateTime? _goodNextDue;
  late DateTime? _easyNextDue;

  late DateTime? _reviewStartTime;
  late DateTime? _reviewEndTime;

  late bool _isShowcasing;
  late BuildContext _learnCardContext;
  final GlobalKey _learnCardCount = GlobalKey();
  final GlobalKey _learnCardProgress = GlobalKey();
  final GlobalKey _learnCardFrontBack = GlobalKey();
  final GlobalKey _learnCardShowAnswer = GlobalKey();
  final GlobalKey _learnCardReview = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    final learnState = BlocProvider.of<LearnCardBloc>(context).state;
    updateState(learnState);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void updateState(final LearnCardState curState) {
    _deckName = curState.deckName;
    _newCount = curState.newCount;
    _learningCount = curState.learningCount;
    _reviewCount = curState.reviewCount;
    _curStep = curState.curProgress;
    _totalStep = curState.totalProgress;

    _cardId = curState.cardId;
    _frontDocument = curState.front;
    _backDocument = curState.back;
    _againNextDue = curState.againNextDue;
    _hardNextDue = curState.hardNextDue;
    _goodNextDue = curState.goodNextDue;
    _easyNextDue = curState.easyNextDue;

    _reviewStartTime = DateTime.now().toUtc();
    _reviewEndTime = null;

    _flipToFront = true;

    _isShowcasing = curState.isShowcasing;

    initShowcasing();
  }

  void initShowcasing() {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (_isShowcasing) {
        Future.delayed(const Duration(milliseconds: 500), () {
          startShowcaseSequence();
        });
      }
    });
  }

  void startShowcaseSequence() {
    startShowcase(
      _learnCardContext,
      [
        _learnCardCount,
        _learnCardProgress,
      ],
    );
  }

  void startShowcaseCardCount() {
    startShowcase(
      _learnCardContext,
      [
        _learnCardCount,
      ],
    );
  }

  void startShowcaseCardProgress() {
    startShowcase(
      _learnCardContext,
      [
        _learnCardProgress,
      ],
    );
  }

  void startShowcaseCardFrontBack() {
    if (_isShowcasing) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
    Future.delayed(const Duration(milliseconds: 600), () {
      startShowcase(
        _learnCardContext,
        [
          _learnCardFrontBack,
        ],
      );
    });
  }

  void startShowcaseShowAnswer() {
    startShowcase(
      _learnCardContext,
      [
        _learnCardShowAnswer,
      ],
    );
  }

  void startShowcaseReview() {
    _flipCard();
    Future.delayed(const Duration(milliseconds: 900), () {
      startShowcase(
        _learnCardContext,
        [
          _learnCardReview,
        ],
      );
    });
  }

  void endShowcase() {
    showDialog(
      context: context,
      builder: (final BuildContext context) => const HelpEndDialog(),
    );
  }

  void _flipCard() {
    setState(() {
      _flipToFront = !_flipToFront;
    });
  }

  void _rateCard({required final LearnCardRating rating}) {
    if (_curStep + 1 < _totalStep) {
    } else {
      context.push('/deck/congratulate');
    }
    _reviewEndTime = DateTime.now().toUtc();
    context.read<LearnCardBloc>().add(
          LearnCardRated(
            cardId: _cardId,
            rating: rating,
            reviewDurationInMs:
                _reviewEndTime!.difference(_reviewStartTime!).inMilliseconds,
            curProgress: _curStep,
            reviewTime: DateTime.now().toUtc(),
          ),
        );
  }

  Widget _buildProvider({required final Widget child}) =>
      BlocListener<LearnCardBloc, LearnCardState>(
        listener: (final context, final state) {
          setState(() {
            updateState(state);
          });
        },
        child: child,
      );

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = checkIsDarkMode(context: context);

    return _buildProvider(
      child: ShowCaseWidget(
        builder: Builder(
          builder: (final context) {
            _learnCardContext = context;
            return CardScreenScaffold(
              scrollController: _scrollController,
              scrollbarKey: 'learnCardScrollBar',
              appBarTitle: _deckName,
              appBarLeadingWidget: IconButton(
                onPressed: () {
                  context.read<DeckBloc>().add(const DeckReloaded());
                  Navigator.of(context).pop();
                },
                icon: LayoutBuilder(
                  builder: (final context, final constraints) {
                    final isPortrait = MediaQuery.of(context).orientation ==
                        Orientation.portrait;
                    final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
                    return Icon(
                      Icons.arrow_back,
                      size: iconSize,
                    );
                  },
                ),
              ),
              appBarActionWidgets: [
                CardMenuAnchor(
                  cardId: _cardId,
                  curStep: _curStep,
                  totalStep: _totalStep,
                ),
              ],
              bodyWidgets: [
                Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Builder(
                      builder: (final context) {
                        final newChipColor = getNewChipColor(theme);
                        final learningColor =
                            getLearningColor(isDarkMode: isDarkMode);
                        final reviewColor =
                            getReviewColor(isDarkMode: isDarkMode);

                        return CustomShowcaseWidget(
                          title: localized(context).showcase_learn_state_title,
                          desc: localized(context).showcase_learn_state_desc,
                          showcaseKey: _learnCardCount,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.w,
                          ),
                          targetShapeBorder: const RoundedRectangleBorder(),
                          tooltipPosition: TooltipPosition.bottom,
                          onTargetClick: startShowcaseCardProgress,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Spacer(
                                flex: 2,
                              ),
                              CardStateIndicator(
                                cardState:
                                    localized(context).learn_card_state_new,
                                count: _newCount.toString(),
                                color: newChipColor,
                              ),
                              const Spacer(
                                flex: 3,
                              ),
                              CardStateIndicator(
                                cardState: localized(context)
                                    .learn_card_state_learning,
                                count: _learningCount.toString(),
                                color: learningColor,
                              ),
                              const Spacer(
                                flex: 3,
                              ),
                              CardStateIndicator(
                                cardState: localized(context)
                                    .learn_card_state_reviewing,
                                count: _reviewCount.toString(),
                                color: reviewColor,
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomShowcaseWidget(
                      title: localized(context).showcase_learn_progress_title,
                      desc: localized(context).showcase_learn_progress_desc,
                      showcaseKey: _learnCardProgress,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.w,
                      ),
                      targetShapeBorder: const RoundedRectangleBorder(),
                      tooltipPosition: TooltipPosition.bottom,
                      onTargetClick: startShowcaseCardFrontBack,
                      onBarrierClick: startShowcaseCardFrontBack,
                      child: LearningLinearProgressIndicator(
                        currentSteps: _curStep + 1,
                        totalSteps: _totalStep,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomShowcaseWidget(
                      title: _flipToFront
                          ? localized(context).showcase_learn_front_title
                          : localized(context).showcase_learn_back_title,
                      desc: _flipToFront
                          ? localized(context).showcase_learn_front_desc
                          : localized(context).showcase_learn_back_desc,
                      showcaseKey: _learnCardFrontBack,
                      padding: EdgeInsets.symmetric(
                        // horizontal: 5.w,
                        vertical: 5.w,
                      ),
                      targetShapeBorder: const RoundedRectangleBorder(),
                      onTargetClick: startShowcaseShowAnswer,
                      onBarrierClick: startShowcaseShowAnswer,
                      child: FlipCardScreen(
                        flipToFront: _flipToFront,
                        frontDocument: _frontDocument,
                        backDocument: _backDocument,
                        disableEditPopup: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (_flipToFront)
                      CustomShowcaseWidget(
                        title:
                            localized(context).showcase_learn_show_answer_title,
                        desc:
                            localized(context).showcase_learn_show_answer_desc,
                        showcaseKey: _learnCardShowAnswer,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.w,
                        ),
                        targetShapeBorder: const RoundedRectangleBorder(),
                        onTargetClick: startShowcaseReview,
                        child: LayoutBuilder(
                          builder: (final context, final constraints) {
                            final isPortrait =
                                MediaQuery.of(context).orientation ==
                                    Orientation.portrait;
                            final textTheme = Theme.of(context).textTheme;
                            return FilledButton(
                              onPressed: () {
                                if (_isShowcasing) {
                                  startShowcaseReview();
                                } else {
                                  _flipCard();
                                }
                              },
                              style: getFilledButtonStyle(
                                isPortrait: isPortrait,
                              ),
                              child: Text(
                                localized(context).learn_card_show_answer,
                                style: getFilledButtonTextStyle(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (!_flipToFront)
                      CustomShowcaseWidget(
                        title: localized(context).showcase_learn_review_title,
                        desc: localized(context).showcase_learn_review_desc,
                        showcaseKey: _learnCardReview,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.w,
                        ),
                        targetShapeBorder: const RoundedRectangleBorder(),
                        onTargetClick: endShowcase,
                        child: Builder(
                          builder: (final context) {
                            final againColor = getAgainColor(
                              isDarkMode: isDarkMode,
                            );
                            final hardColor = getHardColor(
                              isDarkMode: isDarkMode,
                            );
                            final goodColor = getGoodColor(
                              isDarkMode: isDarkMode,
                            );
                            final easyColor = getEasyColor(
                              isDarkMode: isDarkMode,
                              theme: theme,
                            );
                            final colorOnHover = getColorOnHover(
                              isDarkMode: isDarkMode,
                            );

                            final fontColor = !isDarkMode
                                ? Colors.white
                                : theme.colorScheme.onSurface;

                            return IndependentScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    // width: !isFontSizeBig() ? 5.w : 20.w,
                                    width: 20.w,
                                  ),
                                  CardStateButton(
                                    stateText: localized(context)
                                        .learn_card_feedback_again,
                                    stateDue: getNextReviewTimeDesc(
                                      _againNextDue,
                                      localized(context),
                                    ),
                                    fontColor: fontColor,
                                    backgroundColor: againColor,
                                    backgroundColorOnHover: colorOnHover,
                                    onPressed: () {
                                      if (_isShowcasing) {
                                        endShowcase();
                                      } else {
                                        _rateCard(
                                          rating: LearnCardRating.again,
                                        );
                                      }
                                    },
                                  ),
                                  // if (isFontSizeBig())
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  CardStateButton(
                                    stateText: localized(context)
                                        .learn_card_feedback_hard,
                                    stateDue: getNextReviewTimeDesc(
                                      _hardNextDue,
                                      localized(context),
                                    ),
                                    fontColor: fontColor,
                                    backgroundColor: hardColor,
                                    backgroundColorOnHover: colorOnHover,
                                    onPressed: () {
                                      if (_isShowcasing) {
                                        endShowcase();
                                      } else {
                                        _rateCard(
                                          rating: LearnCardRating.hard,
                                        );
                                      }
                                    },
                                  ),
                                  // if (isFontSizeBig())
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  CardStateButton(
                                    stateText: localized(context)
                                        .learn_card_feedback_good,
                                    stateDue: getNextReviewTimeDesc(
                                      _goodNextDue,
                                      localized(context),
                                    ),
                                    fontColor: fontColor,
                                    backgroundColor: goodColor,
                                    backgroundColorOnHover: colorOnHover,
                                    onPressed: () {
                                      if (_isShowcasing) {
                                        endShowcase();
                                      } else {
                                        _rateCard(
                                          rating: LearnCardRating.good,
                                        );
                                      }
                                    },
                                  ),
                                  // if (isFontSizeBig())
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  CardStateButton(
                                    stateText: localized(context)
                                        .learn_card_feedback_easy,
                                    stateDue: getNextReviewTimeDesc(
                                      _easyNextDue,
                                      localized(context),
                                    ),
                                    fontColor: fontColor,
                                    backgroundColor: easyColor,
                                    backgroundColorOnHover: colorOnHover,
                                    onPressed: () {
                                      if (_isShowcasing) {
                                        endShowcase();
                                      } else {
                                        _rateCard(
                                          rating: LearnCardRating.easy,
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    // width: !isFontSizeBig() ? 5.w : 20.w,
                                    width: 20.w,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
