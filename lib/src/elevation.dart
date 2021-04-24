/// ## 🕴 Elevation
/// Provides abstract class [Elevation] with static decoration methods.
/// These methods specialize in handling Flutter top-level
/// `Map<int, List<BoxShadow>>` [kElevationToShadow].
///
/// Provides [ElevationUtils] which utilize [BoxShadowsUtils] with
/// Material elevation in mind.
///
/// ### Reference
/// - 🕴 [Elevation]'s static decoration methods
///   - [Elevation.asBoxShadows]`(double elevation, {Color? color})`
///   - [Elevation.asBoxDecoration]`(double elevation, {Color? color})`
/// - [ElevationUtils] extension on `List<BoxShadow>`
///   - 🟦 [materialize] will apply the Material-standard
///   shadow opacity map [kElevationShadowOpacityRamp] to a `List<BoxShadow>`
library curtains;

import '../shadows.dart';

///     🟦 [0.2, 0.14, 0.12]
/// Considering the shadows in [kElevationToShadow] use these three `Color`s:
/// ```
/// const Color _kKeyUmbraOpacity = Color(0x33000000); // opacity = 0.2
/// const Color _kKeyPenumbraOpacity = Color(0x24000000); // opacity = 0.14
/// const Color _kAmbientShadowOpacity = Color(0x1F000000); // opacity = 0.12
/// ```
const kElevationShadowOpacityRamp = [0.2, 0.14, 0.12];

/// Looks pretty close to `Material(elevation: 100)`.
const _kArbitraryElevation100 = <BoxShadow>[
  BoxShadow(
    offset: Offset(0.0, 160.0),
    blurRadius: 50.0,
    // spreadRadius: -35.0,
    spreadRadius: -50.0,
    color: Color(0x33000000),
  ),
  BoxShadow(
    offset: Offset(0.0, 100.0),
    blurRadius: 150.0,
    // spreadRadius: 12.5,
    spreadRadius: -25.0,
    color: Color(0x24000000),
  ),
  BoxShadow(
    offset: Offset(0.0, 35.0),
    blurRadius: 250.0,
    // spreadRadius: 25.0,
    spreadRadius: -10.0,
    color: Color(0x1F000000),
  ),
];

final _elevationKeys = kElevationToShadow.keys;

