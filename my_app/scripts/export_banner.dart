import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('export banner', () async {
    const double W = 800;
    const double H = 200;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, W, H));

    // ── Background ───────────────────────────────────────────────────────────
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, W, H),
      ui.Paint()..color = const ui.Color(0xFF111111),
    );

    // ── Vinyl record (center x=100, y=100, radius=70) ────────────────────────
    const ui.Offset center = ui.Offset(100, 100);
    const double outerR = 70;

    // Outer fill
    canvas.drawCircle(
      center,
      outerR,
      ui.Paint()..color = const ui.Color(0xFF1A1A1A),
    );
    // Outer stroke
    canvas.drawCircle(
      center,
      outerR,
      ui.Paint()
        ..color = const ui.Color(0xFF2A2A2A)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 6 groove rings evenly spaced between radius 50 and 65
    final groovePaint = ui.Paint()
      ..color = const ui.Color(0xFF2A2A2A)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const double grooveStart = 50.0;
    const double grooveEnd = 65.0;
    const double step = (grooveEnd - grooveStart) / 5.0; // 6 rings → 5 gaps
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(center, grooveStart + step * i, groovePaint);
    }

    // Center label
    canvas.drawCircle(
      center,
      26,
      ui.Paint()..color = const ui.Color(0xFF4DB8B8),
    );

    // Spindle hole
    canvas.drawCircle(
      center,
      6,
      ui.Paint()..color = const ui.Color(0xFF111111),
    );

    // ── "VINYLVAULT" text ────────────────────────────────────────────────────
    final titleBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: ui.TextAlign.left,
        fontFamily: 'sans-serif',
        fontSize: 52,
        fontWeight: ui.FontWeight.w700,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xFF4DB8B8),
        fontSize: 52,
        fontWeight: ui.FontWeight.w700,
        letterSpacing: 6,
      ))
      ..addText('VINYLVAULT');

    final titlePara = titleBuilder.build();
    titlePara.layout(const ui.ParagraphConstraints(width: 580));

    // Vertically center the title: y=100 is the center, so offset by half height
    final double titleY = 100 - titlePara.height / 2;
    canvas.drawParagraph(titlePara, ui.Offset(200, titleY));

    // ── Subtitle text ─────────────────────────────────────────────────────────
    final subtitleBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: ui.TextAlign.left,
        fontFamily: 'sans-serif',
        fontSize: 18,
        fontStyle: ui.FontStyle.italic,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xFFB8A898),
        fontSize: 18,
        fontStyle: ui.FontStyle.italic,
      ))
      ..addText('Your curated record collection');

    final subtitlePara = subtitleBuilder.build();
    subtitlePara.layout(const ui.ParagraphConstraints(width: 540));
    canvas.drawParagraph(subtitlePara, const ui.Offset(202, 145));

    // ── Export ────────────────────────────────────────────────────────────────
    final picture = recorder.endRecording();
    final image = await picture.toImage(W.toInt(), H.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final file = File('assets/images/banner.png');
    file.parent.createSync(recursive: true);
    await file.writeAsBytes(byteData!.buffer.asUint8List());
    // ignore: avoid_print
    print('Saved: assets/images/banner.png');
  });
}
