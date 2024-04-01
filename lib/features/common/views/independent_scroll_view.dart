import 'package:flutter/material.dart';

class IndependentScrollView extends StatefulWidget {
  const IndependentScrollView({
    required final Widget child,
    required final Axis scrollDirection,
    super.key,
  })  : _child = child,
        _scrollDirection = scrollDirection;

  final Widget _child;
  final Axis _scrollDirection;

  @override
  State<IndependentScrollView> createState() => _IndependentScrollViewState();
}

class _IndependentScrollViewState extends State<IndependentScrollView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: widget._scrollDirection,
        child: widget._child,
      );
}