/// ### 🕴 [Elevation] `double => <BoxShadow>[]`
/// Recreation of [Material.elevation] utilizing Flutter's top-level
/// `Map<int, List<BoxShadow>` [kElevationToShadow].
///
/// ### That map only contains values for
/// > ## `key`: `0, 1, 2, 3, 4, 6, 8, 9, 12, 16, 24`
///
/// [Elevation]'s decoration methods will utilize
/// the largest valid `key` that is at least equal to this [elevation]
/// as well as the next highest available `key`, and [BoxShadow.lerpList]
/// the two (where `t` for `lerpList` is the percentage between
/// these two `key`s that [elevation] sits ).
///
/// ### Requests in range `24 < elevation <= 100`
/// `lerp` between established `kElevationToShadow.last`
/// and [Elevation]-created [_kArbitraryElevation100].
///
///___
///
/// Left `null`, `color` defaults to three different `Color`s for
/// three different [BoxShadow]s, as seen in [kElevationToShadow]:
/// ```
/// const Color _kKeyUmbraOpacity = Color(0x33000000); // opacity = 0.2
/// const Color _kKeyPenumbraOpacity = Color(0x24000000); // opacity = 0.14
/// const Color _kAmbientShadowOpacity = Color(0x1F000000); // opacity = 0.12
/// ```
/// - Providing a [color] will maintain these opacities in the
/// resultant `List<BoxShadow>`.
///   - Set [preserveOpacity] `false` to use the passed [color]'s `opacity`.
abstract class Elevation {
  /// ### [kElevationToShadow] only contains values for
  /// > ### `key`: `0, 1, 2, 3, 4, 6, 8, 9, 12, 16, 24`
  ///
  /// Optionally override the [color] of the [kElevationToShadow] shadows;
  /// further set [preserveOpacity] `false` to override
  /// the Material-standard shadow opacities with that of [color].
  ///
  /// If [elevation] is a value not directly found in [kElevationToShadow],
  /// [asBoxShadows] will `lerp` between the two closest options.
  ///
  /// ### Requests in range `24 < elevation <= 100`
  /// `lerp` between established `kElevationToShadow.last`
  /// and [Elevation]-created [_kArbitraryElevation100].
  ///
  /// See 🕴 [Elevation] documentation for more information.
  static List<BoxShadow> asBoxShadows(
    double elevation, {
    Color? color,
    bool preserveOpacity = true,
  }) {
    final List<Color> _color = (color == null) ? const [] : [color];

    /// Easy case where requested [elevation] has
    /// an exact match in [kElevationToShadow] or if
    /// [elevation] is beyond even [_kArbitraryElevation100]
    if (_elevationKeys.contains(elevation))
      return kElevationToShadow[elevation]!.colorize(
        _color,
        preserveOpacity: preserveOpacity,
      );
    else if (elevation >= 100)
      return _kArbitraryElevation100.colorize(
        _color,
        preserveOpacity: preserveOpacity,
      );

    final _highestKey = _elevationKeys.lastWhere((key) => key <= elevation);
    var _nextHighestKey =
        _elevationKeys.firstWhere((key) => key > elevation, orElse: () => 100);

    /// If requested [elevation] is beyond the scope of [kElevationToShadow],
    /// `lerp` with [_kArbitraryElevation100].
    return BoxShadow.lerpList(
        kElevationToShadow[_highestKey]!.colorize(
          _color,
          preserveOpacity: preserveOpacity,
        ),
        ((_nextHighestKey == 100)
                ? _kArbitraryElevation100
                : kElevationToShadow[_nextHighestKey]!)
            .colorize(
          _color,
          preserveOpacity: preserveOpacity,
        ),
        (elevation - _highestKey) / (_nextHighestKey - _highestKey))!;
  }

  /// ### [kElevationToShadow] only contains values for
  /// > ### `key`: `0, 1, 2, 3, 4, 6, 8, 9, 12, 16, 24`
  ///
  /// Optionally override the [color] of the [kElevationToShadow] shadows;
  /// further set [preserveOpacity] `false` to override
  /// the Material-standard shadow opacities with that of [color].
  ///
  /// If [elevation] is a value not directly found in [kElevationToShadow],
  /// [asBoxShadows] will `lerp` between the two closest options.
  ///
  /// ### Requests in range `24 < elevation <= 100`
  /// `lerp` between established `kElevationToShadow.last`
  /// and [Elevation]-created [_kArbitraryElevation100].
  ///
  /// See 🕴 [Elevation] documentation for more information.
  static BoxDecoration asBoxDecoration(
    double elevation, {
    Color? color,
    bool preserveOpacity = true,
  }) =>
      BoxDecoration(
          boxShadow: Elevation.asBoxShadows(
        elevation,
        color: color,
        preserveOpacity: preserveOpacity,
      ));
}

/// Provides 🟦 [materialize] for a tuple of `BoxShadow`s.
extension ElevationUtils on List<BoxShadow> {
  /// Apply 🟦 [kElevationShadowOpacityRamp] to `this` as
  /// 📊 [rampOpacity] parameter `stops`.
  ///
  /// ### Optionally
  /// Apply a single new 🎨 [color] for each
  /// [BoxShadow.color] in `this` simultaneously.
  List<BoxShadow> materialize({Color? color}) {
    if (length == 0)
      return this;
    else if (length == 3)
      return this.rampOpacity(kElevationShadowOpacityRamp, color: color);
    else {
      // assert(false, '[materialize] is intended for `List<BoxShadow>` defined by `kElevationToShadow`, which contain 3x `BoxShadow` entries.');
    }
    // If there are more than three entries in `this`, then
    // `kElevationShadowOpacityRamp.last` is applied to any after the third.
    return this.rampOpacity(kElevationShadowOpacityRamp, color: color);
  }
}
