import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontScheme {
  final String title;
  final String subtitle;
  final String body;
  final String label;
  final String input;

  const FontScheme(
      {required this.title,
        required this.subtitle,
        required this.body,
        required this.label,
        required this.input});

  FontScheme.all(String font)
      : title = font,
        subtitle = font,
        body = font,
        label = font,
        input = font;

  static FontScheme get roboto => FontScheme.all('Roboto');

  static FontScheme get ubuntu => FontScheme.all('Ubuntu');

  FontScheme copyWith(
      {String? title,
        String? subtitle,
        String? body,
        String? label,
        String? input}) {
    return FontScheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        body: body ?? this.body,
        label: label ?? this.label,
        input: input ?? this.input);
  }
}

final fonts = FontScheme.ubuntu;
final colors = ColorScheme.light();

class FontSizes {
  static double get xxsmall => 16.0.sp;

  static double get xsmall => 24.0.sp;

  static double get small => 32.0.sp;

  static double get medium => 42.0.sp;

  static double get large => 52.0.sp;

  static double get xlarge => 64.0.sp;

  static double get xxlarge => 96.0.sp;

  static double get max => 128.0.sp;

  static double get giant => 256.0.sp;
}

class IconSizes {
  static double get xxsmall => 46.0.w;

  static double get xsmall => 52.0.w;

  static double get small => 64.0.w;

  static double get medium => 72.0.w;

  static double get large => 96.0.sp;

  static double get xlarge => 128.0.w;

  static double get xxlarge => 256.0.w;

  static double get max => 512.0;
}

class Sizes {
  static double get giant => 712.0.w;
}

class Dimensions {
  static double get xxsmall => 6.0.w;

  static double get xsmall => 8.0.w;

  static double get small => 16.0.w;

  static double get medium => 24.0.w;

  static double get large => 48.0.w;

  static double get xlarge => 64.0.w;

  static double get xxlarge => 96.0.w;

  static double get giant => 256.0.w;
}

class Paddings {
  static EdgeInsets get zero => EdgeInsets.zero;

  static EdgeInsets get buttonLoose => EdgeInsets.symmetric(
      horizontal: Dimensions.xlarge, vertical: Dimensions.large);

  static EdgeInsets get containerTight => EdgeInsets.only(
      top: Dimensions.xsmall,
      left: Dimensions.xsmall,
      right: Dimensions.xsmall,
      bottom: Dimensions.xsmall);

  static EdgeInsets get label => EdgeInsets.only(
      top: Dimensions.small,
      left: Dimensions.small,
      right: Dimensions.small,
      bottom: Dimensions.large);

  static EdgeInsets get left => EdgeInsets.only(left: Dimensions.medium);

  static EdgeInsets get right => EdgeInsets.only(left: Dimensions.medium);

  static EdgeInsets get allXSmall => EdgeInsets.all(Dimensions.xsmall);

  static EdgeInsets get allSmall => EdgeInsets.all(Dimensions.small);

  static EdgeInsets get allMedium => EdgeInsets.all(Dimensions.medium);

  static EdgeInsets get allLarge => EdgeInsets.all(Dimensions.large);

  static EdgeInsets get logo => EdgeInsets.symmetric(
      horizontal: Dimensions.medium, vertical: Dimensions.medium);

  static EdgeInsets get container => EdgeInsets.symmetric(
      horizontal: Dimensions.medium, vertical: Dimensions.medium);

  static EdgeInsets get containerFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get containerXFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.xxlarge, vertical: Dimensions.xlarge);

  static EdgeInsets get card => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get cardFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.xlarge, vertical: Dimensions.large);

  static EdgeInsets get button => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get input => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get inputLoose => EdgeInsets.symmetric(
      horizontal: Dimensions.xxlarge, vertical: Dimensions.xlarge);

  static EdgeInsets get listItem => EdgeInsets.only(bottom: Dimensions.large);

  static EdgeInsets get listItemHorizontal =>
      EdgeInsets.only(left: Dimensions.small, right: Dimensions.large);

  static EdgeInsets get bottom => EdgeInsets.only(bottom: Dimensions.medium);

  static EdgeInsets get top => EdgeInsets.only(top: Dimensions.medium);
}

class BorderRadii {
  static BorderRadius get zero => BorderRadius.circular(0.0);

  static BorderRadius get small => BorderRadius.circular(16.0.w);

  static BorderRadius get medium => BorderRadius.circular(32.0.w);

  static BorderRadius get large => BorderRadius.circular(46.0.w);

  static BorderRadius get xlarge => BorderRadius.circular(64.0.w);

