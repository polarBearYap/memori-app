import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/models/deck_dropdown_option.dart';
import 'package:memori_app/features/cards/views/common/expandable_form_field.dart';
import 'package:memori_app/features/cards/views/common/selected_tag_chip.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';

class SelectDeckDropdown extends StatefulWidget {
  const SelectDeckDropdown({
    super.key,
    required final TextEditingController searchController,
    required final List<SelectDeckDropdownOption> selectedOptions,
    required final bool isSingleSelect,
    final bool isShowcasing = false,
    final VoidCallback? onShowcasing,
    final int pageSize = 10,
    final bool isInitExpanded = false,
    final ExpansionTileController? tileController,
  })  : _pageSize = pageSize,
        _selectedOptions = selectedOptions,
        _searchController = searchController,
        _isSingleSelct = isSingleSelect,
        _isShowcasing = isShowcasing,
        _onShowcasing = onShowcasing,
        _isInitExpanded = isInitExpanded,
        _tileController = tileController;

  final TextEditingController _searchController;
  final List<SelectDeckDropdownOption> _selectedOptions;
  final int _pageSize;
  final bool _isSingleSelct;
  final bool _isShowcasing;
  final VoidCallback? _onShowcasing;
  final bool _isInitExpanded;
  final ExpansionTileController? _tileController;

  @override
  State<StatefulWidget> createState() => _SelectDeckDropdownState();
}

