

import 'package:flutter/material.dart';

void showSnackBarWithViewBag(BuildContext context, String s) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$s"),
    action: SnackBarAction(label: "Sepeti Gör", onPressed:()=> Navigator.of(context).pushNamed("/cartDetail"),),
  ),
  );
}

void showOnlySnackBar(BuildContext context, String s) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$s"),),
  );
}