  static BorderRadius get xxlarge => BorderRadius.circular(96.0.w);

  static BorderRadius get max => BorderRadius.circular(128.0.w);
}

class Radii {
  static Radius get zero => Radius.circular(0.0);

  static Radius get small => Radius.circular(16.0.w);

  static Radius get medium => Radius.circular(32.0.w);

  static Radius get large => Radius.circular(46.0.w);

  static Radius get xlarge => Radius.circular(64.0.w);

  static Radius get xxlarge => Radius.circular(96.0.w);

  static Radius get max => Radius.circular(128.0.w);
}

class VSpacings {
  static SizedBox get xsmall => SizedBox(height: Dimensions.xsmall);

  static SizedBox get small => SizedBox(height: Dimensions.small);

  static SizedBox get medium => SizedBox(height: Dimensions.medium);

  static SizedBox get large => SizedBox(height: Dimensions.large);

  static SizedBox get xlarge => SizedBox(height: Dimensions.xlarge);

  static SizedBox get xxlarge => SizedBox(height: Dimensions.xxlarge);

  static SizedBox get giant => SizedBox(height: Dimensions.giant);
}

class HSpacings {
  static SizedBox get xsmall => SizedBox(width: Dimensions.xsmall);

  static SizedBox get small => SizedBox(width: Dimensions.small);

  static SizedBox get medium => SizedBox(width: Dimensions.medium);

  static SizedBox get large => SizedBox(width: Dimensions.large);

  static SizedBox get xlarge => SizedBox(width: Dimensions.xlarge);
}

class TextStyles {
  static TextStyle get giant => TextStyle(
      fontSize: FontSizes.xxlarge, color: Colors.white, fontFamily: fonts.body);

  static TextStyle get giantTitle => TextStyle(
      fontSize: FontSizes.xxlarge,
      color: Colors.white,
      height: 1.2,
      fontFamily: fonts.title);

  static TextStyle get dark => TextStyle(
      fontSize: FontSizes.medium,
      color: Colors.black,
      fontFamily: fonts.body,
      height: 1.2);

  static TextStyle get light => dark.copyWith(color: Colors.white);

  static TextStyle get muted => dark.copyWith(color: Colors.grey[600]);

  static TextStyle get error => TextStyle(
      fontSize: FontSizes.medium, color: colors.error, fontFamily: fonts.body);

  static TextStyle get input => TextStyle(
      height: 1.3,
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontFamily: fonts.input);

  static TextStyle get inputLight => input.copyWith(color: Colors.white);

  static TextStyle get inputDisabled => input.copyWith(color: Colors.black54);

  static TextStyle get title => TextStyle(
      height: 1.3,
      fontSize: FontSizes.xlarge,
      fontWeight: FontWeight.w600,
      fontFamily: fonts.title);

  static TextStyle get titleLight => title.copyWith(color: Colors.white);

  static TextStyle get subtitle =>
      TextStyle(fontSize: FontSizes.large, fontFamily: fonts.subtitle);

  static TextStyle get subtitleLight => TextStyle(
      fontSize: FontSizes.large,
      fontFamily: fonts.subtitle,
      color: Colors.white);

  static TextStyle get buttonDark => TextStyle(
      fontSize: FontSizes.medium, color: Colors.white, fontFamily: fonts.label);

  static TextStyle get buttonLight => buttonDark.copyWith(color: Colors.black);

  static TextStyle get buttonDarkSmall =>
      buttonDark.copyWith(fontSize: FontSizes.small);

  static TextStyle get buttonLightSmall =>
      buttonLight.copyWith(fontSize: FontSizes.small);

  static TextStyle get body => TextStyle(
      fontSize: FontSizes.medium, color: Colors.black, fontFamily: fonts.body);

  static TextStyle get bodyLight => body.copyWith(color: Colors.white);
}

class Shapes {
  static RoundedRectangleBorder get rounded =>
      RoundedRectangleBorder(borderRadius: BorderRadii.large);

  static RoundedRectangleBorder get maxed =>
      RoundedRectangleBorder(borderRadius: BorderRadii.max);
}

class Shadows {
  static BoxShadow get solid => BoxShadow();

  static BoxShadow get blurry =>
      BoxShadow(color: Colors.black, blurRadius: 14.0.w);

  static BoxShadow glowColor(Color color, {double? opacity}) =>
      BoxShadow(color: color.withOpacity(opacity ?? 0.54), blurRadius: 24.0.w);

  static BoxShadow get glow => glowColor(Colors.white54);

  static BoxShadow get spread => BoxShadow();
}
