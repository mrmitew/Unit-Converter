// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:hello_rectangle/unit.dart';

typedef void CategoryTapCallback(Category category);

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final ColorSwatch categoryColor;
  final List<Unit> units;
  final CategoryTapCallback categoryTapCallback;

  static final _rowHeight = 100.0;

  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // TODO: You'll need the name, color, and iconLocation from main.dart
  const Category({
    Key key,
    @required this.categoryName,
    @required this.categoryIcon,
    @required this.categoryColor,
    @required this.units,
    this.categoryTapCallback,
  })  : assert(categoryName != null),
        assert(categoryIcon != null),
        assert(categoryColor != null),
        super(key: key);

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    // TODO: Build the custom widget here, referring to the Specs.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: categoryColor,
        borderRadius: BorderRadius.all(Radius.circular(_rowHeight / 2)),
        onTap: () {
          if (categoryTapCallback != null) categoryTapCallback(this);
        },
        child: Container(
          height: _rowHeight,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  categoryIcon,
                  size: 60.0,
                ),
              ),
              Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
