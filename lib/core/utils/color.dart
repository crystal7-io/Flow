// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libmonet/libmonet.dart' show DynamicScheme;
import 'package:material_color_utilities/material_color_utilities.dart'
    show Score, QuantizerResult, QuantizerCelebi;

// Material color roles in this file must be ordered in the same way as in
// [MaterialDynamicColors] class from libmonet. This ensures consistency
// with the color generation library and makes it easier to modify or introduce
// new functionality. Color roles absent from [ColorScheme] must be skipped.
// Note that [DynamicScheme.inverseOnSurface] has a different, incorrect
// name in Flutter: [ColorScheme.onInverseSurface].

extension DynamicSchemeExtension on DynamicScheme {
  ColorScheme toColorScheme({required bool lazy}) => lazy
      ? _LazyColorScheme(this)
      : ColorScheme(
          brightness: isDark ? .dark : .light,
          // ignore: deprecated_member_use
          background: Color(background),
          // ignore: deprecated_member_use
          onBackground: Color(onBackground),
          surface: Color(surface),
          surfaceDim: Color(surfaceDim),
          surfaceBright: Color(surfaceBright),
          surfaceContainerLowest: Color(surfaceContainerLowest),
          surfaceContainerLow: Color(surfaceContainerLow),
          surfaceContainer: Color(surfaceContainer),
          surfaceContainerHigh: Color(surfaceContainerHigh),
          surfaceContainerHighest: Color(surfaceContainerHighest),
          onSurface: Color(onSurface),
          // ignore: deprecated_member_use
          surfaceVariant: Color(surfaceVariant),
          onSurfaceVariant: Color(onSurfaceVariant),
          outline: Color(outline),
          outlineVariant: Color(outlineVariant),
          inverseSurface: Color(inverseSurface),
          onInverseSurface: Color(inverseOnSurface),
          shadow: Color(shadow),
          scrim: Color(scrim),
          surfaceTint: Color(surfaceTint),
          primary: Color(primary),
          onPrimary: Color(onPrimary),
          primaryContainer: Color(primaryContainer),
          onPrimaryContainer: Color(onPrimaryContainer),
          primaryFixed: Color(primaryFixed),
          primaryFixedDim: Color(primaryFixedDim),
          onPrimaryFixed: Color(onPrimaryFixed),
          onPrimaryFixedVariant: Color(onPrimaryFixedVariant),
          inversePrimary: Color(inversePrimary),
          secondary: Color(secondary),
          onSecondary: Color(onSecondary),
          secondaryContainer: Color(secondaryContainer),
          onSecondaryContainer: Color(onSecondaryContainer),
          secondaryFixed: Color(secondaryFixed),
          secondaryFixedDim: Color(secondaryFixedDim),
          onSecondaryFixed: Color(onSecondaryFixed),
          onSecondaryFixedVariant: Color(onSecondaryFixedVariant),
          tertiary: Color(tertiary),
          onTertiary: Color(onTertiary),
          tertiaryContainer: Color(tertiaryContainer),
          onTertiaryContainer: Color(onTertiaryContainer),
          tertiaryFixed: Color(tertiaryFixed),
          tertiaryFixedDim: Color(tertiaryFixedDim),
          onTertiaryFixed: Color(onTertiaryFixed),
          onTertiaryFixedVariant: Color(onTertiaryFixedVariant),
          error: Color(error),
          onError: Color(onError),
          errorContainer: Color(errorContainer),
          onErrorContainer: Color(onErrorContainer),
        );

  static Future<Color> extractColorFromImageProvider(
    ImageProvider provider, {
    bool sync = false,
  }) => _extractColorsFromImageProvider(provider, sync)
      .then(
        (quantizerResult) => quantizerResult.colorToCount.map(
          (key, value) => MapEntry(_getArgbFromAbgr(key), value),
        ),
      )
      .then((colorToCount) => Score.score(colorToCount, desired: 1))
      .then((scoredResults) => Color(scoredResults.first));

