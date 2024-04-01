import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/preview_card_bloc.dart';
import 'package:memori_app/features/cards/models/deck_dropdown_option.dart';
import 'package:memori_app/features/cards/models/tag_dropdown_option.dart';
import 'package:memori_app/features/cards/views/add_edit/add_edit_card_popup_screen.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/cards/views/common/deck_form_field.dart';
import 'package:memori_app/features/cards/views/common/tag_form_field.dart';
import 'package:memori_app/features/cards/views/quill/quill_screen.dart';
import 'package:memori_app/features/common/models/showcase_keys.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/delete_alert.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

enum AddCardScreenAction {
  create,
  update,
}

class AddEditCardScreen extends StatefulWidget {
  const AddEditCardScreen({
    required final AddCardScreenAction action,
    final String cardId = '',
    super.key,
  })  : _initAction = action,
        _initCardId = cardId;

  final AddCardScreenAction _initAction;
  final String _initCardId;

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardLastSave {
  final SelectDeckDropdownOption _selectedDeck;
  final List<SelectCardTagDropdownOption> _selectedTags;
  final String _frontDocument;
  final String _backDocument;

  _AddEditCardLastSave({
    required final SelectDeckDropdownOption selectedDeck,
    required final List<SelectCardTagDropdownOption> selectedTags,
    required final String frontDocument,
    required final String backDocument,
  })  : _selectedDeck = selectedDeck,
        _selectedTags = selectedTags,
        _frontDocument = frontDocument,
        _backDocument = backDocument;

  bool _isTagSame(
    final List<SelectCardTagDropdownOption> list1,
    final List<SelectCardTagDropdownOption> list2,
  ) {
    final idList1 = list1.map((final e) => e.id).toList()..sort();
    final idList2 = list2.map((final e) => e.id).toList()..sort();
    return idList1.length == idList2.length &&
        idList1.every((final e) => idList2.contains(e));
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is _AddEditCardLastSave &&
          runtimeType == other.runtimeType &&
          _frontDocument == other._frontDocument &&
          _backDocument == other._backDocument &&
          _selectedDeck.id == other._selectedDeck.id &&
          _isTagSame(
            _selectedTags,
            other._selectedTags,
          );

  @override
  int get hashCode =>
      _frontDocument.hashCode ^
      _backDocument.hashCode ^
      _selectedDeck.id.hashCode ^
      _selectedTags.hashCode;
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  late TextEditingController _searchDeckController;
  late SelectDeckDropdownOption _selectedDeck;

  late TextEditingController _searchTagController;
  late List<SelectCardTagDropdownOption> _selectedTags;

  late ScrollController _scrollController;
  late ScrollController _frontScrollController;
  late ScrollController _backScrollController;

  late Document _frontDocument;
  late Document _frontDocumentView;
  late Document _backDocument;
  late Document _backDocumentView;

  late bool _isLoading;

  late String _cardId;
  late AddCardScreenAction _curAction;

  late _AddEditCardLastSave _lastSave;

  late bool _isShowcasing;
  late String _newlyEditedDeckId;

  late BuildContext _addEditCardContext;
  final GlobalKey _addEditCardSelectDeckFormField = GlobalKey();
  final GlobalKey _addEditCardSubmitButton = GlobalKey();
  final GlobalKey _addEditCardReturnButton = GlobalKey();

  late ExpansionTileController _deckTileController;
  late ExpansionTileController _frontTileController;
  late ExpansionTileController _backTileController;

  @override
  void initState() {
    super.initState();
    _cardId = widget._initCardId;
    _curAction = widget._initAction;
    _searchDeckController = TextEditingController();
    _searchTagController = TextEditingController();
    _scrollController = ScrollController();
    _frontScrollController = ScrollController();
    _backScrollController = ScrollController();
    final cardState = BlocProvider.of<AddEditCardBloc>(context).state;
    _selectedDeck = SelectDeckDropdownOption(
      id: cardState.selectedDeck,
      deckName: cardState.deckName,
    );
    _selectedTags = List<SelectCardTagDropdownOption>.from(
      cardState.selectedTags,
    );
    _frontDocument = cardState.front;
    _backDocument = cardState.back;
    updateFrontDocumentView();
    updateBackDocumentView();
    _isLoading = false;
    updateLastSave();
    _newlyEditedDeckId = '';
    _deckTileController = ExpansionTileController();
    _frontTileController = ExpansionTileController();
    _backTileController = ExpansionTileController();
    _isShowcasing = cardState.isShowcasing;
    initShowcasing();
  }

  void initShowcasing() {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (_isShowcasing) {
        _deckTileController.expand();
        Future.delayed(const Duration(milliseconds: 600), () {
          startShowcaseDeck();
        });
      }
    });
  }

