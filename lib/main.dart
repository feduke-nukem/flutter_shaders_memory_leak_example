import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GlitchPage(),
    );
  }
}

class GlitchPage extends StatefulWidget {
  const GlitchPage({super.key});

  @override
  State<GlitchPage> createState() => _GlitchPageState();
}

class _GlitchPageState extends State<GlitchPage> {
  int count = 0;

  double time = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        time += 0.016;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/glitch.glsl',
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            shader
              ..setFloat(0, image.width.toDouble() / devicePixelRatio)
              ..setFloat(1, image.height.toDouble() / devicePixelRatio)
              ..setFloat(2, time)
              ..setImageSampler(0, image);

            canvas.drawPaint(Paint()..shader = shader);
          },
          child: child!,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Glitch'),
        ),
        body: Center(
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: Object(),
              onPressed: () => setState(() {
                count++;
              }),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: Object(),
              onPressed: () => setState(() {
                count--;
              }),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