class _SelectDeckDropdownState extends State<SelectDeckDropdown> {
  late ScrollController _scrollController;
  late bool _isLoading;
  late bool _hideLoadingIcon;
  late int _nextPageNumber;
  late List<SelectDeckDropdownOption> _items;
  late Timer? _rateLimitTimer;
  late ExpansionTileController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _initPage();
    _controller = widget._tileController ?? ExpansionTileController();
  }

  @override
  void didUpdateWidget(
    final SelectDeckDropdown oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._selectedOptions != oldWidget._selectedOptions &&
        widget._isShowcasing != oldWidget._isShowcasing) {
      setState(() {
        _initPage();
      });
    }
  }

  void _fetchNextPage() {
    context.read<DeckBloc>().add(
          DeckScrolledDown(
            eventSource: DeckScrollEventSource.formfield,
            pageNumber: _nextPageNumber,
            pageSize: widget._pageSize,
            searchText: widget._searchController.text,
          ),
        );
  }

  void _refreshPage() {
    setState(() {
      _nextPageNumber = 0;
      _items = [];
      _isLoading = true;
      _fetchNextPage();
    });
  }

  void _initPage() {
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
    _rateLimitTimer?.cancel();
    super.dispose();
  }

  void _updateOptionFromList(final String id, final String name) {
    for (int i = 0; i < widget._selectedOptions.length; i++) {
      final option = widget._selectedOptions[i];
      if (option.id == id) {
        widget._selectedOptions[i] = option.copyWith(deckName: name);
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
      SelectDeckDropdownOption(
        id: id,
        deckName: name,
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

  void _startShowcasing() {
    if (widget._isShowcasing) {
      widget._onShowcasing?.call();
    }
  }

  Widget _blocListener({
    required final Widget child,
    required final double scaffoldFontSize,
  }) =>
      BlocListener<DeckBloc, DeckState>(
        listenWhen: (final previous, final current) =>
            current.eventSource == DeckScrollEventSource.formfield ||
            current.eventSource == DeckScrollEventSource.all,
        listener: (final context, final state) {
          if (state.status == DeckListStatus.forceRefresh) {
            setState(() {
              _initPage();
            });
            return;
          }
          if (state.status == DeckListStatus.loading) {
            setState(() {
              _isLoading = true;
            });
            return;
          }
          // Completed or failed
          if (state.hasNextPage || state.decks.isNotEmpty) {
            _nextPageNumber++;
          }
          if (state.status == DeckListStatus.completed) {
            _items.addAll(
              state.decks.map(
                (final e) => SelectDeckDropdownOption(
                  id: e.id,
                  deckName: e.deckName,
                ),
              ),
            );
          } else if (state.status == DeckListStatus.failed) {
            showScaledSnackBar(
              context,
              localized(context).deck_loading_failed,
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        child: child,
      );

  @override
  Widget build(final BuildContext context) {
    final fontColor = Theme.of(context).colorScheme.onSurface;
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = Theme.of(context).textTheme;
        final scaffoldFontSize = isPortrait
            ? textTheme.labelSmall!.fontSize!.scaledSp
            : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
        final labelFontSize = isPortrait
            ? textTheme.labelMedium!.fontSize!.scaledSp
            : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
        final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
        final factor = FontSizeScale().factorDesc;

        return _blocListener(
          scaffoldFontSize: scaffoldFontSize,
          child: ExpandableFormField(
            isInitExpanded: widget._isInitExpanded,
            tileController: _controller,
            iconData: Icons.folder,
            title: () {
              if (widget._isSingleSelct) {
                if (widget._selectedOptions.isEmpty ||
                    widget._selectedOptions[0].id.isEmpty) {
                  return localized(context).deck_form_title;
                } else {
                  return widget._selectedOptions[0].deckName;
                }
              } else {
                if (widget._selectedOptions.isEmpty ||
                    widget._selectedOptions[0].id.isEmpty) {
                  return localized(context).deck_form_title;
                } else {
                  return localized(context).deck_form_title_with_selection(
                    widget._selectedOptions.length,
                  );
                }
              }
            }(),
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
                    hintText: localized(context).deck_form_search_hint,
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
              if (!widget._isSingleSelct)
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: Wrap(
                    spacing: 5.w,
                    runSpacing: isFontSizeBig() ? 10.h : 0,
                    children: [
                      ...widget._selectedOptions.map(
                        (final value) => SelectedTagChip(
                          label: value.deckName,
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
                ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 300.h,
                ),
                padding: EdgeInsets.only(
                  top: 10.h,
                  right: 15.w,
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _items.length +
                        (!_hideLoadingIcon && _isLoading ? 1 : 0),
                    itemBuilder: (final context, final index) {
                      if (index == _items.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (widget._isSingleSelct) {
                        return Material(
                          key: Key(_items[index].id),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (widget._selectedOptions.isEmpty) {
                                  widget._selectedOptions.add(
                                    SelectDeckDropdownOption(
                                      id: _items[index].id,
                                      deckName: _items[index].deckName,
                                    ),
                                  );
                                } else {
                                  widget._selectedOptions[0].id =
                                      _items[index].id;
                                  widget._selectedOptions[0].deckName =
                                      _items[index].deckName;
                                }
                                _startShowcasing();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.w,
                                horizontal: isScreenPhone(context) ? 0 : 8.w,
                              ), // Adjust padding as needed
                              child: Row(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: getRadioScale(context),
                                    child: Radio<String>(
                                      value: _items[index].id,
                                      groupValue:
                                          widget._selectedOptions.isNotEmpty
                                              ? widget._selectedOptions[0].id
                                              : '',
                                      onChanged: (final String? value) {
                                        setState(() {
                                          if (widget._selectedOptions.isEmpty) {
                                            widget._selectedOptions.add(
                                              SelectDeckDropdownOption(
                                                id: '',
                                                deckName: '',
                                              ),
                                            );
                                          }
                                          widget._selectedOptions[0].id =
                                              value.toString();
                                          widget._selectedOptions[0].deckName =
                                              _items[index].deckName;
                                          _startShowcasing();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _items[index].deckName,
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
                        );
                      }
                      return Material(
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
                                  _items[index].deckName,
                                );
                              }
                              _startShowcasing();
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
                                      (final option) =>
                                          option.id == _items[index].id,
                                    ),
                                    onChanged: (final bool? value) {
                                      setState(() {
                                        if (value != null && value) {
                                          _addOptionToList(
                                            _items[index].id,
                                            _items[index].deckName,
                                          );
                                        } else {
                                          _removeOptionFromList(
                                            _items[index].id,
                                          );
                                        }
                                        _startShowcasing();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Text(
                                    _items[index].deckName,
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
                      );
                      /*
                      return Material(
                        key: Key(_items[index].id),
                        child: () {
                          if (widget._isSingleSelct) {
                            return RadioListTile(
                              value: _items[index].id,
                              groupValue: widget._selectedOptions.isNotEmpty
                                  ? widget._selectedOptions[0].id
                                  : '',
                              onChanged: (final value) => {
                                setState(() {
                                  if (widget._selectedOptions.isEmpty) {
                                    widget._selectedOptions.add(
                                      SelectDeckDropdownOption(
                                        id: '',
                                        deckName: '',
                                      ),
                                    );
                                  }
                                  widget._selectedOptions[0].id = value.toString();
                                  widget._selectedOptions[0].deckName =
                                      _items[index].deckName;
                                }),
                              },
                              title: Text(
                                _items[index].deckName,
                                style: TextStyle(
                                  color: fontColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize,
                                ),
                              ),
                            );
                          } else {
                            return CheckboxListTile(
                              value: widget._selectedOptions.any(
                                (final e) => e.id == _items[index].id,
                              ),
                              onChanged: (final value) => {
                                setState(() {
                                  if (value != null && value) {
                                    _addOptionToList(
                                      _items[index].id,
                                      _items[index].deckName,
                                    );
                                  } else {
                                    _removeOptionFromList(_items[index].id);
                                  }
                                }),
                              },
                              title: Text(
                                _items[index].deckName,
                                style: TextStyle(
                                  color: fontColor,
                                  fontSize:
                                      Theme.of(context).textTheme.bodyLarge!.fontSize,
                                ),
                              ),
                            );
                          }
                        }(),
                      );*/
                    },
                  ),
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
}
