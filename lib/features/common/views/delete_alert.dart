import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/alert_dialog.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback _onConfirm;
  final String _title;
  final String _content;
  final String _confirmText;
  final String _dismissText;

  const DeleteConfirmationDialog({
    super.key,
    required final VoidCallback onConfirm,
    required final String title,
    required final String content,
    required final String confirmText,
    required final String dismissText,
  })  : _onConfirm = onConfirm,
        _title = title,
        _content = content,
        _confirmText = confirmText,
        _dismissText = dismissText;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final colorScheme = Theme.of(context).colorScheme;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          return CustomAlertDialog(
            title: Text(
              _title,
              style: getDialogTitle(
                isPortrait: isPortrait,
                textTheme: textTheme,
              ),
            ),
            content: Text(
              _content,
              style: getDialogContent(
                isPortrait: isPortrait,
                textTheme: textTheme,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  _dismissText,
                  style: getDialogLabel(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _onConfirm();
                },
                child: Text(
                  _confirmText,
                  style: getDialogLabel(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ).copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          );
        },
      );
}
