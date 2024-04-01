import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({
    required final VoidCallback onPressedShowCase,
    super.key,
  }) : _onPressedShowCase = onPressedShowCase;

  final VoidCallback _onPressedShowCase;

  @override
  Widget build(final BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final textTheme = Theme.of(context).textTheme;
    final iconSize = isPortrait ? 40.scaledSp : 25.scaledSp;
    final colorTheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final hideWave = isScreenPhone(context) && !isPortrait;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.0.scaledSp,
            ),
          ),
          child: IndependentScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!hideWave)
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
                        Icons.waving_hand_outlined,
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
                        localized(context).showcase_start_title,
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
                        localized(context).showcase_start_desc,
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
                          Navigator.of(context).pop();
                          _onPressedShowCase();
                        },
                        style: getFilledButtonStyle(
                          isPortrait: isPortrait,
                        ).copyWith(
                          fixedSize: MaterialStateProperty.all(
                            Size(
                              isPortrait ? 150.w : 100.w,
                              isFontSizeBig()
                                  ? (isPortrait ? 40.h : 50.h)
                                  : isPortrait
                                      ? 30.h
                                      : 40.h,
                            ),
                          ),
                        ),
                        child: Text(
                          localized(context).showcase_start_confirm,
                          style: getFilledButtonTextStyle(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          localized(context).showcase_start_cancel,
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
          ),
        );
      },
    );
  }
}
