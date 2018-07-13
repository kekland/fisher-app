import 'package:flutter/material.dart';

class PageViewModel {
  final Color color;
  final IconData heroIcon;
  final String title;
  final String body;
  final IconData pagerIcon;
  final Function action;

  PageViewModel({this.color, this.heroIcon, this.title, this.body, this.pagerIcon, this.action});
}

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  Page({this.viewModel, this.percentVisible = 1.0});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(32.0),
      width: double.infinity,
      color: viewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: new Matrix4.translationValues(0.0, 50.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Icon(
                  viewModel.heroIcon,
                  size: 200.0,
                  color: Colors.white,
                ),
              ),
            ),
            Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  viewModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.0,
                  ),
                ),
              ),
            ),
            Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 75.0),
                child: Text(
                  viewModel.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            (viewModel.action != null)? Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 75.0),
                child: RaisedButton(
                  onPressed: () => viewModel.action(context),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 12.0),
                  child: Text('Let\'s begin!'),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
