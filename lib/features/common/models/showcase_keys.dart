import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowcaseKey {
  static final ShowcaseKey _instance = ShowcaseKey._internal();
  factory ShowcaseKey() => _instance;

  ShowcaseKey._internal();

  BuildContext? scaffoldContext;
  final GlobalKey addFab = GlobalKey();

  BuildContext? addMenuContext;
  final GlobalKey addCardMenu = GlobalKey();
  final GlobalKey addDeckMenu = GlobalKey();

  // BuildContext? addDeckDialogContext;
  // final GlobalKey addDeckTextField = GlobalKey();
  // GlobalKey addDeckSubmitButton = GlobalKey();

  // BuildContext? deckListContext;
  // final GlobalKey newlyAddedDeckItem = GlobalKey();

  // BuildContext? newlyEditedDeckItemContext;
  // GlobalKey newlyEditedDeckItem = GlobalKey();

  // BuildContext? addEditCardContext;
  // final GlobalKey addEditCardSelectDeckFormField = GlobalKey();
  // final GlobalKey addEditCardSubmitButton = GlobalKey();
  // final GlobalKey addEditCardReturnButton = GlobalKey();

  BuildContext? addEditCardFrontContext;
  GlobalKey addEditCardFrontFormField = GlobalKey();

  BuildContext? addEditCardBackContext;
  GlobalKey addEditCardBackFormField = GlobalKey();

  // BuildContext? learnCardContext;
  // GlobalKey learnCardCount = GlobalKey();
  // GlobalKey learnCardProgress = GlobalKey();
  // GlobalKey learnCardFrontBack = GlobalKey();
  // GlobalKey learnCardShowAnswer = GlobalKey();
  // GlobalKey learnCardReview = GlobalKey();

  bool isShowcasingAddDeck = true;
}
