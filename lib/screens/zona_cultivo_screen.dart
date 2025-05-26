import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garden_app/helper/db_helper.dart';

class ZonaCultivoScreen extends StatefulWidget {
  const ZonaCultivoScreen({super.key});

  @override
  State<ZonaCultivoScreen> createState() => _ZonaCultivoScreenState();
}

class _ZonaCultivoScreenState extends State<ZonaCultivoScreen> {
  final zonasCollection = FirebaseFirestore.instance.collection('zonas');
  final participacionesCollection = FirebaseFirestore.instance.collection(
    'participaciones',
  );
  String? userName;
  String? userRole;
  String? userId;
  Map<String, bool> zonasRegistradas = {};

  @override
  void initState() {
    super.initState();
    /*  DBHelper.eliminarBaseDeDatos().then((_) {
      debugPrint('DB eliminada');
    }); */
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        userName = data['nombre'] ?? user.email;
        userRole = data['rol'] ?? 'usuario';
        userId = user.uid;

        final registrosLocales = await DBHelper.obtenerParticipaciones(userId!);
        setState(() {
          zonasRegistradas = {
            for (var zonaId in registrosLocales) zonaId: true,
          };
        });
      }
    }
  }

  void _showParticipacionDialog(
    String zonaId,
    Map<String, dynamic> zona,
  ) async {
    if (userId == null) return;
    final yaParticipado = await DBHelper.yaParticipa(zonaId, userId!);

    if (yaParticipado) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Ya participaste'),
              content: const Text(
                'Ya registraste tu participación en esta zona.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
      );
      return;
    }

    String tareaSeleccionada = 'Siembra';

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registro de participación',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        zona['nombre'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Tamaño: ${zona['tamano']}'),
                      Text(zona['categoria'] ?? ''),
                      Text(zona['cultivo'] ?? ''),
                      const SizedBox(height: 16),
                      const Text(
                        'Tarea realizada',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 16,
                        children:
                            ['Siembra', 'Riego', 'Poda', 'Limpieza'].map((
                              tarea,
                            ) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: tarea,
                                    groupValue: tareaSeleccionada,
                                    onChanged:
                                        (value) => setState(
                                          () => tareaSeleccionada = value!,
                                        ),
                                  ),
                                  Text(tarea),
                                ],
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                          ),
                          onPressed: () async {
                            await participacionesCollection.add({
                              'usuarioId': userId,
                              'zonaId': zonaId,
                              'nombreUsuario': userName,
                              'nombreZona': zona['nombre'],
                              'tarea': tareaSeleccionada,
                              'fecha': FieldValue.serverTimestamp(),
                            });
                            await DBHelper.guardarParticipacion({
                              'zonaId': zonaId,
                              'usuarioId': userId,
                              'nombreZona': zona['nombre'],
                              'tarea': tareaSeleccionada,
                              'fecha': DateTime.now().toIso8601String(),
                            });

                            setState(() {
                              zonasRegistradas[zonaId] = true;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Registrar'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text('Logo'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Huertix',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userName ?? 'Usuario',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Zonas de cultivo',
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: zonasCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  final zonas = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: zonas.length,
                    itemBuilder: (context, index) {
                      final zonaDoc = zonas[index];
                      final zona = zonaDoc.data() as Map<String, dynamic>;
                      final zonaId = zonaDoc.id;
                      final yaRegistrado = zonasRegistradas[zonaId] ?? false;
                      final color =
                          index.isEven
                              ? const Color(0xFFDFF5E1)
                              : const Color(0xFFFFF3C2);

                      return GestureDetector(
                        onTap:
                            () =>
                                userRole != 'admin'
                                    ? _showParticipacionDialog(zonaId, zona)
                                    : null,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                zona['nombre'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Tamaño: ${zona['tamano'] ?? ''}'),
                              Text(zona['categoria'] ?? ''),
                              Text(zona['cultivo'] ?? ''),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  yaRegistrado
                                      ? 'Registrado'
                                      : (zona['estado'] ?? 'Disponible'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
