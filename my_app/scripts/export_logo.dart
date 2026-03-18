import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('export logo', () async {
    const int size = 200;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

    _drawVinyl(canvas, size.toDouble());

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final file = File('assets/images/vinyl_logo.png');
    file.parent.createSync(recursive: true);
    await file.writeAsBytes(byteData!.buffer.asUint8List());
    // ignore: avoid_print
    print('Saved: assets/images/vinyl_logo.png');
  });
}

void _drawVinyl(ui.Canvas canvas, double size) {
  final center = ui.Offset(size / 2, size / 2);
  final outerRadius = size / 2;
  
  canvas.drawCircle(center, outerRadius, ui.Paint()..color = const ui.Color(0xFF1A1A1A));

  canvas.drawCircle(
    center,
    outerRadius - 1.5 / 2,
    ui.Paint()
      ..color = const ui.Color(0xFF2A2A2A)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );

  final labelRadius = size * 0.22;
  
  final groovePaint = ui.Paint()
    ..color = const ui.Color(0xFF2A2A2A)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.6;

  final grooveStart = labelRadius + 2.0;
  final grooveEnd = outerRadius - 4.0;
  final step = (grooveEnd - grooveStart) / 5.0; // 6 rings = 5 gaps
  for (int i = 0; i < 6; i++) {
    canvas.drawCircle(center, grooveStart + step * i, groovePaint);
  }

  canvas.drawCircle(center, labelRadius, ui.Paint()..color = const ui.Color(0xFF4DB8B8));

  final spindleRadius = size * 0.05;
  canvas.drawCircle(center, spindleRadius, ui.Paint()..color = const ui.Color(0xFF111111));
}
