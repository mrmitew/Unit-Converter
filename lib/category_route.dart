// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hello_rectangle/category.dart';
import 'package:hello_rectangle/category_tile.dart';
import 'package:hello_rectangle/converter_route.dart';
import 'package:hello_rectangle/unit.dart';

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

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
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
      final category = Category(
          categoryName: _categoryNames[i],
          categoryIcon: Icons.cake,
          categoryColor: _baseColors[i],
          units: _retrieveUnitList(_categoryNames[i]));
      categories.add(category);
    }
  }

  Widget _buildCategoryTileWidgets() {
    return ListView.builder(
      itemBuilder: (context, index) => CategoryTile(
            category: categories[index],
            categoryTapCallback: (Category category) =>
                _navigateToConverter(context, category),
          ),
      itemCount: categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
        color: _mainColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCategoryTileWidgets(),
        ));

    final appBar = AppBar(
      backgroundColor: _mainColor,
      centerTitle: true,
      title: Text(
        "Unit Converter",
        style: TextStyle(fontSize: 25.0, color: Colors.black),
      ),
      elevation: 0.0,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }

  void _navigateToConverter(BuildContext context, Category category) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return UnitConverter(
          color: category.categoryColor,
          name: category.categoryName,
          units: category.units,
        );
      },
    ));
  }
}