  /// Extracts bytes from an [ImageProvider] and returns a [QuantizerResult]
  /// containing the most dominant colors.
  static Future<QuantizerResult> _extractColorsFromImageProvider(
    ImageProvider imageProvider,
    bool sync,
  ) => _imageProviderToScaled(imageProvider, sync)
      .then((scaledImage) => scaledImage.toByteData())
      .then((imageBytes) => imageBytes!.buffer.asUint32List())
      .then(
        (pixels) => QuantizerCelebi().quantize(
          pixels,
          128,
          returnInputPixelToClusterPixel: true,
        ),
      );

  // Scale image size down to reduce computation time of color extraction.
  static Future<ui.Image> _imageProviderToScaled(
    ImageProvider imageProvider,
    bool sync,
  ) async {
    const maxDimension = 112.0;
    final stream = imageProvider.resolve(
      const ImageConfiguration(size: Size(maxDimension, maxDimension)),
    );
    final imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener(
      (info, sync) async {
        loadFailureTimeout?.cancel();
        stream.removeListener(listener);
        final image = info.image;
        final width = image.width;
        final height = image.height;
        var paintWidth = width.toDouble();
        var paintHeight = height.toDouble();
        assert(width > 0 && height > 0);

        final rescale = width > maxDimension || height > maxDimension;
        if (rescale) {
          paintWidth = (width > height)
              ? maxDimension
              : (maxDimension / height) * width;
          paintHeight = (height > width)
              ? maxDimension
              : (maxDimension / width) * height;
        }
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0.0, 0.0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none,
        );

        final picture = pictureRecorder.endRecording();
        scaledImage = sync
            ? picture.toImageSync(paintWidth.toInt(), paintHeight.toInt())
            : await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
        imageCompleter.complete(info.image);
      },
      onError: (exception, stackTrace) {
        loadFailureTimeout?.cancel();
        stream.removeListener(listener);
        imageCompleter.completeError(
          Exception("Failed to render image: $exception"),
          stackTrace,
        );
      },
    );

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(
        TimeoutException("Timeout occurred trying to load image"),
      );
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  static int _getArgbFromAbgr(int abgr) {
    const exceptRMask = 0xFF00FFFF;
    const onlyRMask = ~exceptRMask;
    const exceptBMask = 0xFFFFFF00;
    const onlyBMask = ~exceptBMask;
    final r = (abgr & onlyRMask) >> 16;
    final b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }
}

// ignore: must_be_immutable
final class _LazyColorScheme with Diagnosticable implements ColorScheme {
  _LazyColorScheme(
    this._scheme, {
    this._brightness,
    this._background,
    this._onBackground,
    this._surface,
    this._surfaceDim,
    this._surfaceBright,
    this._surfaceContainerLowest,
    this._surfaceContainerLow,
    this._surfaceContainer,
    this._surfaceContainerHigh,
    this._surfaceContainerHighest,
    this._onSurface,
    this._surfaceVariant,
    this._onSurfaceVariant,
    this._outline,
    this._outlineVariant,
    this._inverseSurface,
    this._onInverseSurface,
    this._shadow,
    this._scrim,
    this._surfaceTint,
    this._primary,
    this._onPrimary,
    this._primaryContainer,
    this._onPrimaryContainer,
    this._primaryFixed,
    this._primaryFixedDim,
    this._onPrimaryFixed,
    this._onPrimaryFixedVariant,
    this._inversePrimary,
    this._secondary,
    this._onSecondary,
    this._secondaryContainer,
    this._onSecondaryContainer,
    this._secondaryFixed,
    this._secondaryFixedDim,
    this._onSecondaryFixed,
    this._onSecondaryFixedVariant,
    this._tertiary,
    this._onTertiary,
    this._tertiaryContainer,
    this._onTertiaryContainer,
    this._tertiaryFixed,
    this._tertiaryFixedDim,
    this._onTertiaryFixed,
    this._onTertiaryFixedVariant,
    this._error,
    this._onError,
    this._errorContainer,
    this._onErrorContainer,
  });

  final DynamicScheme _scheme;

