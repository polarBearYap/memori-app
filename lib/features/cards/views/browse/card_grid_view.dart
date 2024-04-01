import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';
import 'package:memori_app/features/cards/views/quill/quill_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/time_passed.dart';

class BrowseCardGridView extends StatelessWidget {
  final List<CardListViewItem> _gridItems;
  final CardListDateDisplayType _dateDisplayType;
  final bool _isLoading;
  final bool _hideLoadingIcon;

  const BrowseCardGridView({
    required final List<CardListViewItem> gridItems,
    required final CardListDateDisplayType dateDisplayType,
    required final bool isLoading,
    required final bool hideLoadingIcon,
    super.key,
  })  : _gridItems = gridItems,
        _dateDisplayType = dateDisplayType,
        _isLoading = isLoading,
        _hideLoadingIcon = hideLoadingIcon;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final screenHeight = MediaQuery.of(context).size.height;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 5.w,
              childAspectRatio: isPortrait
                  ? (isFontSizeBig()
                      ? 0.5
                      : isFontSizeSmall()
                          ? 0.60
                          : 0.55)
                  : (screenHeight < 400 ? 0.75 : 0.8),
            ),
            itemCount:
                _gridItems.length + (!_hideLoadingIcon && _isLoading ? 1 : 0),
            itemBuilder: (final BuildContext context, final int index) {
              if (index == _gridItems.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return GestureDetector(
                onTap: () {
                  context.read<AddEditCardBloc>().add(
                        AddEditCardFormInit(
                          cardId: _gridItems[index].id,
                        ),
                      );
                  context.push('/card/edit/${_gridItems[index].id}');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (final context, final constraints) {
                          final isPortrait =
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          return QuillScreen(
                            document: _gridItems[index].frontDocument,
                            isReadOnly: true,
                            isEditable: false,
                            isWholeScreen: false,
                            editorMaxHeight: screenHeight < 600
                                ? (isPortrait ? 250.h : 300.h)
                                : (isPortrait
                                    ? (screenHeight > 1000 ? 300.h : 200.h)
                                    : 375.h),
                            hideTopBarInSmallScreen: true,
                          );
                        },
                      ),
                      const Spacer(),
                      LayoutBuilder(
                        builder: (final context, final constraints) {
                          final isPortrait =
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait;
                          final textTheme = Theme.of(context).textTheme;
                          return Text(
                            () {
                              if (_dateDisplayType ==
                                  CardListDateDisplayType.createdAt) {
                                return localized(context)
                                    .card_browse_created_at(
                                  getTimePassed(
                                    _gridItems[index].lastCreatedAt,
                                    localized(context),
                                  ),
                                );
                              } else if (_dateDisplayType ==
                                  CardListDateDisplayType.modifiedAt) {
                                return localized(context)
                                    .card_browse_modified_at(
                                  getTimePassed(
                                    _gridItems[index].lastModifiedAt,
                                    localized(context),
                                  ),
                                );
                              }
                              return '';
                            }(),
                            style: TextStyle(
                              fontSize: isPortrait
                                  ? textTheme.labelSmall!.fontSize!.scaledSp
                                  : textTheme.labelSmall!.fontSize!.scaledSp *
                                      0.7,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: isFontSizeBig() ? 1 : null,
                          );
                        },
                      ),
                      const Spacer(),
                      LayoutBuilder(
                        builder: (final context, final constraints) {
                          final isPortrait =
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait;
                          final textTheme = Theme.of(context).textTheme;
                          return SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: isPortrait ? 15.scaledSp : 10.scaledSp,
                                ),
                                SizedBox(
                                  width: isPortrait ? 8.w : 5.w,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 100.w,
                                  ),
                                  child: Text(
                                    _gridItems[index].deckname,
                                    style: TextStyle(
                                      fontSize: isPortrait
                                          ? textTheme
                                              .labelSmall!.fontSize!.scaledSp
                                          : textTheme.labelSmall!.fontSize!
                                                  .scaledSp *
                                              0.7,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: isFontSizeBig() ? 2 : 3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
}
