import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/bloc/quill/quill_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class CustomQuillToolbarSearchDialog extends StatefulWidget {
  const CustomQuillToolbarSearchDialog({
    required this.controller,
    this.text,
    super.key,
  });

  final QuillController controller;
  // final QuillDialogTheme? dialogTheme;
  final String? text;

  @override
  State<StatefulWidget> createState() => _CustomQuillToolbarSearchDialogState();
}

class _CustomQuillToolbarSearchDialogState
    extends State<CustomQuillToolbarSearchDialog>
    with SingleTickerProviderStateMixin {
  late String _text;
  late TextEditingController _controller;
  late List<int>? _offsets;
  late int _index;
  bool _caseSensitive = false;
  bool _wholeWord = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _text = widget.text ?? '';
    _offsets = null;
    _index = 0;
    _controller = TextEditingController(text: _text);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    var matchShown = '';
    if (_offsets != null) {
      if (_offsets!.isEmpty) {
        matchShown = '0/0';
      } else {
        matchShown = '${_index + 1}/${_offsets!.length}';
      }
    }

    return BlocListener<CardScreenBloc, CardScreenState>(
      listener: (final context, final state) {
        if (state.isSearchOpened) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: SizeTransition(
        sizeFactor: _animationController,
        axis: Axis.vertical,
        axisAlignment: -1.0,
        child: FlutterQuillLocalizationsWidget(
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              final isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              final iconSize = isPortrait ? 16.scaledSp : 8.scaledSp;
              final customIconSize = isPortrait ? 16.scaledSp : 12.scaledSp;
              final textTheme = Theme.of(context).textTheme;
              return Container(
                height: getTextFieldHeight(
                  isPortrait: isPortrait,
                  hasErrorText: false,
                ),
                padding: EdgeInsets.only(
                  top: isPortrait ? 5.h : 15.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Tooltip(
                      message: context.loc.caseSensitivityAndWholeWordSearch,
                      child: ToggleButtons(
                        onPressed: (final index) {
                          if (index == 0) {
                            _changeCaseSensitivity();
                          } else if (index == 1) {
                            _changeWholeWord();
                          }
                        },
                        borderRadius:
                            BorderRadius.all(Radius.circular(2.0.scaledSp)),
                        isSelected: [_caseSensitive, _wholeWord],
                        children: [
                          Text(
                            '\u0391\u03b1',
                            style: TextStyle(
                              fontFamily: 'MaterialIcons',
                              fontSize: iconSize,
                            ),
                          ),
                          Text(
                            '\u201c\u2026\u201d',
                            style: TextStyle(
                              fontFamily: 'MaterialIcons',
                              fontSize: iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: getTextFieldHeight(
                          isPortrait: isPortrait,
                          hasErrorText: false,
                        ),
                        child: TextField(
                          decoration: getTextFieldDecoration(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ).copyWith(
                            // isDense: true,
                            suffixText: (_offsets != null) ? matchShown : '',
                            hintText: localized(context).card_editor_find_text,
                            suffixIcon: _offsets == null
                                ? IconButton(
                                    onPressed: _findText,
                                    tooltip: context.loc.findText,
                                    icon: Icon(
                                      Icons.search,
                                      size: customIconSize,
                                    ),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0.scaledSp),
                            ),
                          ),
                          style: getTextFieldStyle(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ),
                          autofocus: false,
                          onChanged: _textChanged,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onEditingComplete: _findText,
                          controller: _controller,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    if (_offsets != null)
                      _DialogIconButton(
                        iconData: Icons.keyboard_arrow_up,
                        onPressed:
                            (_offsets!.isNotEmpty) ? _moveToPrevious : null,
                        iconSize: customIconSize,
                        tooltip: context.loc.moveToPreviousOccurrence,
                      ),
                    if (_offsets != null)
                      _DialogIconButton(
                        iconData: Icons.keyboard_arrow_down,
                        onPressed: (_offsets!.isNotEmpty) ? _moveToNext : null,
                        iconSize: customIconSize,
                        tooltip: context.loc.moveToNextOccurrence,
                      ),
                    _DialogIconButton(
                      iconData: Icons.close,
                      onPressed: () => {
                        context.read<CardScreenBloc>().add(SearchClosed()),
                      },
                      iconSize: customIconSize,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _findText() {
    _text = _controller.text;
    if (_text.isEmpty) {
      return;
    }
    setState(() {
      _offsets = widget.controller.document.search(
        _text,
        caseSensitive: _caseSensitive,
        wholeWord: _wholeWord,
      );
      _index = 0;
    });
    if (_offsets!.isNotEmpty) {
      _moveToPosition();
    }
  }

  void _moveToPosition() {
    widget.controller.updateSelection(
      TextSelection(
        baseOffset: _offsets![_index],
        extentOffset: _offsets![_index] + _text.length,
      ),
      ChangeSource.local,
    );
  }

  void _moveToPrevious() {
    if (_offsets!.isEmpty) {
      return;
    }
    setState(() {
      if (_index > 0) {
        _index -= 1;
      } else {
        _index = _offsets!.length - 1;
      }
    });
    _moveToPosition();
  }

  void _moveToNext() {
    if (_offsets!.isEmpty) {
      return;
    }
    setState(() {
      if (_index < _offsets!.length - 1) {
        _index += 1;
      } else {
        _index = 0;
      }
    });
    _moveToPosition();
  }

  void _textChanged(final String value) {
    setState(() {
      _text = value;
      _offsets = null;
      _index = 0;
    });
  }

  void _changeCaseSensitivity() {
    setState(() {
      _caseSensitive = !_caseSensitive;
      _offsets = null;
      _index = 0;
    });
  }

  void _changeWholeWord() {
    setState(() {
      _wholeWord = !_wholeWord;
      _offsets = null;
      _index = 0;
    });
  }
}

class _DialogIconButton extends StatelessWidget {
  const _DialogIconButton({
    required final IconData iconData,
    final VoidCallback? onPressed,
    required final double iconSize,
    final String? tooltip,
  })  : _iconData = iconData,
        _onPressed = onPressed,
        _iconSize = iconSize,
        _tooltip = tooltip;

  final IconData _iconData;
  final VoidCallback? _onPressed;
  final double _iconSize;
  final String? _tooltip;

  @override
  Widget build(final BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 24.scaledSp,
        ),
        child: IconButton(
          onPressed: _onPressed,
          icon: Icon(
            _iconData,
          ),
          iconSize: _iconSize,
          padding: EdgeInsets.only(
            right: 1.5.scaledSp,
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          tooltip: _tooltip,
        ),
      );
}
