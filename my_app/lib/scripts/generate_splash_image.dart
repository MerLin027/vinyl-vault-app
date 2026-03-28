import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Download fonts
  await _downloadAndLoadFont('TenorSans', 'https://github.com/google/fonts/raw/main/ofl/tenorsans/TenorSans-Regular.ttf');
  await _downloadAndLoadFont('Jost', 'https://github.com/google/fonts/raw/main/ofl/jost/Jost-Italic.ttf');

  const int width = 800;
  const int height = 600;

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    // Background
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), ui.Paint()..color = const ui.Color(0xFF111211));

    // Draw Vinyl Logo
    canvas.save();
    canvas.translate(width / 2 - 80, height / 2 - 150);
    _drawVinyl(canvas, 160, null, 0.5);
    canvas.restore();

    // Draw VinylVault text
    final pb1 = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontFamily: 'TenorSans',
      fontSize: 48, // Scaled up slightly for 800x600
    ))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xFFF5F0E8),
        letterSpacing: 6.0,
      ))
      ..addText('VinylVault');
    final p1 = pb1.build()..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p1, ui.Offset(0, height / 2 + 50));

    // Draw Tagline
    final pb2 = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontFamily: 'Jost',
      fontSize: 24,
      fontStyle: ui.FontStyle.italic,
    ))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xB3F5F0E8),
        letterSpacing: 0.6,
      ))
      ..addText('Your curated record collection');
    final p2 = pb2.build()..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p2, ui.Offset(0, height / 2 + 130));

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final file = File('assets/images/splash_logo.png');
  file.parent.createSync(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
  debugPrint('Saved: assets/images/splash_logo.png');
}

Future<void> _downloadAndLoadFont(String family, String url) async {
  final file = File('.dart_tool/$family.ttf');
  if (!file.existsSync()) {
    debugPrint('Downloading $family...');
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    await response.pipe(file.openWrite());
  }
  final fontData = await file.readAsBytes();
  final loader = FontLoader(family)..addFont(Future.value(ByteData.view(fontData.buffer)));
  await loader.load();
}

void _drawVinyl(
  ui.Canvas canvas,
  double size,
  ui.Color? background,
  double radiusFraction,
) {
  final center = ui.Offset(size / 2, size / 2);
  final outerRadius = size * radiusFraction;
  final scale = outerRadius / 30.0;
  final labelRadius = outerRadius * 0.44;
  final spindleRadius = outerRadius * 0.10;

  if (background != null) {
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, size, size), ui.Paint()..color = background);
  }

  canvas.drawCircle(center, outerRadius, ui.Paint()..color = const ui.Color(0xFF1A1C19));

  final borderWidth = 1.0 * scale;
  canvas.drawCircle(
    center,
    outerRadius - borderWidth / 2,
    ui.Paint()
      ..color = const ui.Color(0xFF2A2D2A)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = borderWidth,
  );

  final groovePaint = ui.Paint()
    ..color = const ui.Color(0xFF2A2D2A)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.6 * scale;

  final grooveStart = labelRadius + 2.0 * scale;
  final grooveEnd = outerRadius - 4.0 * scale;
  final step = (grooveEnd - grooveStart) / 5.0;
  for (int i = 0; i < 6; i++) {
    canvas.drawCircle(center, grooveStart + step * i, groovePaint);
  }

  canvas.drawCircle(center, labelRadius, ui.Paint()..color = const ui.Color(0xFF4DB8B8));
  canvas.drawCircle(center, spindleRadius, ui.Paint()..color = const ui.Color(0xFF111211));
}
