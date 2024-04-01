import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';
import 'package:memori_app/features/cards/views/common/selected_tag_chip.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/time_passed.dart';

class BrowseCardListView extends StatelessWidget {
  final List<CardListViewItem> _listItems;
  final CardListDateDisplayType _dateDisplayType;
  final bool _isLoading;
  final bool _hideLoadingIcon;

  const BrowseCardListView({
    required final List<CardListViewItem> listItems,
    required final CardListDateDisplayType dateDisplayType,
    required final bool isLoading,
    required final bool hideLoadingIcon,
    super.key,
  })  : _listItems = listItems,
        _dateDisplayType = dateDisplayType,
        _isLoading = isLoading,
        _hideLoadingIcon = hideLoadingIcon;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _listItems.length + (!_hideLoadingIcon && _isLoading ? 1 : 0),
      itemBuilder: (final BuildContext context, final int index) {
        if (index == _listItems.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.only(
            left: isScreenPhone(context) ? 0 : 10.w,
            right: isScreenPhone(context) ? 0 : 10.w,
            bottom: 10.h,
          ),
          child: Card(
            child: InkWell(
              onTap: () {
                context.read<AddEditCardBloc>().add(
                      AddEditCardFormInit(
                        cardId: _listItems[index].id,
                      ),
                    );
                context.push('/card/edit/${_listItems[index].id}');
              },
              child: Padding(
                // padding: EdgeInsets.symmetric(
                //   horizontal: 15.w,
                //   vertical: 10.h,
                // ),
                padding: EdgeInsets.zero,
                child: LayoutBuilder(
                  builder: (final context, final constraints) {
                    final isPortrait = MediaQuery.of(context).orientation ==
                        Orientation.portrait;
                    final textTheme = Theme.of(context).textTheme;
                    final fontSize = isPortrait
                        ? textTheme.bodySmall!.fontSize!.scaledSp
                        : textTheme.bodySmall!.fontSize!.scaledSp * 0.6;
                    final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: colorTheme.background,
                          padding: EdgeInsets.fromLTRB(
                            15.w,
                            10.h,
                            15.w,
                            0,
                          ),
                          child: Text(
                            _listItems[index].frontPlainText,
                            overflow: TextOverflow.fade,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                size: iconSize,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                () {
                                  if (_dateDisplayType ==
                                      CardListDateDisplayType.createdAt) {
                                    return localized(context)
                                        .card_browse_created_at(
                                      getTimePassed(
                                        _listItems[index].lastCreatedAt,
                                        localized(context),
                                      ),
                                    );
                                  } else if (_dateDisplayType ==
                                      CardListDateDisplayType.modifiedAt) {
                                    return localized(context)
                                        .card_browse_modified_at(
                                      getTimePassed(
                                        _listItems[index].lastModifiedAt,
                                        localized(context),
                                      ),
                                    );
                                  }
                                  return '';
                                }(),
                                style: TextStyle(
                                  fontSize: fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder,
                                size: iconSize,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Flexible(
                                child: Text(
                                  _listItems[index].deckname,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_listItems[index].tagNames.isNotEmpty)
                          SizedBox(
                            height: 5.h,
                          ),
                        if (_listItems[index].tagNames.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 0,
                            ),
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 5.w,
                              runSpacing: isScreenTablet(context) ? 10.h : 0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(
                                  Icons.sell,
                                  size: iconSize,
                                ),
                                for (final tag in _listItems[index].tagNames)
                                  SelectedTagChip(
                                    label: tag,
                                    onDelete: () => {},
                                    disableDelete: true,
                                  ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: isScreenPhone(context) ? 10.h : 20.h,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