  Brightness? _brightness;
  Color? _background;
  Color? _onBackground;
  Color? _surface;
  Color? _surfaceDim;
  Color? _surfaceBright;
  Color? _surfaceContainerLowest;
  Color? _surfaceContainerLow;
  Color? _surfaceContainer;
  Color? _surfaceContainerHigh;
  Color? _surfaceContainerHighest;
  Color? _onSurface;
  Color? _surfaceVariant;
  Color? _onSurfaceVariant;
  Color? _outline;
  Color? _outlineVariant;
  Color? _inverseSurface;
  Color? _onInverseSurface;
  Color? _shadow;
  Color? _scrim;
  Color? _surfaceTint;
  Color? _primary;
  Color? _onPrimary;
  Color? _primaryContainer;
  Color? _onPrimaryContainer;
  Color? _primaryFixed;
  Color? _primaryFixedDim;
  Color? _onPrimaryFixed;
  Color? _onPrimaryFixedVariant;
  Color? _inversePrimary;
  Color? _secondary;
  Color? _onSecondary;
  Color? _secondaryContainer;
  Color? _onSecondaryContainer;
  Color? _secondaryFixed;
  Color? _secondaryFixedDim;
  Color? _onSecondaryFixed;
  Color? _onSecondaryFixedVariant;
  Color? _tertiary;
  Color? _onTertiary;
  Color? _tertiaryContainer;
  Color? _onTertiaryContainer;
  Color? _tertiaryFixed;
  Color? _tertiaryFixedDim;
  Color? _onTertiaryFixed;
  Color? _onTertiaryFixedVariant;
  Color? _error;
  Color? _onError;
  Color? _errorContainer;
  Color? _onErrorContainer;

  @override
  Brightness get brightness =>
      _brightness ??= (_scheme.isDark ? .dark : .light);

  @override
  Color get background => _background ??= Color(_scheme.background);

  @override
  Color get onBackground => _onBackground ??= Color(_scheme.onBackground);

  @override
  Color get surface => _surface ??= Color(_scheme.surface);

  @override
  Color get surfaceDim => _surfaceDim ??= Color(_scheme.surfaceDim);

  @override
  Color get surfaceBright => _surfaceBright ??= Color(_scheme.surfaceBright);

  @override
  Color get surfaceContainerLowest =>
      _surfaceContainerLowest ??= Color(_scheme.surfaceContainerLowest);

  @override
  Color get surfaceContainerLow =>
      _surfaceContainerLow ??= Color(_scheme.surfaceContainerLow);

  @override
  Color get surfaceContainer =>
      _surfaceContainer ??= Color(_scheme.surfaceContainer);

  @override
  Color get surfaceContainerHigh =>
      _surfaceContainerHigh ??= Color(_scheme.surfaceContainerHigh);

  @override
  Color get surfaceContainerHighest =>
      _surfaceContainerHighest ??= Color(_scheme.surfaceContainerHighest);

  @override
  Color get onSurface => _onSurface ??= Color(_scheme.onSurface);

  @override
  Color get surfaceVariant => _surfaceVariant ??= Color(_scheme.surfaceVariant);

  @override
  Color get onSurfaceVariant =>
      _onSurfaceVariant ??= Color(_scheme.onSurfaceVariant);

  @override
  Color get outline => _outline ??= Color(_scheme.outline);

  @override
  Color get outlineVariant => _outlineVariant ??= Color(_scheme.outlineVariant);

  @override
  Color get inverseSurface => _inverseSurface ??= Color(_scheme.inverseSurface);

  @override
  Color get onInverseSurface =>
      _onInverseSurface ??= Color(_scheme.inverseOnSurface);

  @override
  Color get shadow => _shadow ??= Color(_scheme.shadow);

  @override
  Color get scrim => _scrim ??= Color(_scheme.scrim);

  @override
  Color get surfaceTint => _surfaceTint ??= Color(_scheme.surfaceTint);

  @override
  Color get primary => _primary ??= Color(_scheme.primary);

  @override
  Color get onPrimary => _onPrimary ??= Color(_scheme.onPrimary);

  @override
  Color get primaryContainer =>
      _primaryContainer ??= Color(_scheme.primaryContainer);

  @override
  Color get onPrimaryContainer =>
      _onPrimaryContainer ??= Color(_scheme.onPrimaryContainer);

  @override
  Color get primaryFixed => _primaryFixed ??= Color(_scheme.primaryFixed);

  @override
  Color get primaryFixedDim =>
      _primaryFixedDim ??= Color(_scheme.primaryFixedDim);

