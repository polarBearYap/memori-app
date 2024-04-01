import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required final Widget title,
    required final Widget content,
    required final List<Widget> actions,
  })  : _title = title,
        _content = content,
        _actions = actions;

  final Widget _title;
  final Widget _content;
  final List<Widget> _actions;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) => Dialog(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20.w,
              20.h,
              20.w,
              isScreenPhone(context) ? 10.h : 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _title,
                SizedBox(
                  height: 20.h,
                ),
                _content,
                SizedBox(
                  height: 20.h,
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ..._actions,
                  ],
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Wrap(
                        children: [
                          ..._actions,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
