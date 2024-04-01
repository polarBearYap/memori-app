import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/cards/bloc/card_tag/add_card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/delete_card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/edit_card_tag_bloc.dart';
import 'package:memori_app/features/cards/models/tag_dropdown_option.dart';
import 'package:memori_app/features/cards/views/common/add_card_tag_screen.dart';
import 'package:memori_app/features/cards/views/common/edit_card_tag_screen.dart';
import 'package:memori_app/features/cards/views/common/expandable_form_field.dart';
import 'package:memori_app/features/cards/views/common/selected_tag_chip.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/delete_alert.dart';

class SelectTagDropdown extends StatefulWidget {
  const SelectTagDropdown({
    super.key,
    required final TextEditingController searchController,
    required final List<SelectCardTagDropdownOption> selectedOptions,
    final int pageSize = 10,
  })  : _pageSize = pageSize,
        _searchController = searchController,
        _selectedOptions = selectedOptions;

  final TextEditingController _searchController;
  final List<SelectCardTagDropdownOption> _selectedOptions;
  final int _pageSize;

  @override
  State<StatefulWidget> createState() => _SelectTagDropdownState();
}

class _SelectTagDropdownState extends State<SelectTagDropdown> {
  late ScrollController _scrollController;
  late ScrollController _addMenuScrollController;
  late bool _isLoading;
  late bool _hideLoadingIcon;
  late int _nextPageNumber;
  late List<SelectCardTagDropdownOption> _items;
  late Timer? _rateLimitTimer;
  late bool _displayAddMenu;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _addMenuScrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _initPage();
  }

  @override
  void didUpdateWidget(
    final SelectTagDropdown oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._selectedOptions != oldWidget._selectedOptions) {
      setState(() {
        _initPage();
      });
    }
  }

  void _fetchNextPage() {
    context.read<CardTagBloc>().add(
          CardTagScrolledDown(
            pageNumber: _nextPageNumber,
            pageSize: widget._pageSize,
            searchText: widget._searchController.text,
          ),
        );
  }

  void _refreshPage() {
    setState(() {
      _displayAddMenu = false;
      _nextPageNumber = 0;
      _items = [];
      _isLoading = true;
      _fetchNextPage();
    });
  }

  void _initPage() {
    _displayAddMenu = false;
    _rateLimitTimer = null;
    _hideLoadingIcon = false;
    _nextPageNumber = 0;
    _items = [];
    _isLoading = true;
    _fetchNextPage();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50.h &&
        !_isLoading) {
      if (_rateLimitTimer == null || !_rateLimitTimer!.isActive) {
        _hideLoadingIcon = _items.length < 10;
        _isLoading = true;
        _fetchNextPage();
        _rateLimitTimer = Timer(const Duration(seconds: 2), () {});
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _addMenuScrollController.dispose();
    _rateLimitTimer?.cancel();
    super.dispose();
  }

  void _updateOptionFromList(final String id, final String name) {
    for (int i = 0; i < widget._selectedOptions.length; i++) {
      final option = widget._selectedOptions[i];
      if (option.id == id) {
        widget._selectedOptions[i] = option.copyWith(name: name);
        break;
      }
    }
  }

  void _addOptionToList(final String id, final String name) {
    if (widget._selectedOptions.any((final e) => e.id == id)) {
      _updateOptionFromList(id, name);
      return;
    }
    widget._selectedOptions.add(
      SelectCardTagDropdownOption(
        id: id,
        name: name,
      ),
    );
  }

  void _removeOptionFromList(final String id) {
    for (int i = 0; i < widget._selectedOptions.length; i++) {
      final option = widget._selectedOptions[i];
      if (option.id == id) {
        widget._selectedOptions.removeAt(i);
        break;
      }
    }
  }

  Widget _blocListener({
    required final Widget child,
    required final double scaffoldFontSize,
  }) =>
      MultiBlocListener(
        listeners: [
          BlocListener<CardTagBloc, CardTagState>(
            listener: (final context, final state) {
              if (state.status == CardTagListStatus.forceRefresh) {
                setState(() {
                  _initPage();
                });
                return;
              }
              if (state.status == CardTagListStatus.loading) {
                setState(() {
                  _isLoading = true;
                });
                return;
              }
              // Completed or failed
              if (state.hasNextPage || state.cardTags.isNotEmpty) {
                _nextPageNumber++;
              }
              if (state.status == CardTagListStatus.completed) {
                if (state.totalRecords > 0) {
                  _items.addAll(
                    state.cardTags.map(
                      (final e) => SelectCardTagDropdownOption(
                        id: e.id,
                        name: e.name,
                      ),
                    ),
                  );
                  _displayAddMenu = false;
                } else {
                  _displayAddMenu = true;
                }
              } else if (state.status == CardTagListStatus.failed) {
                showScaledSnackBar(
                  context,
                  localized(context).card_tag_loading_failed,
                );
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
          BlocListener<EditCardTagBloc, EditCardTagState>(
            listener: (final context, final state) {
              if (state.cardTagEditedStatus == FormzSubmissionStatus.success) {
                _updateOptionFromList(state.id, state.cardTagName);
              }
            },
          ),
        ],
        child: child,
      );

  Widget _listBuilder({
    required final double scaffoldFontSize,
    required final double labelFontSize,
    required final double themeScaleFactor,
  }) {
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    final fontColor = colorTheme.onSurface;
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: LayoutBuilder(
        builder: (final context, final constraints) => ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: _items.length + (!_hideLoadingIcon && _isLoading ? 1 : 0),
          itemBuilder: (final context, final index) {
            if (index == _items.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final originalContext = context;
            return Theme(
              data: getDefaultThemeData(
                context: context,
                scaleFactor: themeScaleFactor,
              ),
              child: Slidable(
                closeOnScroll: true,
                direction: Axis.horizontal,
                dragStartBehavior: DragStartBehavior.start,
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (final context) {
                        context.read<EditCardTagBloc>().add(
                              EditCardTagOpened(
                                _items[index].id,
                              ),
                            );
                        showDialog(
                          context: originalContext,
                          builder: (final context) => EditCardTagDialog(
                            cardTagId: _items[index].id,
                          ),
                        );
                      },
                      backgroundColor: colorTheme.tertiaryContainer,
                      foregroundColor: colorTheme.onTertiaryContainer,
                      icon: Icons.badge,
                    ),
                    SlidableAction(
                      onPressed: (final context) => {
                        showDialog(
                          context: originalContext,
                          builder: (final BuildContext context) => BlocListener<
                              DeleteCardTagBloc, DeleteCardTagState>(
                            listenWhen: (final previous, final current) =>
                                current.cardTagDeletedStatus !=
                                    FormzSubmissionStatus.initial &&
                                current.cardTagDeletedStatus !=
                                    FormzSubmissionStatus.inProgress,
                            listener: (final context, final state) {
                              if (state.cardTagDeletedStatus ==
                                  FormzSubmissionStatus.success) {
                                _removeOptionFromList(state.id);
                              }
                              showScaledSnackBar(
                                context,
                                state.cardTagDeletedStatus ==
                                        FormzSubmissionStatus.success
                                    ? localized(context)
                                        .card_tag_delete_successful
                                    : localized(context).card_tag_delete_failed,
                              );
                            },
                            child: DeleteConfirmationDialog(
                              title: localized(context)
                                  .card_tag_delete_confirm_title,
                              content: localized(context)
                                  .card_tag_delete_confirm_desc(
                                _items[index].name,
                              ),
                              confirmText:
                                  localized(context).card_tag_delete_confirm_ok,
                              dismissText:
                                  localized(context).card_tag_save_cancel,
                              onConfirm: () {
                                context.read<DeleteCardTagBloc>().add(
                                      CardTagDeleted(
                                        _items[index].id,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ),
                      },
                      backgroundColor: colorTheme.errorContainer,
                      foregroundColor: colorTheme.onErrorContainer,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (widget._selectedOptions.any(
                          (final e) => e.id == _items[index].id,
                        )) {
                          _removeOptionFromList(
                            _items[index].id,
                          );
                        } else {
                          _addOptionToList(
                            _items[index].id,
                            _items[index].name,
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ), // Adjust padding as needed
                      child: Row(
                        children: <Widget>[
                          Transform.scale(
                            scale: getCheckboxScale(context),
                            child: Checkbox(
                              value: widget._selectedOptions.any(
                                (final option) => option.id == _items[index].id,
                              ),
                              onChanged: (final bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _addOptionToList(
                                      _items[index].id,
                                      _items[index].name,
                                    );
                                  } else {
                                    _removeOptionFromList(_items[index].id);
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Text(
                              _items[index].name,
                              style: TextStyle(
                                color: fontColor,
                                fontSize: labelFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*
                    child: Material(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: widget._selectedOptions
                          .any((final option) => option.id == _items[index].id),
                      onChanged: (final bool? value) {
                        setState(() {
                          if (value == true) {
                            _addOptionToList(_items[index].id, _items[index].name);
                          } else {
                            _removeOptionFromList(_items[index].id);
                          }
                        });
                      },
                      title: Text(
                        _items[index].name,
                        style: TextStyle(
                          color: fontColor,
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                  ),
                    */
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _addMenu({
    required final double addMenuHeight,
    required final double titleFontSize,
    required final double labelFontSize,
    required final double iconSize,
  }) =>
      SizedBox(
        height: addMenuHeight,
        child: SingleChildScrollView(
          controller: _addMenuScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                localized(context).card_tag_not_found_title,
                style: TextStyle(
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              OutlinedButton(
                onPressed: () {
                  context.read<AddCardTagBloc>().add(
                        AddCardTagOpened(
                          widget._searchController.text,
                        ),
                      );
                  showDialog(
                    context: context,
                    builder: (final context) => AddCardTagDialog(
                      text: widget._searchController.text,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: iconSize,
                    ),
                    SizedBox(
                      width: 5.w,
                    ), // Add some spacing between icon and text
                    Text(
                      localized(context).card_tag_add_button,
                      style: TextStyle(
                        fontSize: labelFontSize,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final scaffoldFontSize = isPortrait
              ? textTheme.labelSmall!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp * 0.6;
          final labelFontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
          final factor = FontSizeScale().factorDesc;

          return _blocListener(
            scaffoldFontSize: scaffoldFontSize,
            child: ExpandableFormField(
              iconData: Icons.sell,
              title: widget._selectedOptions.isNotEmpty
                  ? localized(context).card_tag_title_with_selection(
                      widget._selectedOptions.length,
                    )
                  : localized(context).card_tag_title,
              children: <Widget>[
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: factor == FontSizeScaleFactor.biggest
                      ? (isPortrait ? 70.h : 70.h)
                      : factor == FontSizeScaleFactor.bigger
                          ? 50.h
                          : isPortrait
                              ? 35.h
                              : 50.h,
                  child: TextField(
                    controller: widget._searchController,
                    decoration: getTextFieldDecoration(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                      prefixIconData: Icons.search,
                      iconSize: iconSize,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: iconSize,
                        ),
                        onPressed: () {
                          widget._searchController.clear();
                          _refreshPage();
                        },
                      ),
                      hintText: localized(context).card_tag_search_hint_text,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: getTextFieldStyle(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                    ),
                    onChanged: (final value) {
                      _refreshPage();
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  spacing: 5.w,
                  runSpacing: isScreenTablet(context) ? 10.h : 0,
                  children: [
                    ...widget._selectedOptions.map(
                      (final value) => SelectedTagChip(
                        label: value.name,
                        onDelete: () => {
                          setState(() {
                            widget._selectedOptions.remove(value);
                          }),
                        },
                        disableDelete: false,
                      ),
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 300.h,
                  ),
                  padding: EdgeInsets.only(
                    top: 5.h,
                    right: 15.w,
                  ),
                  child: _displayAddMenu
                      ? _addMenu(
                          addMenuHeight: isFontSizeBig()
                              ? 120.h
                              : isPortrait
                                  ? 80.h
                                  : 120.h,
                          titleFontSize: titleFontSize,
                          labelFontSize: labelFontSize,
                          iconSize: iconSize,
                        )
                      : _listBuilder(
                          scaffoldFontSize: scaffoldFontSize,
                          labelFontSize: labelFontSize,
                          themeScaleFactor: 0.7,
                        ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          );
        },
      );
}
