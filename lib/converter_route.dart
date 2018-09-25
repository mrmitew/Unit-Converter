// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hello_rectangle/unit.dart';
import 'package:meta/meta.dart';

/// Converter screen where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  final ColorSwatch color;
  final String name;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  }) : assert(units != null);

  @override
  State<StatefulWidget> createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _covertFromUnit;
  Unit _covertToUnit;
  double _input;

  bool _validationFailed = false;
  String _convertedValue = "";

  List<DropdownMenuItem<Unit>> _unitWidgets;

  // TODO: Determine whether you need to override anything, such as initState()

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
  }

  void _buildDropDownMenuItems() {
    // Here is just a placeholder for a list of mock units
    var unitWidgets = widget.units.map((Unit unit) {
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
    final appBar =
        AppBar(backgroundColor: widget.color, title: Text(widget.name));

    var unitInput1 = buildUnitInput(context, onFromUnitChanged, _covertFromUnit);
    var unitInput2 = buildUnitInput(context, onToUnitChanged, _covertToUnit);

    var fromGroup = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
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

    var toGroup = Padding(
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

    var compareArrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final body = Column(
      children: <Widget>[
        fromGroup,
        compareArrows,
        toGroup,
      ],
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: body,
      resizeToAvoidBottomPadding: false,
    );

    return scaffold;
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
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
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

  void _updateConversion() {
    setState(() {
      _convertedValue = _format(_input * (_covertToUnit.conversion / _covertFromUnit.conversion));
    });
  }

  void onToUnitChanged(Unit value) {
    setState(() {
      _covertToUnit = value;
    });
  }

  void onFromUnitChanged(Unit value) {
    setState(() {
      _covertFromUnit = value;
    });
  }
}
