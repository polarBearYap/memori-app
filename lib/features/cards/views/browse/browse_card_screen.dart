import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memori_app/features/cards/bloc/card/card_bloc.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';
import 'package:memori_app/features/cards/models/deck_dropdown_option.dart';
import 'package:memori_app/features/cards/models/tag_dropdown_option.dart';
import 'package:memori_app/features/cards/views/browse/card_grid_view.dart';
import 'package:memori_app/features/cards/views/browse/card_list_view.dart';
import 'package:memori_app/features/cards/views/browse/sort_and_filter.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';

class BrowseCardScreen extends StatefulWidget {
  const BrowseCardScreen({
    final int pageSize = 10,
    final String initialDeckId = '',
    final String initialDeckName = '',
    super.key,
  })  : _pageSize = pageSize,
        _initialDeckId = initialDeckId,
        _initialDeckName = initialDeckName;

  final int _pageSize;
  final String _initialDeckId;
  final String _initialDeckName;

  @override
  State<BrowseCardScreen> createState() => _BrowseCardScreenState();
}

enum ViewMode {
  grid,
  list,
}

class _BrowseCardScreenState extends State<BrowseCardScreen> {
  // List & pagination
  late ViewMode viewMode;
  late ScrollController _scrollController;
  late List<CardListViewItem> _items;

  late bool _isLoading;
  late bool _hideLoadingIcon;
  late int _nextPageNumber;
  late Timer? _rateLimitTimer;

  // Search
  late TextEditingController _searchCardController;

  // Sort & filter
  late TextEditingController _searchDeckController;
  late List<SelectDeckDropdownOption> _selectedDecks;

  late TextEditingController _searchTagController;
  late List<SelectCardTagDropdownOption> _selectedTags;

  late CardSortOption _sortOption;

  @override
  void initState() {
    super.initState();
    // Search
    _searchCardController = TextEditingController();

    // Sort & filter
    _searchDeckController = TextEditingController();
    _selectedDecks = [];
    if (widget._initialDeckId.isNotEmpty) {
      _selectedDecks.add(
        SelectDeckDropdownOption(
          id: widget._initialDeckId,
          deckName: widget._initialDeckName,
        ),
      );
    }

    _searchTagController = TextEditingController();
    _selectedTags = [];

    _sortOption = CardSortOption(value: CardSortOptionValue.modifiedDsc);

    // List & pagination
    viewMode = ViewMode.list;
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _initPage();
  }

  void _initPage() {
    _rateLimitTimer = null;
    _hideLoadingIcon = false;
    _nextPageNumber = 0;
    _items = [];
    _isLoading = true;
    _fetchNextPage();
  }

  void _fetchNextPage() {
    context.read<CardBloc>().add(
          CardScrolledDown(
            pageNumber: _nextPageNumber,
            pageSize: widget._pageSize,
            searchText: _searchCardController.text,
            selectedDecks: _selectedDecks.map((final e) => e.id).toList(),
            selectedTags: _selectedTags.map((final e) => e.id).toList(),
            cardSortOption: _sortOption.value,
          ),
        );
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
    // List & pagination
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _rateLimitTimer?.cancel();
    // Search
    _searchCardController.dispose();
    // Sort & filter
    _searchDeckController.dispose();
    _searchTagController.dispose();
    super.dispose();
  }

  CardListDateDisplayType getDateDisplayType() {
    if (_sortOption.value == CardSortOptionValue.createdAsc ||
        _sortOption.value == CardSortOptionValue.createdDsc) {
      return CardListDateDisplayType.createdAt;
    }
    return CardListDateDisplayType.modifiedAt;
  }

