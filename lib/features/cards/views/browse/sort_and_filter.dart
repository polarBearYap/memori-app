import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';
import 'package:memori_app/features/cards/models/deck_dropdown_option.dart';
import 'package:memori_app/features/cards/models/tag_dropdown_option.dart';
import 'package:memori_app/features/cards/views/common/deck_form_field.dart';
import 'package:memori_app/features/cards/views/common/tag_form_field.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class CardSortFilterOption extends Equatable {
  final TextEditingController searchDeckController;
  final List<SelectDeckDropdownOption> selectedDecks;

  final TextEditingController searchTagController;
  final List<SelectCardTagDropdownOption> selectedTags;

  final CardSortOption sortOption;

  const CardSortFilterOption({
    required this.searchDeckController,
    required this.selectedDecks,
    required this.searchTagController,
    required this.selectedTags,
    required this.sortOption,
  });

  @override
  List<Object?> get props => [
        searchDeckController,
        selectedDecks,
        searchTagController,
        selectedTags,
        sortOption,
      ];
}

class SortAndFilterBottomSheet extends StatefulWidget {
  const SortAndFilterBottomSheet({
    required final CardSortFilterOption filterOption,
    required final VoidCallback onFilterChanged,
    super.key,
  })  : _filterOption = filterOption,
        _onFilterChanged = onFilterChanged;

  final CardSortFilterOption _filterOption;
  final VoidCallback _onFilterChanged;

  @override
  State<StatefulWidget> createState() => _SortAndFilterBottomSheetState();
}

class _SortAndFilterBottomSheetState extends State<SortAndFilterBottomSheet> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(
    final SortAndFilterBottomSheet oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._filterOption != oldWidget._filterOption) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;

    final divider = Divider(
      thickness: 0.5,
      indent: 5.w,
      endIndent: 5.w,
      height: 0,
      color: colorTheme.onBackground,
    );

    return SingleChildScrollView(
      controller: _scrollController,
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp * 0.7;
          final subTitleFontSize = isPortrait
              ? textTheme.titleSmall!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp * 0.6;
          final sortLabelFontSize = isPortrait
              ? textTheme.labelLarge!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    if (!isFontSizeBig())
                      Text(
                        localized(context).card_sort_filter,
                        style: TextStyle(
                          fontSize: titleFontSize,
                        ),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget._filterOption.searchDeckController.text = '';
                          widget._filterOption.searchTagController.text = '';
                          widget._filterOption.selectedDecks.clear();
                          widget._filterOption.selectedTags.clear();
                          widget._filterOption.sortOption.value =
                              CardSortOptionValue.modifiedDsc;
                        });
                        widget._onFilterChanged();
                      },
                      child: Text(
                        localized(context).card_sort_filter_clear,
                        style: getFilledButtonTextStyle(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                divider,
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: isPortrait ? 15.w : 5.w,
                  ),
                  child: Text(
                    localized(context).card_filter_title,
                    style: TextStyle(
                      fontSize: subTitleFontSize,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SelectDeckDropdown(
                  searchController: widget._filterOption.searchDeckController,
                  selectedOptions: widget._filterOption.selectedDecks,
                  isSingleSelect: false,
                ),
                SizedBox(
                  height: 10.h,
                ),
                SelectTagDropdown(
                  searchController: widget._filterOption.searchTagController,
                  selectedOptions: widget._filterOption.selectedTags,
                ),
                SizedBox(
                  height: 10.h,
                ),
                divider,
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: isPortrait ? 15.w : 5.w,
                  ),
                  child: Text(
                    localized(context).card_sort_title,
                    style: TextStyle(
                      fontSize: subTitleFontSize,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                InkWell(
                  onTap: () {
                    if (widget._filterOption.sortOption.value ==
                        CardSortOptionValue.modifiedAsc) {
                      widget._filterOption.sortOption.value =
                          CardSortOptionValue.modifiedDsc;
                    } else {
                      widget._filterOption.sortOption.value =
                          CardSortOptionValue.modifiedAsc;
                    }
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(
                      localized(context).card_sort_modified_date,
                      style: TextStyle(
                        fontSize: sortLabelFontSize,
                      ),
                    ),
                    trailing: () {
                      if (widget._filterOption.sortOption.value ==
                          CardSortOptionValue.modifiedAsc) {
                        return Icon(
                          Icons.arrow_upward,
                          size: iconSize,
                        );
                      }
                      if (widget._filterOption.sortOption.value ==
                          CardSortOptionValue.modifiedDsc) {
                        return Icon(
                          Icons.arrow_downward,
                          size: iconSize,
                        );
                      }
                      return null;
                    }(),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget._filterOption.sortOption.value ==
                        CardSortOptionValue.createdAsc) {
                      widget._filterOption.sortOption.value =
                          CardSortOptionValue.createdDsc;
                    } else {
                      widget._filterOption.sortOption.value =
                          CardSortOptionValue.createdAsc;
                    }
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(
                      localized(context).card_sort_created_date,
                      style: TextStyle(
                        fontSize: sortLabelFontSize,
                      ),
                    ),
                    trailing: () {
                      if (widget._filterOption.sortOption.value ==
                          CardSortOptionValue.createdAsc) {
                        return Icon(
                          Icons.arrow_upward,
                          size: iconSize,
                        );
                      }
                      if (widget._filterOption.sortOption.value ==
                          CardSortOptionValue.createdDsc) {
                        return Icon(
                          Icons.arrow_downward,
                          size: iconSize,
                        );
                      }
                      return null;
                    }(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                divider,
                SizedBox(
                  height: isPortrait ? 10.h : 25.h,
                ),
                Center(
                  child: OutlinedButton(
                    style: getFilledButtonStyle(
                      isPortrait: isPortrait,
                    ),
                    onPressed: () => {
                      widget._onFilterChanged(),
                    },
                    child: Text(
                      localized(context).card_sort_filter_apply,
                      style: getFilledButtonTextStyle(
                        isPortrait: isPortrait,
                        textTheme: textTheme,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
