import 'package:flutter/material.dart';

class MiParticipacionScreen extends StatelessWidget {
  const MiParticipacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Participación')),
      body: const Center(
        child: Text(
          'Aquí podrás ver tu historial de actividades y tareas realizadas en el huerto.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
