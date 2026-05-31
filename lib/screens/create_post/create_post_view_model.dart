import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  String _comment = '';
  String get comment => _comment;

  final List<String> _mediaPaths = [];
  List<String> get mediaPaths => _mediaPaths;

  double? _firstImageAspectRatio;
  double? get firstImageAspectRatio => _firstImageAspectRatio;

  double _selectedAspectRatio = 1.0;
  double get selectedAspectRatio => _selectedAspectRatio;

  int _currentCarouselIndex = 0;
  int get currentCarouselIndex => _currentCarouselIndex;

  int? _removingIndex;
  int? get removingIndex => _removingIndex;

  void setRemovingIndex(int? index) {
    _removingIndex = index;
    notifyListeners();
  }

  void setComment(String value) {
    _comment = value;
    notifyListeners();
  }

  void setSelectedAspectRatio(double ratio) {
    _selectedAspectRatio = ratio;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentCarouselIndex = index;
    notifyListeners();
  }

  Future<void> pickMedia() async {
    try {
      final List<XFile> selected = await _picker.pickMultiImage();
      if (selected.isEmpty) return;

      final bool isFirstSelection = _mediaPaths.isEmpty;

      for (var file in selected) {
        _mediaPaths.add(file.path);
      }

      if (isFirstSelection && _mediaPaths.isNotEmpty) {
        await _calculateFirstImageAspectRatio(_mediaPaths.first);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error picking media: $e");
    }
  }

  Future<void> _calculateFirstImageAspectRatio(String path) async {
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);
      if (decodedImage.width > 0 && decodedImage.height > 0) {
        _firstImageAspectRatio = decodedImage.width / decodedImage.height;
      } else {
        _firstImageAspectRatio = 1.0;
      }
    } catch (e) {
      _firstImageAspectRatio = 1.0;
    }
  }

  void removeMediaAtIndex(int index) {
    if (index >= 0 && index < _mediaPaths.length) {
      _mediaPaths.removeAt(index);

      if (_mediaPaths.isEmpty) {
        _firstImageAspectRatio = null;
        _currentCarouselIndex = 0;
        notifyListeners();
        return;
      }

      _clampIndex();
      notifyListeners(); // Notify list change immediately to avoid visual lag

      // If we deleted the first image, re-calculate the aspect ratio for the new first image
      if (index == 0) {
        _calculateFirstImageAspectRatio(_mediaPaths.first).then((_) {
          notifyListeners(); // Notify again after aspect ratio is updated
        });
      }
    }
  }

  void _clampIndex() {
    if (_mediaPaths.isEmpty) {
      _currentCarouselIndex = 0;
    } else if (_currentCarouselIndex >= _mediaPaths.length) {
      _currentCarouselIndex = _mediaPaths.length - 1;
    }
    if (_currentCarouselIndex < 0) _currentCarouselIndex = 0;
  }
}