  void startShowcaseDeck() {
    startShowcase(
      _addEditCardContext,
      [
        _addEditCardSelectDeckFormField,
      ],
    );
  }

  void startShowcaseFront() {
    startShowcase(
      ShowcaseKey().addEditCardFrontContext ?? _addEditCardContext,
      [
        ShowcaseKey().addEditCardFrontFormField,
      ],
    );
  }

  void startShowcaseBack() {
    startShowcase(
      ShowcaseKey().addEditCardBackContext ?? _addEditCardContext,
      [
        ShowcaseKey().addEditCardBackFormField,
      ],
    );
  }

  void startShowcaseSubmit() {
    startShowcase(
      _addEditCardContext,
      [
        _addEditCardSubmitButton,
      ],
    );
  }

  void startShowcaseReturn() {
    saveCard();
    Future.delayed(const Duration(milliseconds: 500), () {
      startShowcase(
        _addEditCardContext,
        [
          _addEditCardReturnButton,
        ],
      );
    });
  }

  void updateFrontDocumentView() {
    _frontDocumentView = Document.fromDelta(_frontDocument.toDelta());
  }

  void updateBackDocumentView() {
    _backDocumentView = Document.fromDelta(_backDocument.toDelta());
  }

  @override
  void dispose() {
    _searchDeckController.dispose();
    _searchTagController.dispose();
    _scrollController.dispose();
    _frontScrollController.dispose();
    _backScrollController.dispose();
    super.dispose();
  }

  void updateLastSave() {
    _lastSave = _AddEditCardLastSave(
      selectedDeck: SelectDeckDropdownOption(
        id: _selectedDeck.id,
        deckName: _selectedDeck.deckName,
      ),
      selectedTags: _selectedTags
          .map((final e) => SelectCardTagDropdownOption(id: e.id, name: e.name))
          .toList(),
      frontDocument: _frontDocument.toPlainText(),
      backDocument: _backDocument.toPlainText(),
    );
  }

  bool changesAreMade() =>
      _lastSave !=
      _AddEditCardLastSave(
        selectedDeck: _selectedDeck,
        selectedTags: _selectedTags,
        frontDocument: _frontDocument.toPlainText(),
        backDocument: _backDocument.toPlainText(),
      );

  void saveCard() {
    context.read<AddEditCardBloc>().add(
          AddEditCardChanged(
            id: _curAction == AddCardScreenAction.create ? '' : _cardId,
            action: _curAction == AddCardScreenAction.create
                ? AddEditCardAction.create
                : AddEditCardAction.update,
            selectedDeck: _selectedDeck.id,
            selectedTags: _selectedTags.map((final e) => e.id).toList(),
            front: _frontDocument,
            back: _backDocument,
          ),
        );
  }

