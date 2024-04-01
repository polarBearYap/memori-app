import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/learn_card_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

enum CardMenuItem { previous, next, edit }

class CardMenuAnchor extends StatelessWidget {
  const CardMenuAnchor({
    required final int curStep,
    required final int totalStep,
    required final String cardId,
    super.key,
  })  : _curStep = curStep,
        _totalStep = totalStep,
        _cardId = cardId;

  final int _curStep;
  final int _totalStep;
  final String _cardId;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
          // final iconSize = isPortrait ? 20.scaledSp : 9.scaledSp;
          // final fontSize = isPortrait
          //     ? textTheme.labelSmall!.fontSize!.scaledSp
          //     : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
          return PopupMenuButton<CardMenuItem>(
            icon: Icon(
              Icons.more_vert,
              size: isPortrait ? 20.scaledSp : 12.scaledSp,
            ),
            // offset: Offset(
            //   isPortrait ? -15.w : -5.w,
            //   isPortrait ? 30.h : 50.h,
            // ),
            constraints: getPopupMenuBoxConstraints(),
            offset: getPopupMenuOffset(
              isPortrait: isPortrait,
            ),
            onSelected: (final CardMenuItem item) {
              if (item == CardMenuItem.next) {
                if (_curStep + 1 < _totalStep) {
                  context.read<LearnCardBloc>().add(
                        LearnCardNext(
                          curProgress: _curStep,
                          reviewTime: DateTime.now().toUtc(),
                        ),
                      );
                } else {
                  context.push('/deck/congratulate');
                }
              } else if (item == CardMenuItem.previous) {
                if (_curStep - 1 >= 0) {
                  context.read<LearnCardBloc>().add(
                        LearnCardPrevious(
                          curProgress: _curStep,
                          reviewTime: DateTime.now().toUtc(),
                        ),
                      );
                }
              } else if (item == CardMenuItem.edit) {
                context.read<AddEditCardBloc>().add(
                      AddEditCardFormInit(
                        cardId: _cardId,
                      ),
                    );
                context.push('/card/edit/$_cardId');
              }
            },
            itemBuilder: (final BuildContext context) =>
                <PopupMenuEntry<CardMenuItem>>[
              if (_curStep - 1 >= 0)
                PopupMenuItem<CardMenuItem>(
                  value: CardMenuItem.previous,
                  child: SizedBox(
                    height: getPopupMenuItemHeight(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: getPopupIcon(
                            isPortrait: isPortrait,
                          ),
                        ),
                        SizedBox(
                          width: isPortrait ? 10.w : 5.w,
                        ),
                        Text(
                          localized(context).learn_card_previous_card,
                          style: TextStyle(
                            fontSize: getPopupLabel(
                              isPortrait: isPortrait,
                              textTheme: textTheme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              PopupMenuItem<CardMenuItem>(
                value: CardMenuItem.next,
                child: SizedBox(
                  height: getPopupMenuItemHeight(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: getPopupIcon(
                          isPortrait: isPortrait,
                        ),
                      ),
                      SizedBox(
                        width: isPortrait ? 10.w : 5.w,
                      ),
                      Text(
                        localized(context).learn_card_next_card,
                        style: TextStyle(
                          fontSize: getPopupLabel(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<CardMenuItem>(
                value: CardMenuItem.edit,
                child: SizedBox(
                  height: getPopupMenuItemHeight(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit,
                        size: getPopupIcon(
                          isPortrait: isPortrait,
                        ),
                      ),
                      SizedBox(
                        width: isPortrait ? 10.w : 5.w,
                      ),
                      Text(
                        localized(context).learn_card_edit_card,
                        style: TextStyle(
                          fontSize: getPopupLabel(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
}