  @override
  Color get onPrimaryFixed => _onPrimaryFixed ??= Color(_scheme.onPrimaryFixed);

  @override
  Color get onPrimaryFixedVariant =>
      _onPrimaryFixedVariant ??= Color(_scheme.onPrimaryFixedVariant);

  @override
  Color get inversePrimary => _inversePrimary ??= Color(_scheme.inversePrimary);

  @override
  Color get secondary => _secondary ??= Color(_scheme.secondary);

  @override
  Color get onSecondary => _onSecondary ??= Color(_scheme.onSecondary);

  @override
  Color get secondaryContainer =>
      _secondaryContainer ??= Color(_scheme.secondaryContainer);

  @override
  Color get onSecondaryContainer =>
      _onSecondaryContainer ??= Color(_scheme.onSecondaryContainer);

  @override
  Color get secondaryFixed => _secondaryFixed ??= Color(_scheme.secondaryFixed);

  @override
  Color get secondaryFixedDim =>
      _secondaryFixedDim ??= Color(_scheme.secondaryFixedDim);

  @override
  Color get onSecondaryFixed =>
      _onSecondaryFixed ??= Color(_scheme.onSecondaryFixed);

  @override
  Color get onSecondaryFixedVariant =>
      _onSecondaryFixedVariant ??= Color(_scheme.onSecondaryFixedVariant);

  @override
  Color get tertiary => _tertiary ??= Color(_scheme.tertiary);

  @override
  Color get onTertiary => _onTertiary ??= Color(_scheme.onTertiary);

  @override
  Color get tertiaryContainer =>
      _tertiaryContainer ??= Color(_scheme.tertiaryContainer);

  @override
  Color get onTertiaryContainer =>
      _onTertiaryContainer ??= Color(_scheme.onTertiaryContainer);

  @override
  Color get tertiaryFixed => _tertiaryFixed ??= Color(_scheme.tertiaryFixed);

  @override
  Color get tertiaryFixedDim =>
      _tertiaryFixedDim ??= Color(_scheme.tertiaryFixedDim);

  @override
  Color get onTertiaryFixed =>
      _onTertiaryFixed ??= Color(_scheme.onTertiaryFixed);

  @override
  Color get onTertiaryFixedVariant =>
      _onTertiaryFixedVariant ??= Color(_scheme.onTertiaryFixedVariant);

  @override
  Color get error => _error ??= Color(_scheme.error);

  @override
  Color get onError => _onError ??= Color(_scheme.onError);

  @override
  Color get errorContainer => _errorContainer ??= Color(_scheme.errorContainer);

  @override
  Color get onErrorContainer =>
      _onErrorContainer ??= Color(_scheme.onErrorContainer);

