import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garden_app/screens/zona_cultivo_screen.dart';
import 'package:garden_app/screens/perfil_screen.dart';
import 'package:garden_app/screens/mi_participacion_screen.dart';
import 'package:garden_app/screens/educacion_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: const BoxDecoration(
                color: Color(0xFF1B5E20),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.eco, color: Color(0xFF1B5E20)),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Huertix',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Francisco Pupo',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDashboardCard(
                    context,
                    color: const Color(0xFFB9F6CA),
                    title: 'Zonas de cultivo',
                    description:
                        'Visualiza y explora las distintas parcelas del huerto, con información sobre cultivos activos, responsables y estado actual.',
                    icon: Icons.nature,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ZonaCultivoScreen(),
                          ),
                        ),
                  ),
                  _buildDashboardCard(
                    context,
                    color: const Color(0xFFFFF59D),
                    title: 'Mi Participación',
                    description:
                        'Consulta tu historial de actividades en el huerto, el tiempo dedicado y tareas realizadas.',
                    icon: Icons.history,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MiParticipacionScreen(),
                          ),
                        ),
                  ),
                  _buildDashboardCard(
                    context,
                    color: const Color(0xFFB3E5FC),
                    title: 'Educación',
                    description:
                        'Sección educativa para promover prácticas sostenibles y conocimientos básicos sobre agricultura urbana.',
                    icon: Icons.school,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EducacionScreen(),
                          ),
                        ),
                  ),
                  _buildDashboardCard(
                    context,
                    color: const Color(0xFFFFCCBC),
                    title: 'Perfil',
                    description: 'Consulta tu información personal registrada.',
                    icon: Icons.person,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PerfilScreen(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required Color color,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, size: 48, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
