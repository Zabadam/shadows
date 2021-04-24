/// ## 👥 Shadows
/// Provides 👓 [BoxShadowUtils] extension on [BoxShadow]
/// for manipulation of shadows by [copyWith].
/// - Consider the `operator` overrides for even simpler syntax.
///
/// Provides ⛅ [BoxShadowsUtils] extension on `List<BoxShadow>`
/// for mass shadow manipulation.
///
/// Provides 🕴 [Elevation] class with static methods used to simply
/// produce [BoxDecoration]s from Flutter's top-level [kElevationToShadow].
///
/// ### Reference
/// - 👓 [BoxShadowUtils] extension on [BoxShadow]
///   - 📋 [copyWith] Copy With replacement properties
///   - ❌ [*] "Multiply" `this` [BoxShadow] by a `Color`
///   - ❌ [*] "Multiply" `this` [blurRadius] by a `num`
///   - ➕ [+] "Add" to `this` [spreadRadius] a `double smudgeSpread`
///   - ➖ [-] "Subtract" from `this` [spreadRadius] a `double squishSpread`
///   - 📏 [%] "Modulate" `this` [offset] by `Offset` [offsetScale]
/// - ⛅ [BoxShadowsUtils] extension on `List<BoxShadow>`
///   - 🎨 [colorize] a `List<BoxShadow>` with single `[Color]` or `List` [colors]
///     - Optionally ❓ [preserveOpacity] of the originals
///   - 📊 [rampOpacity] of a `List<BoxShadow>` with single `[double]` or `List` [stops]
///     - Optionally 🎨 override a [color] and ramp simultaneously
/// - 🕴 [Elevation]'s static decoration methods
///   - [Elevation.asBoxShadows]`(double elevation, {Color? color})`
///   - [Elevation.asBoxDecoration]`(double elevation, {Color? color})`
/// - [ElevationUtils] extension on `List<BoxShadow>`
///   - 🟦 [materialize] will apply the Material-standard
///   shadow opacity map [kElevationShadowOpacityRamp] to a `List<BoxShadow>`
library shadows;

export 'package:flutter/painting.dart'
    show BoxDecoration, BoxShadow, Color, Offset;
export 'package:flutter/material.dart' show kElevationToShadow;

export 'src/elevation.dart';
export 'src/utils.dart';