  Widget _buildBloc({
    required final Widget child,
    required final scaffoldFontSize,
  }) =>
      BlocListener<AddEditCardBloc, AddEditCardState>(
        listener: (final context, final state) {
          if (state.submissionStatus == AddEditCardStatus.initial) {
            setState(() {
              _selectedDeck = SelectDeckDropdownOption(
                id: state.selectedDeck,
                deckName: state.deckName,
              );
              _selectedTags = state.selectedTags;
              _frontDocument = state.front;
              _backDocument = state.back;
              updateFrontDocumentView();
              updateBackDocumentView();
              updateLastSave();
            });
            return;
          }
          if (state.submissionStatus == AddEditCardStatus.inProgress) {
            setState(() {
              _isLoading = true;
            });
            return;
          }
          String text = '';
          if (state.submissionStatus == AddEditCardStatus.inputInvalid) {
            if (!state.isDeckValid) {
              text = localized(context).add_edit_card_invalid_deck;
            } else if (!state.isTagValid) {
              text = localized(context).add_edit_card_invalid_tag;
            } else if (!state.isFrontValid) {
              text = localized(context).add_edit_card_invalid_front;
            } else if (!state.isBackValid) {
              text = localized(context).add_edit_card_invalid_back;
            }
          }
          if (state.submissionStatus == AddEditCardStatus.completed) {
            context.read<DeckBloc>().add(const DeckReloaded());
            if (state.submittedAction == AddEditCardAction.delete) {
              text = localized(context).add_edit_card_delete_successful;
              Navigator.of(context).pop();
            } else {
              updateLastSave();
              text = state.submittedAction == AddEditCardAction.create
                  ? localized(context).add_edit_card_create_successful
                  : localized(context).add_edit_card_update_successful;
              if (_curAction == AddCardScreenAction.create) {
                setState(() {
                  _newlyEditedDeckId = state.newlyEditedDeckId;
                  _cardId = state.cardId;
                  _curAction = AddCardScreenAction.update;
                });
              }
            }
          } else if (state.submissionStatus == AddEditCardStatus.failure) {
            text = state.submittedAction == null
                ? localized(context).add_edit_card_create_opened
                : state.submittedAction == AddEditCardAction.create
                    ? localized(context).add_edit_card_create_failed
                    : state.submittedAction! == AddEditCardAction.delete
                        ? localized(context).add_edit_card_delete_failed
                        : localized(context).add_edit_card_update_failed;
          }
          showScaledSnackBar(
            context,
            text,
          );
        },
        child: child,
      );

  Widget _buildScaffold(
    final List<Widget> bodyWidgets,
  ) =>
      LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.labelSmall!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
          final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
          onPressBack() {
            if (!changesAreMade()) {
              if (_isShowcasing) {
                context.read<DeckBloc>().add(
                      DeckReloaded(
                        newlyEditedDeckId: _newlyEditedDeckId,
                      ),
                    );
              }
              Navigator.of(context).pop();
              return;
            }
            showDialog(
              context: context,
              builder: (final BuildContext context) => DeleteConfirmationDialog(
                title: localized(context).add_edit_card_unsave_title,
                content: localized(context).add_edit_card_unsave_desc,
                confirmText: localized(context).add_edit_card_unsave_confirm,
                dismissText: localized(context).add_edit_card_unsave_cancel,
                onConfirm: () {
                  context.read<DeckBloc>().add(const DeckReloaded());
                  Navigator.of(context).pop();
                },
              ),
            );
          }