  @override
  ColorScheme copyWith({
    Brightness? brightness,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? shadow,
    Color? scrim,
    Color? surfaceTint,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? inversePrimary,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
  }) =>
      brightness != null &&
          background != null &&
          onBackground != null &&
          surface != null &&
          surfaceDim != null &&
          surfaceBright != null &&
          surfaceContainerLowest != null &&
          surfaceContainerLow != null &&
          surfaceContainer != null &&
          surfaceContainerHigh != null &&
          surfaceContainerHighest != null &&
          onSurface != null &&
          surfaceVariant != null &&
          onSurfaceVariant != null &&
          outline != null &&
          outlineVariant != null &&
          inverseSurface != null &&
          onInverseSurface != null &&
          shadow != null &&
          scrim != null &&
          surfaceTint != null &&
          primary != null &&
          onPrimary != null &&
          primaryContainer != null &&
          onPrimaryContainer != null &&
          primaryFixed != null &&
          primaryFixedDim != null &&
          onPrimaryFixed != null &&
          onPrimaryFixedVariant != null &&
          inversePrimary != null &&
          secondary != null &&
          onSecondary != null &&
          secondaryContainer != null &&
          onSecondaryContainer != null &&
          secondaryFixed != null &&
          secondaryFixedDim != null &&
          onSecondaryFixed != null &&
          onSecondaryFixedVariant != null &&
          tertiary != null &&
          onTertiary != null &&
          tertiaryContainer != null &&
          onTertiaryContainer != null &&
          tertiaryFixed != null &&
          tertiaryFixedDim != null &&
          onTertiaryFixed != null &&
          onTertiaryFixedVariant != null &&
          error != null &&
          onError != null &&
          errorContainer != null &&
          onErrorContainer != null
      ? ColorScheme(
          brightness: brightness,
          // ignore: deprecated_member_use
          background: background,
          // ignore: deprecated_member_use
          onBackground: onBackground,
          surface: surface,
          surfaceDim: surfaceDim,
          surfaceBright: surfaceBright,
          surfaceContainerLowest: surfaceContainerLowest,
          surfaceContainerLow: surfaceContainerLow,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          surfaceContainerHighest: surfaceContainerHighest,
          onSurface: onSurface,
          // ignore: deprecated_member_use
          surfaceVariant: surfaceVariant,
          onSurfaceVariant: onSurfaceVariant,
          outline: outline,
          outlineVariant: outlineVariant,
          inverseSurface: inverseSurface,
          onInverseSurface: onInverseSurface,
          shadow: shadow,
          scrim: scrim,
          surfaceTint: surfaceTint,
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: primaryContainer,
          onPrimaryContainer: onPrimaryContainer,
          primaryFixed: primaryFixed,
          primaryFixedDim: primaryFixedDim,
          onPrimaryFixed: onPrimaryFixed,
          onPrimaryFixedVariant: onPrimaryFixedVariant,
          inversePrimary: inversePrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          secondaryFixed: secondaryFixed,
          secondaryFixedDim: secondaryFixedDim,
          onSecondaryFixed: onSecondaryFixed,
          onSecondaryFixedVariant: onSecondaryFixedVariant,
          tertiary: tertiary,
          onTertiary: onTertiary,
          tertiaryContainer: tertiaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          tertiaryFixed: tertiaryFixed,
          tertiaryFixedDim: tertiaryFixedDim,
          onTertiaryFixed: onTertiaryFixed,
          onTertiaryFixedVariant: onTertiaryFixedVariant,
          error: error,
          onError: onError,
          errorContainer: errorContainer,
          onErrorContainer: onErrorContainer,
        )
      : brightness != null ||
            background != null ||
            onBackground != null ||
            surface != null ||
            surfaceDim != null ||
            surfaceBright != null ||
            surfaceContainerLowest != null ||
            surfaceContainerLow != null ||
            surfaceContainer != null ||
            surfaceContainerHigh != null ||
            surfaceContainerHighest != null ||
            onSurface != null ||
            surfaceVariant != null ||
            onSurfaceVariant != null ||
            outline != null ||
            outlineVariant != null ||
            inverseSurface != null ||
            onInverseSurface != null ||
            shadow != null ||
            scrim != null ||
            surfaceTint != null ||
            primary != null ||
            onPrimary != null ||
            primaryContainer != null ||
            onPrimaryContainer != null ||
            primaryFixed != null ||
            primaryFixedDim != null ||
            onPrimaryFixed != null ||
            onPrimaryFixedVariant != null ||
            inversePrimary != null ||
            secondary != null ||
            onSecondary != null ||
            secondaryContainer != null ||
            onSecondaryContainer != null ||
            secondaryFixed != null ||
            secondaryFixedDim != null ||
            onSecondaryFixed != null ||
            onSecondaryFixedVariant != null ||
            tertiary != null ||
            onTertiary != null ||
            tertiaryContainer != null ||
            onTertiaryContainer != null ||
            tertiaryFixed != null ||
            tertiaryFixedDim != null ||
            onTertiaryFixed != null ||
            onTertiaryFixedVariant != null ||
            error != null ||
            onError != null ||
            errorContainer != null ||
            onErrorContainer != null
      ? _LazyColorScheme(
          _scheme,
          brightness: brightness ?? _brightness,
          background: background ?? _background,
          onBackground: onBackground ?? _onBackground,
          surface: surface ?? _surface,
          surfaceDim: surfaceDim ?? _surfaceDim,
          surfaceBright: surfaceBright ?? _surfaceBright,
          surfaceContainerLowest:
              surfaceContainerLowest ?? _surfaceContainerLowest,
          surfaceContainerLow: surfaceContainerLow ?? _surfaceContainerLow,
          surfaceContainer: surfaceContainer ?? _surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh ?? _surfaceContainerHigh,
          surfaceContainerHighest:
              surfaceContainerHighest ?? _surfaceContainerHighest,
          onSurface: onSurface ?? _onSurface,
          surfaceVariant: surfaceVariant ?? _surfaceVariant,
          onSurfaceVariant: onSurfaceVariant ?? _onSurfaceVariant,
          outline: outline ?? _outline,
          outlineVariant: outlineVariant ?? _outlineVariant,
          inverseSurface: inverseSurface ?? _inverseSurface,
          onInverseSurface: onInverseSurface ?? _onInverseSurface,
          shadow: shadow ?? _shadow,
          scrim: scrim ?? _scrim,
          surfaceTint: surfaceTint ?? _surfaceTint,
          primary: primary ?? _primary,
          onPrimary: onPrimary ?? _onPrimary,
          primaryContainer: primaryContainer ?? _primaryContainer,
          onPrimaryContainer: onPrimaryContainer ?? _onPrimaryContainer,
          primaryFixed: primaryFixed ?? _primaryFixed,
          primaryFixedDim: primaryFixedDim ?? _primaryFixedDim,
          onPrimaryFixed: onPrimaryFixed ?? _onPrimaryFixed,
          onPrimaryFixedVariant:
              onPrimaryFixedVariant ?? _onPrimaryFixedVariant,
          inversePrimary: inversePrimary ?? _inversePrimary,
          secondary: secondary ?? _secondary,
          onSecondary: onSecondary ?? _onSecondary,
          secondaryContainer: secondaryContainer ?? _secondaryContainer,
          onSecondaryContainer: onSecondaryContainer ?? _onSecondaryContainer,
          secondaryFixed: secondaryFixed ?? _secondaryFixed,
          secondaryFixedDim: secondaryFixedDim ?? _secondaryFixedDim,
          onSecondaryFixed: onSecondaryFixed ?? _onSecondaryFixed,
          onSecondaryFixedVariant:
              onSecondaryFixedVariant ?? _onSecondaryFixedVariant,
          tertiary: tertiary ?? _tertiary,
          onTertiary: onTertiary ?? _onTertiary,
          tertiaryContainer: tertiaryContainer ?? _tertiaryContainer,
          onTertiaryContainer: onTertiaryContainer ?? _onTertiaryContainer,
          tertiaryFixed: tertiaryFixed ?? _tertiaryFixed,
          tertiaryFixedDim: tertiaryFixedDim ?? _tertiaryFixedDim,
          onTertiaryFixed: onTertiaryFixed ?? _onTertiaryFixed,
          onTertiaryFixedVariant:
              onTertiaryFixedVariant ?? _onTertiaryFixedVariant,
          error: error ?? _error,
          onError: onError ?? _onError,
          errorContainer: errorContainer ?? _errorContainer,
          onErrorContainer: onErrorContainer ?? _onErrorContainer,
        )
      : this;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(_LazyEnumProperty<Brightness>("brightness", () => brightness))
      ..add(_LazyColorProperty("background", () => background))
      ..add(_LazyColorProperty("onBackground", () => onBackground))
      ..add(_LazyColorProperty("surface", () => surface))
      ..add(_LazyColorProperty("surfaceDim", () => surfaceDim))
      ..add(_LazyColorProperty("surfaceBright", () => surfaceBright))
      ..add(
        _LazyColorProperty(
          "surfaceContainerLowest",
          () => surfaceContainerLowest,
        ),
      )
      ..add(
        _LazyColorProperty("surfaceContainerLow", () => surfaceContainerLow),
      )
      ..add(_LazyColorProperty("surfaceContainer", () => surfaceContainer))
      ..add(
        _LazyColorProperty("surfaceContainerHigh", () => surfaceContainerHigh),
      )
      ..add(
        _LazyColorProperty(
          "surfaceContainerHighest",
          () => surfaceContainerHighest,
        ),
      )
      ..add(_LazyColorProperty("onSurface", () => onSurface))
      ..add(_LazyColorProperty("surfaceVariant", () => surfaceVariant))
      ..add(_LazyColorProperty("onSurfaceVariant", () => onSurfaceVariant))
      ..add(_LazyColorProperty("outline", () => outline))
      ..add(_LazyColorProperty("outlineVariant", () => outlineVariant))
      ..add(_LazyColorProperty("inverseSurface", () => inverseSurface))
      ..add(_LazyColorProperty("onInverseSurface", () => onInverseSurface))
      ..add(_LazyColorProperty("shadow", () => shadow))
      ..add(_LazyColorProperty("scrim", () => scrim))
      ..add(_LazyColorProperty("surfaceTint", () => surfaceTint))
      ..add(_LazyColorProperty("primary", () => primary))
      ..add(_LazyColorProperty("onPrimary", () => onPrimary))
      ..add(_LazyColorProperty("primaryContainer", () => primaryContainer))
      ..add(_LazyColorProperty("onPrimaryContainer", () => onPrimaryContainer))
      ..add(_LazyColorProperty("primaryFixed", () => primaryFixed))
      ..add(_LazyColorProperty("primaryFixedDim", () => primaryFixedDim))
      ..add(_LazyColorProperty("onPrimaryFixed", () => onPrimaryFixed))
      ..add(
        _LazyColorProperty(
          "onPrimaryFixedVariant",
          () => onPrimaryFixedVariant,
        ),
      )
      ..add(_LazyColorProperty("inversePrimary", () => inversePrimary))
      ..add(_LazyColorProperty("secondary", () => secondary))
      ..add(_LazyColorProperty("onSecondary", () => onSecondary))
      ..add(_LazyColorProperty("secondaryContainer", () => secondaryContainer))
      ..add(
        _LazyColorProperty("onSecondaryContainer", () => onSecondaryContainer),
      )
      ..add(_LazyColorProperty("secondaryFixed", () => secondaryFixed))
      ..add(_LazyColorProperty("secondaryFixedDim", () => secondaryFixedDim))
      ..add(_LazyColorProperty("onSecondaryFixed", () => onSecondaryFixed))
      ..add(
        _LazyColorProperty(
          "onSecondaryFixedVariant",
          () => onSecondaryFixedVariant,
        ),
      )
      ..add(_LazyColorProperty("tertiary", () => tertiary))
      ..add(_LazyColorProperty("onTertiary", () => onTertiary))
      ..add(_LazyColorProperty("tertiaryContainer", () => tertiaryContainer))
      ..add(
        _LazyColorProperty("onTertiaryContainer", () => onTertiaryContainer),
      )
      ..add(_LazyColorProperty("tertiaryFixed", () => tertiaryFixed))
      ..add(_LazyColorProperty("tertiaryFixedDim", () => tertiaryFixedDim))
      ..add(_LazyColorProperty("onTertiaryFixed", () => onTertiaryFixed))
      ..add(
        _LazyColorProperty(
          "onTertiaryFixedVariant",
          () => onTertiaryFixedVariant,
        ),
      )
      ..add(_LazyColorProperty("error", () => error))
      ..add(_LazyColorProperty("onError", () => onError))
      ..add(_LazyColorProperty("errorContainer", () => errorContainer))
      ..add(_LazyColorProperty("onErrorContainer", () => onErrorContainer));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _LazyColorScheme &&
          _scheme == other._scheme &&
          _brightness == other._brightness &&
          _background == other._background &&
          _onBackground == other._onBackground &&
          _surface == other._surface &&
          _surfaceDim == other._surfaceDim &&
          _surfaceBright == other._surfaceBright &&
          _surfaceContainerLowest == other._surfaceContainerLowest &&
          _surfaceContainerLow == other._surfaceContainerLow &&
          _surfaceContainer == other._surfaceContainer &&
          _surfaceContainerHigh == other._surfaceContainerHigh &&
          _surfaceContainerHighest == other._surfaceContainerHighest &&
          _onSurface == other._onSurface &&
          _surfaceVariant == other._surfaceVariant &&
          _onSurfaceVariant == other._onSurfaceVariant &&
          _outline == other._outline &&
          _outlineVariant == other._outlineVariant &&
          _inverseSurface == other._inverseSurface &&
          _onInverseSurface == other._onInverseSurface &&
          _shadow == other._shadow &&
          _scrim == other._scrim &&
          _surfaceTint == other._surfaceTint &&
          _primary == other._primary &&
          _onPrimary == other._onPrimary &&
          _primaryContainer == other._primaryContainer &&
          _onPrimaryContainer == other._onPrimaryContainer &&
          _primaryFixed == other._primaryFixed &&
          _primaryFixedDim == other._primaryFixedDim &&
          _onPrimaryFixed == other._onPrimaryFixed &&
          _onPrimaryFixedVariant == other._onPrimaryFixedVariant &&
          _inversePrimary == other._inversePrimary &&
          _secondary == other._secondary &&
          _onSecondary == other._onSecondary &&
          _secondaryContainer == other._secondaryContainer &&
          _onSecondaryContainer == other._onSecondaryContainer &&
          _secondaryFixed == other._secondaryFixed &&
          _secondaryFixedDim == other._secondaryFixedDim &&
          _onSecondaryFixed == other._onSecondaryFixed &&
          _onSecondaryFixedVariant == other._onSecondaryFixedVariant &&
          _tertiary == other._tertiary &&
          _onTertiary == other._onTertiary &&
          _tertiaryContainer == other._tertiaryContainer &&
          _onTertiaryContainer == other._onTertiaryContainer &&
          _tertiaryFixed == other._tertiaryFixed &&
          _tertiaryFixedDim == other._tertiaryFixedDim &&
          _onTertiaryFixed == other._onTertiaryFixed &&
          _onTertiaryFixedVariant == other._onTertiaryFixedVariant &&
          _error == other._error &&
          _onError == other._onError &&
          _errorContainer == other._errorContainer &&
          _onErrorContainer == other._onErrorContainer;

