import 'package:flutter/material.dart';
import 'package:hello_rectangle/category.dart';

typedef void CategoryTapCallback(Category category);

/// A custom [CategoryTile] widget.
///
/// The widget is composed on an [Category] and [CategoryTapCallback].
class CategoryTile extends StatelessWidget {
  static final _rowHeight = 100.0;

  final CategoryTapCallback categoryTapCallback;
  final Category category;

  const CategoryTile({
    Key key,
    @required this.category,
    @required this.categoryTapCallback,
  })  : assert(category != null),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: category.color["highlight"],
        splashColor: category.color["splash"],
        borderRadius: BorderRadius.all(Radius.circular(_rowHeight / 2)),
        onTap: () {
          if (categoryTapCallback != null) categoryTapCallback(category);
        },
        child: Container(
          height: _rowHeight,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(category.iconLocation),
              ),
              Text(
                category.name,
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
