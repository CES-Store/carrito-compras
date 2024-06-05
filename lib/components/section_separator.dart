import 'package:flutter/material.dart';

import '../pages/helpers/styles.dart';

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.0),
      color: Styles.lightGrayColor,
      height: 1,
    );
  }
}