  @override
  int get hashCode => Object.hash(
    Object.hash(
      Object.hash(
        _scheme,
        _brightness,
        _background,
        _onBackground,
        _surface,
        _surfaceDim,
        _surfaceBright,
        _surfaceContainerLowest,
        _surfaceContainerLow,
        _surfaceContainer,
        _surfaceContainerHigh,
        _surfaceContainerHighest,
        _onSurface,
        _surfaceVariant,
        _onSurfaceVariant,
        _outline,
        _outlineVariant,
        _inverseSurface,
        _onInverseSurface,
        _shadow,
      ),
      _scrim,
      _surfaceTint,
      _primary,
      _onPrimary,
      _primaryContainer,
      _onPrimaryContainer,
      _primaryFixed,
      _primaryFixedDim,
      _onPrimaryFixed,
      _onPrimaryFixedVariant,
      _inversePrimary,
      _secondary,
      _onSecondary,
      _secondaryContainer,
      _onSecondaryContainer,
      _secondaryFixed,
      _secondaryFixedDim,
      _onSecondaryFixed,
      _onSecondaryFixedVariant,
    ),
    _tertiary,
    _onTertiary,
    _tertiaryContainer,
    _onTertiaryContainer,
    _tertiaryFixed,
    _tertiaryFixedDim,
    _onTertiaryFixed,
    _onTertiaryFixedVariant,
    _error,
    _onError,
    _errorContainer,
    _onErrorContainer,
  );
}

class _LazyEnumProperty<T extends Enum?> extends DiagnosticsProperty<T> {
  _LazyEnumProperty(
    String super.name,
    super.computeValue, {
    super.defaultValue,
    super.level,
  }) : super.lazy();

  @override
  String valueToString({TextTreeConfiguration? parentConfiguration}) =>
      value?.name ?? "null";
}

class _LazyColorProperty extends DiagnosticsProperty<Color> {
  _LazyColorProperty(
    String super.name,
    super.computeValue, {
    super.showName,
    super.defaultValue,
    super.style,
    super.level,
  }) : super.lazy();

  @override
  Map<String, Object?> toJsonMap(DiagnosticsSerializationDelegate delegate) {
    final json = super.toJsonMap(delegate);
    if (value != null) {
      json["valueProperties"] = <String, Object>{
        "red": (value!.r * 255.0).round().clamp(0, 255),
        "green": (value!.g * 255.0).round().clamp(0, 255),
        "blue": (value!.b * 255.0).round().clamp(0, 255),
        "alpha": (value!.a * 255.0).round().clamp(0, 255),
      };
    }
    return json;
  }
}
