import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/bloc/card/preview_card_bloc.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/cards/views/flip_card_screen.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';

class PreviewCardScreen extends StatefulWidget {
  const PreviewCardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PreviewCardScreenState();
}

class _PreviewCardScreenState extends State<PreviewCardScreen> {
  late ScrollController _scrollController;
  late Document _frontDocument;
  late Document _backDocument;
  bool _flipToFront = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final previewState = BlocProvider.of<PreviewCardBloc>(context).state;
    _frontDocument = previewState.frontDocument;
    _backDocument = previewState.backDocument;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _flipToFront = !_flipToFront;
    });
  }

  Widget _blocListener({required final Widget child}) =>
      BlocListener<PreviewCardBloc, PreviewCardState>(
        listenWhen: (final previous, final current) =>
            previous.stateId != current.stateId,
        listener: (final context, final state) {
          setState(() {
            _frontDocument = state.frontDocument;
            _backDocument = state.backDocument;
          });
        },
        child: child,
      );

  Widget _buildScaffold(
    final List<Widget> bodyWidgets,
  ) =>
      CardScreenScaffold(
        scrollController: _scrollController,
        scrollbarKey: 'previewCardScreenScroll',
        appBarTitle: localized(context).preview_card_title,
        appBarLeadingWidget: const BackNavigator(),
        appBarActionWidgets: const [],
        bodyWidgets: bodyWidgets,
      );

  @override
  Widget build(final BuildContext context) => _buildScaffold([
        SizedBox(
          height: 40.h,
        ),
        _blocListener(
          child: FlipCardScreen(
            flipToFront: _flipToFront,
            frontDocument: _frontDocument,
            backDocument: _backDocument,
            disableEditPopup: true,
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            return FilledButton(
              onPressed: _flipCard,
              style: getFilledButtonStyle(
                isPortrait: isPortrait,
              ),
              child: Text(
                _flipToFront
                    ? localized(context).preview_card_flip_to_back
                    : localized(context).preview_card_flip_to_front,
                style: getFilledButtonTextStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 30.h,
        ),
      ]);
}
