import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';
import 'package:memori_app/features/sync/bloc/sync_bloc.dart';

class SyncDialog extends StatefulWidget {
  const SyncDialog({super.key});

  @override
  State<SyncDialog> createState() => _SyncDialogState();
}

class _SyncDialogState extends State<SyncDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late String _progressText;
  late double _curProgress;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 7,
    ).animate(_animationController);
    _progressText = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final syncProgress = context.read<SyncBloc>().state.curProgress;
    updateState(
      syncProgress,
      context,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeDialog() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void updateState(
    final SyncProgress syncProgress,
    final BuildContext context,
  ) {
    switch (syncProgress) {
      case SyncProgress.none:
        _curProgress = 0;
        _progressText = localized(context).sync_progress_push_data;
        break;
      case SyncProgress.init:
        _curProgress = 0;
        _progressText = localized(context).sync_progress_push_data;
        break;
      case SyncProgress.pushedCreate:
        _progressText = localized(context).sync_progress_push_data;
        _curProgress = 1;
        break;
      case SyncProgress.pushedUpdate:
        _progressText = localized(context).sync_progress_push_data;
        _curProgress = 2;
        break;
      case SyncProgress.pushedDelete:
        _progressText = localized(context).sync_progress_push_data;
        _curProgress = 3;
        break;
      case SyncProgress.pulledCreate:
        _curProgress = 4;
        _progressText = localized(context).sync_progress_pull_data;
        break;
      case SyncProgress.pulledUpdate:
        _curProgress = 5;
        _progressText = localized(context).sync_progress_pull_data;
        break;
      case SyncProgress.pulledDelete:
        _curProgress = 6;
        _progressText = localized(context).sync_progress_pull_data;
        break;
      case SyncProgress.successful:
        _progressText = localized(context).sync_progress_successful;
        _curProgress = 7;
        _closeDialog();
        break;
      case SyncProgress.conflicted:
        _progressText = localized(context).sync_progress_conflicted;
        _curProgress = 7;
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (final BuildContext context) => const SyncConflictDialog(),
          );
        });
        break;
      case SyncProgress.failed:
        _progressText = localized(context).sync_progress_failed;
        _curProgress = 7;
        _closeDialog();
        break;
      case SyncProgress.backendNotAvailable:
        _progressText = localized(context).sync_progress_backend_not_available;
        _curProgress = 7;
        _closeDialog();
        break;
    }
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isDarkMode = checkIsDarkMode(context: context);
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return BlocListener<SyncBloc, SyncState>(
            listenWhen: (final previous, final current) =>
                current.curProgress != SyncProgress.none,
            listener: (final context, final state) {
              setState(() {
                updateState(
                  state.curProgress,
                  context,
                );
                _progressAnimation = Tween<double>(
                  begin: _progressAnimation.value,
                  end: _curProgress,
                ).animate(_animationController);
                _animationController.forward(from: 0.0);
              });
            },
            child: Dialog(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 275.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (final context, final child) =>
                                LinearProgressIndicator(
                              value: _progressAnimation.value,
                              borderRadius:
                                  BorderRadius.circular(20.0.scaledSp),
                              backgroundColor: !isDarkMode
                                  ? Colors.grey[400]
                                  : colorScheme.onBackground,
                              color: !isDarkMode
                                  ? colorScheme.tertiary
                                  : Colors.blue[500],
                              minHeight: 5.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      _progressText,
                      style: getDialogLabel(
                        isPortrait: isPortrait,
                        textTheme: textTheme,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

class SyncConflictDialog extends StatefulWidget {
  const SyncConflictDialog({super.key});

  @override
  State<SyncConflictDialog> createState() => _SyncConflictDialogState();
}

class _SyncConflictDialogState extends State<SyncConflictDialog> {
  late String _selectedSyncValue;

  static const overrideLocalCopy = 'OVERRIDE_LOCAL_COPY_WITH_CLOUD_COPY';
  static const overrideCloudCopy = 'OVERRIDE_CLOUD_COPY_WITH_LOCAL_COPY';

  @override
  void initState() {
    super.initState();
    _selectedSyncValue = overrideLocalCopy;
  }

  @override
  Widget build(final BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final textTheme = Theme.of(context).textTheme;

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
            Container(
              constraints: BoxConstraints(
                maxHeight: 250.h,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 20.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SyncErrorIcon(),
                  SizedBox(
                    width: 20.w,
                  ),
                  Flexible(
                    child: Text(
                      localized(context).sync_conflict_dialog_title,
                      style: getDialogTitle(
                        isPortrait: isPortrait,
                        textTheme: textTheme,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 5.h,
              thickness: 1.sp,
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: _SyncOverrideOption(
                syncLeadingWidget: _SyncDownloadIcon(),
                syncName:
                    localized(context).sync_conflict_dialog_override_local_copy,
                syncValue: overrideLocalCopy,
                selectedSyncValue: _selectedSyncValue,
                onTap: () {
                  setState(() {
                    _selectedSyncValue = overrideLocalCopy;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: _SyncOverrideOption(
                syncLeadingWidget: _SyncUploadIcon(),
                syncName:
                    localized(context).sync_conflict_dialog_override_cloud_copy,
                syncValue: overrideCloudCopy,
                selectedSyncValue: _selectedSyncValue,
                onTap: () {
                  setState(() {
                    _selectedSyncValue = overrideCloudCopy;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Divider(
              height: 5.h,
              thickness: 1.sp,
            ),
            SizedBox(
              height: 10.h,
            ),
            FilledButton(
              onPressed: () {
                context.read<SyncBloc>().add(
                      SyncInit(
                        overrideLocalWithCloudCopy:
                            _selectedSyncValue == overrideLocalCopy,
                        overrideCloudWithLocalCopy:
                            _selectedSyncValue == overrideCloudCopy,
                      ),
                    );
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (final BuildContext context) => const SyncDialog(),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                  ),
                  child: Text(
                    localized(context).sync_conflict_dialog_confirm,
                    textAlign: TextAlign.center,
                    style: getDialogLabel(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                    ),
                  ),
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                ),
                child: Text(
                  localized(context).sync_conflict_dialog_dismiss,
                  textAlign: TextAlign.center,
                  style: getDialogLabel(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncDownloadIcon extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isDarkMode = checkIsDarkMode(context: context);
          final darkFilePrefix = isDarkMode ? '_dark' : '';
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 20.sp : 15.sp;
          return _SyncIcon(
            filename: 'assets/sync_icons/cloud_download$darkFilePrefix.svg',
            iconSize: iconSize,
          );
        },
      );
}

class _SyncUploadIcon extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isDarkMode = checkIsDarkMode(context: context);
          final darkFilePrefix = isDarkMode ? '_dark' : '';
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 20.sp : 15.sp;
          return _SyncIcon(
            filename: 'assets/sync_icons/cloud_upload$darkFilePrefix.svg',
            iconSize: iconSize,
          );
        },
      );
}

class _SyncErrorIcon extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isDarkMode = checkIsDarkMode(context: context);
          final darkFilePrefix = isDarkMode ? '_dark' : '';
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 40.scaledSp : 30.scaledSp;
          return _SyncIcon(
            filename: 'assets/sync_icons/cloud_error$darkFilePrefix.svg',
            iconSize: iconSize,
          );
        },
      );
}

class _SyncIcon extends StatelessWidget {
  const _SyncIcon({
    required final filename,
    required final iconSize,
  })  : _filename = filename,
        _iconSize = iconSize;

  final String _filename;
  final double _iconSize;

  @override
  Widget build(final BuildContext context) => SvgPicture.asset(
        _filename,
        placeholderBuilder: (final BuildContext context) => Container(
          padding: const EdgeInsets.all(30.0),
          child: const CircularProgressIndicator(),
        ),
        width: _iconSize,
      );
}

class _SyncOverrideOption extends StatelessWidget {
  const _SyncOverrideOption({
    required final Widget syncLeadingWidget,
    required final String syncName,
    required final String syncValue,
    required final String selectedSyncValue,
    required final VoidCallback onTap,
  })  : _syncLeadingWidget = syncLeadingWidget,
        _syncName = syncName,
        _syncValue = syncValue,
        _selectedSyncValue = selectedSyncValue,
        _onTap = onTap;

  final Widget _syncLeadingWidget;
  final String _syncName;
  final String _syncValue;
  final String _selectedSyncValue;
  final VoidCallback _onTap;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final textTheme = Theme.of(context).textTheme;
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          return Card(
            child: InkWell(
              onTap: _onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      height: 30.h,
                      child: _syncLeadingWidget,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Text(
                        _syncName,
                        style: getDialogLabel(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Transform.scale(
                      scale: getRadioScale(context),
                      child: Radio(
                        value: _syncValue,
                        groupValue: _selectedSyncValue,
                        onChanged: (final value) {},
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
