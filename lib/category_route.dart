// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_rectangle/backdrop.dart';
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
  static const defaultCategoryIndex = 0;

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

  final _categories = <Category>[];
  Category _currentCategory;
  Category _defaultCategory;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
    }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables. For more details on Effective
    // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
    final json = DefaultAssetBundle.of(context).loadString('assets/data/units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    var categoryIteration = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      final category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIteration],
        icon: Icons.cake,
      );

      setState(() {
        if (categoryIteration == defaultCategoryIndex) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });

      categoryIteration += 1;
    });
  }

  Widget _buildCategoryTileWidgets() {
    final categoryList = OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          return ListView.builder(
            itemBuilder: (context, index) => CategoryTile(
                  category: _categories[index],
                  categoryTapCallback: (Category category) =>
                      _onCategoryTap(category),
                ),
            itemCount: _categories.length,
          );
        } else {
          return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3.0,
              children: _categories.map((Category cat) {
                return CategoryTile(
                  category: cat,
                  categoryTapCallback: (Category category) =>
                      _onCategoryTap(category),
                );
              }).toList());
        }
      },
    );

    var category =
        _currentCategory == null ? _defaultCategory : _currentCategory;

    return Backdrop(
      currentCategory: category,
      frontPanel: UnitConverter(category: category),
      backPanel: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: categoryList,
      ),
      frontTitle: Text(category.name),
      backTitle: Text("Select a category"),
    );
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: _mainColor, child: _buildCategoryTileWidgets());
  }
}
