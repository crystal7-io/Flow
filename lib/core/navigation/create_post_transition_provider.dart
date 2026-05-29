import 'package:flutter/material.dart';

class CreatePostTransitionProvider extends ChangeNotifier {
  Animation<double>? _animation;
  Animation<double>? get animation => _animation;

  void setAnimation(Animation<double>? animation) {
    _animation = animation;
    notifyListeners();
  }
}
