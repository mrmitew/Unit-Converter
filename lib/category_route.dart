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

  // TODO: Remove _categoryNames as they will be retrieved from the JSON asset
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

  final _categories = <Category>[];
  Category _currentCategory;

  // TODO: Delete this function; instead, read in the units from the JSON asset
  // inside _retrieveLocalCategories()
  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) =>
      List.generate(10, (int i) {
        i += 1;
        return Unit(
          name: '$categoryName Unit $i',
          conversion: i.toDouble(),
        );
      });

  // TODO: Remove the overriding of initState(). Instead, we use
  // didChangeDependencies()
  @override
  void initState() {
    super.initState();

    for (var i = 0; i < _categoryNames.length; i++) {
      final category = Category(
          name: _categoryNames[i],
          icon: Icons.cake,
          color: _baseColors[i],
          units: _retrieveUnitList(_categoryNames[i]));
      _categories.add(category);
    }

    _currentCategory = _categories[defaultCategoryIndex];
  }

  // TODO: Uncomment this out. We use didChangeDependencies() so that we can
  // wait for our JSON asset to be loaded in (async).
  //  @override
  //  Future<void> didChangeDependencies() async {
  //    super.didChangeDependencies();
  //    // We have static unit conversions located in our
  //    // assets/data/regular_units.json
  //    if (_categories.isEmpty) {
  //      await _retrieveLocalCategories();
  //    }
  //  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables. For more details on Effective
    // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    // TODO: Create Categories and their list of Units, from the JSON asset
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

    return Backdrop(
      currentCategory: _currentCategory,
      frontPanel: UnitConverter(category: _currentCategory),
      backPanel: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: categoryList,
      ),
      frontTitle: Text(_currentCategory.name),
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
