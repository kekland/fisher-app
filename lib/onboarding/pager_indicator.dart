import 'dart:ui';

import 'package:flutter/material.dart';

import 'page.dart';

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel({this.pages, this.activeIndex, this.slideDirection, this.slidePercent});
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PageBubbleViewModel {
  final IconData iconAsset;
  final Color iconColor;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel({this.iconAsset, this.iconColor, this.isHollow, this.activePercent});
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({this.viewModel});
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: Container(
        width: lerpDouble(20.0, 45.0, viewModel.activePercent),
        height: lerpDouble(20.0, 45.0, viewModel.activePercent),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow ? Colors.white.withAlpha((0xB3 * viewModel.activePercent).round()) : Colors.white70,
            border: new Border.all(
              color: viewModel.isHollow ? Colors.white.withAlpha((0xB3 * (1.0 - viewModel.activePercent)).round()) : Colors.transparent,
              width: 3.0,
            )),
        child: new Opacity(
          opacity: viewModel.activePercent,
          child: Icon(
            viewModel.iconAsset,
            color: viewModel.iconColor,
          ),
        ),
      ),
    );
  }
}

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbleList = [];
    for (var i = 0; i < viewModel.pages.length; i++) {
      var page = viewModel.pages[i];

      double percentActive;

      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbleList.add(new PageBubble(
        viewModel: new PageBubbleViewModel(
          iconAsset: page.pagerIcon,
          iconColor: page.color,
          isHollow: isHollow,
          activePercent: percentActive,
        ),
      ));
    }


    final BUBBLE_WIDTH = 55.0;
    final baseTranslation = ((viewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }

    return new Column(
      children: <Widget>[
        Expanded(child: Container()),
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbleList,
          ),
        ),
      ],
    );
  }
}
