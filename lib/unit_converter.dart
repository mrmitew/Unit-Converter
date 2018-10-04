// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_rectangle/api.dart';
import 'package:hello_rectangle/category.dart';
import 'package:hello_rectangle/unit.dart';
import 'package:meta/meta.dart';

/// Converter screen where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class UnitConverter extends StatefulWidget {
  final Category category;

  const UnitConverter({
    @required this.category,
  }) : assert(category != null);

  @override
  State<StatefulWidget> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  Unit _covertFromUnit;
  Unit _covertToUnit;
  double _input;

  bool _validationFailed = false;
  String _convertFromValue = "";
  String _convertedValue = "";

  List<DropdownMenuItem<Unit>> _unitWidgets;

  // Used in the input TextField so that the input value persists on orientation change
  // and also that keeps the keyboard shown if the widget is rebuilt meanwhile
  final _inputKey = GlobalKey(debugLabel: 'inputText');

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  void initState() {
    super.initState();
    _buildDropDownMenuItems();
    _setDefaults();
  }

  @override
  void didUpdateWidget(UnitConverter old) {
    super.didUpdateWidget(old);
    // We update our [DropdownMenuItem] units when we switch [Categories].
    if (old.category != widget.category) {
      _buildDropDownMenuItems();
      _setDefaults();
    }
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _covertFromUnit = widget.category.units[0];
      _covertToUnit = widget.category.units[1];
      _convertFromValue = "";
      _convertedValue = "";
    });
  }

  void _buildDropDownMenuItems() {
    // Here is just a placeholder for a list of mock units
    var unitWidgets = widget.category.units.map((Unit unit) {
      return DropdownMenuItem<Unit>(
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
            ),
          ],
        ),
        value: unit,
      );
    }).toList();

    setState(() {
      this._unitWidgets = unitWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unitInput1 =
        buildUnitInput(context, onFromUnitChanged, _covertFromUnit);
    final unitInput2 = buildUnitInput(context, onToUnitChanged, _covertToUnit);

    final fromGroup = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            key: _inputKey,
            controller: TextEditingController(text: _convertFromValue),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              errorText: _validationFailed ? 'Validation failed' : null,
              labelText: 'Input',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
            ),
            onChanged: _onInputValueChanged,
          ),
          unitInput1
        ],
      ),
    );

    final toGroup = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            enabled: false,
            controller: TextEditingController(text: _convertedValue),
            decoration: InputDecoration(
              labelText: 'Output',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
            ),
            onChanged: _onInputValueChanged,
          ),
          unitInput2
        ],
      ),
    );

    final compareArrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final converter = ListView(
      children: <Widget>[
        fromGroup,
        compareArrows,
        toGroup,
      ],
    );

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      var converterWrapper;
      if (orientation == Orientation.landscape) {
        converterWrapper =
            Center(child: Container(width: 450.0, child: converter));
      } else {
        converterWrapper = converter;
      }

      return converterWrapper;
    });
  }

  Container buildUnitInput(BuildContext context,
      ValueChanged<Unit> onValueChanged, Unit selectedUnit) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[400], width: 1.0)),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.grey[50]),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<Unit>(
                value: selectedUnit,
                items: _unitWidgets,
                onChanged: onValueChanged,
                style: Theme.of(context).textTheme.subhead),
          ),
        ),
      ),
    );
  }

  void _onInputValueChanged(String value) {
    bool isInvalidValue = value.isEmpty || value == null;

    _validationFailed = isInvalidValue;

    _convertFromValue = value;

    if (isInvalidValue) {
      _input = 0.0;
      _convertedValue = "";
    } else {
      try {
        _input = double.parse(value);
      } on Exception catch (e) {
        print('Error occurred: $e');
        _validationFailed = true;
      }
    }

    _updateConversion();
  }

  Future<void> _updateConversion() async {
    // TODO: Provide the API as a dependency
    final api = Api();

    if (api.isCategorySupported(widget.category)) {
      final conversion = await api.convert(widget.category, _input.toString(),
          _covertFromUnit.name, _covertToUnit.name);
      setState(() {
        _convertedValue = _format(conversion);
      });
    } else {
      setState(() {
        _convertedValue = _format(
            _input * (_covertToUnit.conversion / _covertFromUnit.conversion));
      });
    }
  }

  void onToUnitChanged(Unit value) {
    setState(() {
      _covertToUnit = value;
    });
    _updateConversion();
  }

  void onFromUnitChanged(Unit value) {
    setState(() {
      _covertFromUnit = value;
    });
    _updateConversion();
  }
}