          return _buildBloc(
            scaffoldFontSize: fontSize,
            child: ShowCaseWidget(
              builder: Builder(
                builder: (final context) {
                  _addEditCardContext = context;
                  return CardScreenScaffold(
                    scrollController: _scrollController,
                    scrollbarKey: 'addCardScreenScroll',
                    appBarTitle: _curAction == AddCardScreenAction.create
                        ? localized(context).add_card_title
                        : localized(context).edit_card_title,
                    appBarLeadingWidget: CustomShowcaseWidget(
                      title: localized(context).showcase_card_return_home_title,
                      desc: localized(context).showcase_card_return_home_desc,
                      showcaseKey: _addEditCardReturnButton,
                      targetShapeBorder: const CircleBorder(),
                      disableDefaultTargetGestures: false,
                      speechBubbleLeft: 0,
                      containerFlexRight: isPortrait ? 7 : 9,
                      tooltipPosition: TooltipPosition.bottom,
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 3.w,
                      ),
                      onTargetClick: onPressBack,
                      child: IconButton(
                        onPressed: onPressBack,
                        icon: Icon(
                          Icons.arrow_back,
                          size: iconSize,
                        ),
                      ),
                    ),
                    appBarActionWidgets: [
                      CustomShowcaseWidget(
                        title: localized(context).showcase_card_save_title,
                        desc: localized(context).showcase_card_save_desc,
                        showcaseKey: _addEditCardSubmitButton,
                        targetShapeBorder: const CircleBorder(),
                        speechBubbleRight: isPortrait ? 5.w : 0,
                        containerFlexLeft: isPortrait ? 4 : 6,
                        tooltipPosition: TooltipPosition.bottom,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 3.w,
                        ),
                        onTargetClick: startShowcaseReturn,
                        child: IconButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  saveCard();
                                },
                          icon: Icon(
                            Icons.done,
                            size: iconSize,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<PreviewCardBloc>().add(
                                PreviewCardOpened(
                                  frontDocument: Document.fromDelta(
                                    _frontDocument.toDelta(),
                                  ),
                                  backDocument: Document.fromDelta(
                                    _backDocument.toDelta(),
                                  ),
                                ),
                              );
                          context.push('/card/preview');
                        },
                        icon: Icon(
                          Icons.preview,
                          size: iconSize,
                        ),
                      ),
                      if (_curAction == AddCardScreenAction.update)
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (final BuildContext context) =>
                                  DeleteConfirmationDialog(
                                title: localized(context)
                                    .card_delete_confirm_title,
                                content:
                                    localized(context).card_delete_confirm_desc,
                                confirmText:
                                    localized(context).card_delete_confirm_ok,
                                dismissText: localized(context)
                                    .card_delete_confirm_cancel,
                                onConfirm: () {
                                  context.read<AddEditCardBloc>().add(
                                        AddEditCardDeleted(
                                          id: _cardId,
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            size: iconSize,
                          ),
                        ),
                    ],
                    bodyWidgets: bodyWidgets,
                  );
                },
              ),
            ),
          );
        },
      );

  @override
  Widget build(final BuildContext context) => _buildScaffold([
        Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            10.h,
            20.w,
            10.h,
          ),
          // color: Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              CustomShowcaseWidget(
                title: localized(context).showcase_card_select_deck_title,
                desc: localized(context).showcase_card_select_deck_desc,
                showcaseKey: _addEditCardSelectDeckFormField,
                targetShapeBorder: const RoundedRectangleBorder(),
                tooltipPosition: TooltipPosition.bottom,
                onTargetClick: () {},
                child: SelectDeckDropdown(
                  tileController: _deckTileController,
                  searchController: _searchDeckController,
                  selectedOptions: [_selectedDeck],
                  isSingleSelect: true,
                  isShowcasing: _isShowcasing,
                  onShowcasing: () {
                    /*final position = _scrollController.position.maxScrollExtent;
                    _scrollController.animateTo(
                      min(position, 300.h),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );*/
                    _deckTileController.collapse();
                    _frontTileController.expand();
                    Future.delayed(const Duration(milliseconds: 600), () {
                      startShowcaseFront();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SelectTagDropdown(
                searchController: _searchTagController,
                selectedOptions: _selectedTags,
              ),
              SizedBox(
                height: 10.h,
              ),
              AddEditCardPopupScreen(
                scrollController: _frontScrollController,
                tileController: _frontTileController,
                title: localized(context).flip_card_front,
                iconData: Icons.flip_to_front,
                document: _frontDocument,
                documentView: _frontDocumentView,
                isShowcasingQuill: _isShowcasing,
                isShowcasingEditButton: _isShowcasing,
                showcaseTitle:
                    localized(context).showcase_card_front_edit_title,
                showcaseDescription:
                    localized(context).showcase_card_front_edit_desc,
                cardSide: CardSide.front,
                onCloseEdit: () {
                  setState(() {
                    updateFrontDocumentView();
                    if (_isShowcasing) {
                      if (_frontDocument.toPlainText().trim().isEmpty) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          startShowcaseFront();
                        });
                      } else {
                        Future.delayed(
                            const Duration(
                              milliseconds: 300,
                            ), () {
                          _frontTileController.collapse();
                          _backTileController.expand();
                        });
                        Future.delayed(const Duration(milliseconds: 900), () {
                          startShowcaseBack();
                        });
                      }
                    }
                  });
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              AddEditCardPopupScreen(
                scrollController: _backScrollController,
                tileController: _backTileController,
                title: localized(context).flip_card_back,
                iconData: Icons.flip_to_back,
                document: _backDocument,
                documentView: _backDocumentView,
                isShowcasingQuill: _isShowcasing,
                isShowcasingEditButton: _isShowcasing,
                showcaseTitle: localized(context).showcase_card_back_edit_title,
                showcaseDescription:
                    localized(context).showcase_card_back_edit_desc,
                cardSide: CardSide.back,
                onCloseEdit: () {
                  setState(() {
                    updateBackDocumentView();
                    if (_isShowcasing) {
                      if (_backDocument.toPlainText().trim().isEmpty) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          startShowcaseBack();
                        });
                      } else {
                        Future.delayed(
                            const Duration(
                              milliseconds: 300,
                            ), () {
                          _frontTileController.collapse();
                        });
                        Future.delayed(
                            const Duration(
                              milliseconds: 900,
                            ), () {
                          startShowcaseSubmit();
                        });
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ]);
}
