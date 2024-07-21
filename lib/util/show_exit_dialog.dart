import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showExitDialog(bool didPop, BuildContext context) {
  if (didPop) {
    return;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Do you want to exit an App'),
      actions: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text("NO"),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => SystemNavigator.pop(),
          child: const Text(
            "YES",
          ),
        ),
      ],
    ),
  );
}
