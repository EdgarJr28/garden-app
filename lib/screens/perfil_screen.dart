import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();
    return doc.data();
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No se encontró información del usuario.'),
          );
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: const Text('Perfil de Usuario')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoTile('Nombre', data['nombre'] ?? ''),
                _buildInfoTile('Correo', data['correo'] ?? ''),
                _buildInfoTile('Teléfono', data['telefono'] ?? ''),
                _buildInfoTile('Zona', data['zona'] ?? ''),
                _buildInfoTile(
                  'Días disponibles',
                  data['diasDisponibles'] ?? '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
