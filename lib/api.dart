// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Import relevant packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hello_rectangle/category.dart';
import 'package:hello_rectangle/unit.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  static final supportedCategories = [
    {
      "name": "Currency",
      "route": "currency",
    }
  ];

  final _httpClient = HttpClient();
  final _baseUrl = "flutter.udacity.com";

  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits(Category category) async {
    final jsonResponse = await _fetchJson(
        Uri.https(_baseUrl, "/${supportedCategories[0]["route"]}/"));

    if (jsonResponse == null || jsonResponse['units'] == null) {
      print('Error retrieving units.');
      return null;
    }

    final List<Unit> units = jsonResponse["units"]
        .map<Unit>((dynamic unitsJson) => Unit.fromJson(unitsJson))
        .toList();

    return units;
  }

  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.
  Future<double> convert(
      Category category, String amount, String fromUnit, String toUnit) async {
    final jsonResponse = await _fetchJson(
        Uri.https(_baseUrl, "/${supportedCategories[0]["route"]}/convert", {
      "amount": amount,
      "from": fromUnit,
      "to": toUnit,
    }));

    if (jsonResponse == null || jsonResponse['status'] == null) {
      print('Error retrieving conversion.');
      return null;
    } else if (jsonResponse['status'] == 'error') {
      print(jsonResponse['message']);
      return null;
    }

    return jsonResponse["conversion"].toDouble();
  }

  bool isCategorySupported(Category category) {
    bool supported = false;
    supportedCategories.forEach((it) {
      if (it["name"] == category.name) {
        supported = true;
        return;
      }
    });
    return supported;
  }

  /// Fetches from network a JSON string that is decoded to a JSON
  /// object, represented as a Dart [Map].
  Future<Map<String, dynamic>> _fetchJson(Uri uri) async {
    try {
      final request = await _httpClient.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }
      final responseBody = await response.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
