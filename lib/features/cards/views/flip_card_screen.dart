import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/views/common/card_popup_editor.dart';
import 'package:memori_app/features/common/utils/localization.dart';

class FlipCardScreen extends StatefulWidget {
  const FlipCardScreen({
    super.key,
    required final bool flipToFront,
    required final Document frontDocument,
    required final Document backDocument,
    final bool disableEditPopup = false,
  })  : _flipToFront = flipToFront,
        _frontDocument = frontDocument,
        _backDocument = backDocument,
        _disableEditPopup = disableEditPopup;

  final bool _flipToFront;
  final Document _frontDocument;
  final Document _backDocument;
  final bool _disableEditPopup;

  @override
  State<FlipCardScreen> createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late ScrollController _scrollController;

  late Document _frontDocumentView;
  late Document _backDocumentView;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _scrollController = ScrollController();

    updateFrontDocumentView();
    updateBackDocumentView();
  }

  void updateFrontDocumentView() {
    _frontDocumentView = Document.fromDelta(widget._frontDocument.toDelta());
  }

  void updateBackDocumentView() {
    _backDocumentView = Document.fromDelta(widget._backDocument.toDelta());
  }

  @override
  void didUpdateWidget(
    final FlipCardScreen oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._frontDocument != oldWidget._frontDocument ||
        widget._backDocument != oldWidget._backDocument) {
      setState(() {
        updateFrontDocumentView();
        updateBackDocumentView();
      });
    }
    if (!widget._flipToFront) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
        ),
        height: 450.h,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (final context, final child) => Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(
                  pi * _animation.value,
                ),
              alignment: Alignment.center,
              child: _animationController.value < 0.5
                  ? CardPopupEditor(
                      title: localized(context).flip_card_front,
                      editorMaxHeight: 400.h,
                      document: widget._frontDocument,
                      documentView: _frontDocumentView,
                      onClosed: (final value) => {
                        setState(() {
                          updateFrontDocumentView();
                        }),
                      },
                      disableEditPopup: widget._disableEditPopup,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: CardPopupEditor(
                        title: localized(context).flip_card_back,
                        editorMaxHeight: 400.h,
                        document: widget._backDocument,
                        documentView: _backDocumentView,
                        onClosed: (final value) => {
                          setState(() {
                            updateBackDocumentView();
                          }),
                        },
                        disableEditPopup: widget._disableEditPopup,
                      ),
                    ),
            ),
          ),
        ),
      );
}
