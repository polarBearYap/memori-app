import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';

class HelpEndDialog extends StatelessWidget {
  const HelpEndDialog({super.key});

  @override
  Widget build(final BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final textTheme = Theme.of(context).textTheme;
    final iconSize = isPortrait ? 40.scaledSp : 30.scaledSp;
    final colorTheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0.scaledSp,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: isFontSizeBig() ? 150.h : 100.h,
            decoration: BoxDecoration(
              color: colorTheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20.0.scaledSp,
                ),
                topRight: Radius.circular(
                  20.0.scaledSp,
                ),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.celebration_outlined,
                size: iconSize,
                color: colorTheme.onPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20.w,
              0,
              20.w,
              15.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  localized(context).showcase_end_title,
                  style: getDialogTitle(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  localized(context).showcase_end_desc,
                  style: getDialogLabel(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.h,
                ),
                FilledButton(
                  onPressed: () {
                    context.read<DeckBloc>().add(const DeckReloaded());
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                  style: getFilledButtonStyle(
                    isPortrait: isPortrait,
                  ).copyWith(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        isPortrait ? 200.w : 150.w,
                        isFontSizeBig()
                            ? (isPortrait ? 40.h : 50.h)
                            : isPortrait
                                ? 30.h
                                : 40.h,
                      ),
                    ),
                  ),
                  child: Text(
                    localized(context).showcase_end_return_to_home,
                    style: getFilledButtonTextStyle(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
