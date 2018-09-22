// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hello_rectangle/converter_route.dart';
import 'package:hello_rectangle/unit.dart';

import 'category.dart';

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  State<StatefulWidget> createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  static final _mainColor = Colors.green[100];

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  final categories = <Category>[];

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) =>
      List.generate(10, (int i) {
        i += 1;
        return Unit(
          name: '$categoryName Unit $i',
          conversion: i.toDouble(),
        );
      });

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _categoryNames.length; i++) {
      categories.add(_buildCategory(
        context,
        _categoryNames[i],
        Icons.cake,
        _baseColors[i],
        _retrieveUnitList(_categoryNames[i]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
        color: _mainColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => categories[index],
            itemCount: _categoryNames.length,
          ),
        ));

    final appBar = AppBar(
      backgroundColor: _mainColor,
      centerTitle: true,
      title: Text(
        "Unit Converter",
        style: TextStyle(fontSize: 30.0),
      ),
      elevation: 0.0,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }

  Category _buildCategory(BuildContext context, String name, IconData icon,
          ColorSwatch color, List<Unit> units) =>
      Category(
          categoryName: name,
          categoryIcon: icon,
          categoryColor: color,
          units: units,
          categoryTapCallback: (Category category) =>
              _navigateToConverter(context, category));

  void _navigateToConverter(BuildContext context, Category category) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return ConverterRoute(
          color: category.categoryColor,
          name: category.categoryName,
          units: category.units,
        );
      },
    ));
  }
}
