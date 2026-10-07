import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:ripped/core/design/brand.dart';

/// Guards the generated brand files (tool/gen_brand.py): store graphics at
/// the sizes Google Play requires, every launcher density, the splash
/// resources, and a kit in every colourway that matches the in-app logo.
void main() {
  img.Image load(String path) => img.decodePng(File(path).readAsBytesSync())!;

  test('Play Store icon is 512 x 512, opaque and under 1 MB', () {
    final file = File('store/play_icon_512.png');
    final icon = load(file.path);
    expect((icon.width, icon.height), (512, 512));
    expect(icon.numChannels, 3);
    expect(file.lengthSync(), lessThan(1024 * 1024));
  });

  test('feature graphic is 1024 x 500', () {
    final graphic = load('store/feature_graphic_1024x500.png');
    expect((graphic.width, graphic.height), (1024, 500));
  });

  test('launcher icons exist at every density', () {
    const sizes = {
      'mdpi': 48,
      'hdpi': 72,
      'xhdpi': 96,
      'xxhdpi': 144,
      'xxxhdpi': 192,
    };
    for (final MapEntry(key: density, value: px) in sizes.entries) {
      for (final name in ['ic_launcher', 'ic_launcher_round']) {
        final icon = load('android/app/src/main/res/mipmap-$density/$name.png');
        expect((icon.width, icon.height), (px, px), reason: '$density $name');
      }
    }
  });

  test('vector resources and the shrinker keep rule are present', () {
    const res = 'android/app/src/main/res';
    for (final path in [
      '$res/drawable/ic_launcher_foreground.xml',
      '$res/drawable/ic_launcher_monochrome.xml',
      '$res/drawable/ic_notification.xml',
      '$res/drawable/splash_branding.xml',
      '$res/drawable/launch_background.xml',
      '$res/mipmap-anydpi-v26/ic_launcher.xml',
      '$res/mipmap-anydpi-v26/ic_launcher_round.xml',
    ]) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    expect(
      File('$res/raw/keep.xml').readAsStringSync(),
      contains('@drawable/ic_notification'),
    );
  });

  test('the splash shows the mark and the wordmark on every Android', () {
    const res = 'android/app/src/main/res';
    final modern = File('$res/values-v31/styles.xml').readAsStringSync();
    expect(modern, contains('@drawable/ic_launcher_foreground'));
    expect(modern, contains('@drawable/splash_branding'));
    final legacy = File('$res/drawable/launch_background.xml')
        .readAsStringSync();
    expect(legacy, contains('@drawable/ic_launcher_foreground'));
    expect(legacy, contains('@drawable/splash_branding'));
  });

  test('the kit has every colourway, in the colours the app draws', () {
    String hex(Color c) =>
        '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}'
            .toUpperCase();
    for (final logo in BrandLogo.values) {
      for (final kind in ['mark', 'icon', 'icon', 'lockup', 'lockup']) {
        expect(
          File('assets/brand/svg/${kind}_${logo.name}.svg').existsSync(),
          isTrue,
          reason: '$kind ${logo.name}',
        );
      }
      final icon = File('assets/brand/svg/icon_${logo.name}.svg')
          .readAsStringSync();
      expect(icon, startsWith('<svg'));
      // One tile, then one rect per plate, one of them in the accent.
      expect('<rect'.allMatches(icon).length, BrandGeometry.plates.length + 1);
      expect(icon, contains('fill="${hex(logo.bg)}"'));
      expect(icon, contains('fill="${hex(logo.plate)}"'));
      expect('fill="${hex(logo.accent)}"'.allMatches(icon).length, 1);
    }
    for (final name in ['mark_white', 'mark_black', 'lockup_white']) {
      expect(File('assets/brand/svg/$name.svg').existsSync(), isTrue);
    }
  });

  test('the store and launcher icons are the primary colourway', () {
    final icon = load('store/play_icon_512.png');
    final corner = icon.getPixel(4, 4);
    final bg = BrandLogo.volt.bg.toARGB32();
    expect(
      (corner.r.toInt(), corner.g.toInt(), corner.b.toInt()),
      ((bg >> 16) & 0xFF, (bg >> 8) & 0xFF, bg & 0xFF),
    );
  });
}
