import 'package:flutter/material.dart';

class EducacionScreen extends StatelessWidget {
  const EducacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educación Ambiental')),
      body: const Center(
        child: Text(
          'Recursos educativos para aprender sobre agricultura urbana y sostenibilidad.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