  Widget _buildProvider({
    required final Widget child,
    required final double fontSize,
  }) =>
      MultiBlocListener(
        listeners: [
          BlocListener<CardBloc, CardState>(
            listener: (final context, final state) {
              if (state.status == CardListStatus.forceRefresh) {
                setState(() {
                  _initPage();
                });
                return;
              }
              if (state.status == CardListStatus.loading) {
                setState(() {
                  _isLoading = true;
                });
                return;
              }
              // Completed or failed
              if (state.hasNextPage || state.cards.isNotEmpty) {
                _nextPageNumber++;
              }
              if (state.status == CardListStatus.completed) {
                _items.addAll(state.cards);
              } else if (state.status == CardListStatus.failed) {
                showScaledSnackBar(
                  context,
                  localized(context).card_browse_loading_failed,
                );
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ],
        child: child,
      );

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);

    int badgeCount = 0;
    if (_selectedDecks.isNotEmpty) {
      badgeCount++;
    }
    if (_selectedTags.isNotEmpty) {
      badgeCount++;
    }

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = Theme.of(context).textTheme;
        final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
        final fontSize = isPortrait
            ? textTheme.labelSmall!.fontSize!.scaledSp * 0.9
            : textTheme.labelSmall!.fontSize!.scaledSp;
        final badgeSize = isPortrait ? 8.scaledSp : 5.scaledSp;

        final filterIcon = Icon(
          Icons.filter_alt,
          size: iconSize,
        );

        final factor = FontSizeScale().factorDesc;

        return _buildProvider(
          fontSize: fontSize,
          child: CardScreenScaffold(
            scrollController: _scrollController,
            scrollbarKey: 'browseCardScrollBar',
            hideScrollView: true,
            appBarLeadingWidget: Padding(
              padding: EdgeInsets.only(
                right: 5.w,
              ),
              child: const BackNavigator(),
            ),
            toolbarHeight: factor == FontSizeScaleFactor.biggest
                ? (isPortrait ? 80.h : 90.h)
                : factor == FontSizeScaleFactor.bigger
                    ? 60.h
                    : isPortrait
                        ? 40.h
                        : 80.h,
            titleSpacing: 0,
            appBarActionWidgets: [
              Row(
                children: [
                  _BrowseCardSearchIcon(
                    searchCardController: _searchCardController,
                    onSearch: () {
                      setState(() {
                        _initPage();
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () => {
                      showModalBottomSheet(
                        context: context,
                        builder: (final BuildContext context) =>
                            SortAndFilterBottomSheet(
                          filterOption: CardSortFilterOption(
                            searchDeckController: _searchDeckController,
                            selectedDecks: _selectedDecks,
                            searchTagController: _searchTagController,
                            selectedTags: _selectedTags,
                            sortOption: _sortOption,
                          ),
                          onFilterChanged: () {
                            setState(() {
                              _initPage();
                            });
                          },
                        ),
                      ),
                    },
                    icon: badgeCount < 1
                        ? filterIcon
                        : Badge(
                            label: Text(
                              badgeCount.toString(),
                            ),
                            /*offset: Offset(
                              screenHeight <= 1000 ? -5.scaledSp : 5.scaledSp,
                              screenHeight <= 1000 ? 5.scaledSp : 0,
                            ),*/
                            offset: Offset(
                              5.scaledSp,
                              -2.5.scaledSp,
                            ),
                            textColor: isDarkMode ? Colors.white : null,
                            textStyle: TextStyle(
                              fontSize: badgeSize,
                            ),
                            largeSize: badgeSize * 1.5,
                            child: filterIcon,
                          ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  IconButton(
                    onPressed: () => {
                      setState(() {
                        if (viewMode == ViewMode.grid) {
                          viewMode = ViewMode.list;
                        } else {
                          viewMode = ViewMode.grid;
                        }
                        _initPage();
                      }),
                    },
                    icon: Icon(
                      viewMode == ViewMode.grid ? Icons.grid_view : Icons.list,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
            ],
            bodyWidgets: [
              SizedBox(
                height: viewMode == ViewMode.grid ? 20.h : 10.h,
              ),
              Expanded(
                child: _items.isEmpty && !_isLoading
                    ? _SearchResultEmptyScreen()
                    : viewMode == ViewMode.grid
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: BrowseCardGridView(
                              gridItems: _items,
                              dateDisplayType: getDateDisplayType(),
                              isLoading: _isLoading,
                              hideLoadingIcon: _hideLoadingIcon,
                            ),
                          )
                        : BrowseCardListView(
                            listItems: _items,
                            dateDisplayType: getDateDisplayType(),
                            isLoading: _isLoading,
                            hideLoadingIcon: _hideLoadingIcon,
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrowseCardSearchIcon extends StatefulWidget {
  final TextEditingController _searchCardController;
  final VoidCallback _onSearch;

  const _BrowseCardSearchIcon({
    required final TextEditingController searchCardController,
    required final VoidCallback onSearch,
  })  : _searchCardController = searchCardController,
        _onSearch = onSearch;

  @override
  State<StatefulWidget> createState() => _BrowseCardSearchIconState();
}

class _BrowseCardSearchIconState extends State<_BrowseCardSearchIcon> {
  bool _isSearchActive = false;

  void toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      // if (!_isSearchActive) {
      //   widget._searchCardController.clear();
      // }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(
        theme.buttonTheme.padding.subtract(
          EdgeInsets.only(
            left: 5.w,
            right: 5.w,
          ),
        ),
      ),
    );
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
        final textTheme = Theme.of(context).textTheme;
        final buttonWidth = isScreenPhone(context)
            ? (isPortrait ? 50.w : 25.w)
            : (isPortrait ? 35.w : 20.w);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isSearchActive ? (isPortrait ? 200.w : 250.w) : buttonWidth,
          curve: Curves.easeInOut,
          child: Container(
            // color: appBarColor,
            padding: EdgeInsets.zero,
            child: _isSearchActive
                ? Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: getTextFieldHeight(
                            isPortrait: isPortrait,
                            hasErrorText: false,
                          ),
                          child: Center(
                            child: TextField(
                              controller: widget._searchCardController,
                              autofocus: true,
                              decoration: getTextFieldDecoration(
                                isPortrait: isPortrait,
                                textTheme: textTheme,
                                prefixIconData: Icons.search,
                                iconSize: iconSize * 0.8,
                              ).copyWith(
                                hintText:
                                    localized(context).card_search_hint_text,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: true,
                              ),
                              style: getTextFieldStyle(
                                isPortrait: isPortrait,
                                textTheme: textTheme,
                              ),
                              onChanged: (final _) {
                                widget._onSearch();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: Center(
                          child: IconButton(
                            style: buttonStyle,
                            icon: Icon(
                              Icons.close,
                              size: iconSize,
                            ),
                            onPressed: toggleSearch,
                          ),
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    alignment: Alignment.center,
                    style: buttonStyle,
                    icon: Icon(
                      Icons.search,
                      size: iconSize,
                    ),
                    onPressed: toggleSearch,
                  ),
          ),
        );
      },
    );
  }
}

class _SearchResultEmptyScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    final darkFilePrefix = isDarkMode ? '_dark' : '';

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final displaySmall = isPortrait
                ? textTheme.headlineMedium!.fontSize!.scaledSp
                : textTheme.titleMedium!.fontSize!.scaledSp;
            final titleMedium = isPortrait
                ? textTheme.bodyLarge!.fontSize!.scaledSp
                : textTheme.bodySmall!.fontSize!.scaledSp * 0.75;
            return Column(
              children: <Widget>[
                SizedBox(
                  height: isPortrait ? 50.h : 20.h,
                ),
                // const Spacer(),
                SvgPicture.asset(
                  'assets/splash_screens/empty_screen$darkFilePrefix.svg',
                  placeholderBuilder: (final BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator(),
                  ),
                  width: isPortrait ? 300.w : 125.w,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  localized(context).card_search_empty_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: displaySmall,
                  ),
                  overflow: TextOverflow.visible,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  localized(context).card_search_empty_desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleMedium,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
