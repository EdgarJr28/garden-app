import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ZonaCultivoScreen extends StatefulWidget {
  const ZonaCultivoScreen({super.key});

  @override
  State<ZonaCultivoScreen> createState() => _ZonaCultivoScreenState();
}

class _ZonaCultivoScreenState extends State<ZonaCultivoScreen> {
  final zonasCollection = FirebaseFirestore.instance.collection('zonas');
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get();
      setState(() {
        userName = doc.data()?['nombre'] ?? user.email;
      });
    }
  }

  void _showAddZonaDialog() {
    final nombreController = TextEditingController();
    final tamanoController = TextEditingController();
    final categoriaController = TextEditingController();
    final cultivoController = TextEditingController();
    String estadoSeleccionado = 'Disponible';

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nueva Zona de Cultivo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(nombreController, 'Nombre', Icons.label),
                    _buildTextField(
                      tamanoController,
                      'Tamaño',
                      Icons.straighten,
                    ),
                    _buildTextField(
                      categoriaController,
                      'Categoría',
                      Icons.category,
                    ),
                    _buildTextField(cultivoController, 'Cultivo', Icons.grass),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        value: estadoSeleccionado,
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          prefixIcon: const Icon(Icons.flag),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items:
                            [
                                  'Disponible',
                                  'Ocupado',
                                  'En mantenimiento',
                                  'Pendiente',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              estadoSeleccionado = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                          ),
                          onPressed: () async {
                            await zonasCollection.add({
                              'nombre': nombreController.text,
                              'tamano': tamanoController.text,
                              'categoria': categoriaController.text,
                              'cultivo': cultivoController.text,
                              'estado': estadoSeleccionado,
                            });
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
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
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final zonas = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: zonas.length,
                    itemBuilder: (context, index) {
                      final zona = zonas[index].data() as Map<String, dynamic>;
                      final color =
                          index.isEven
                              ? const Color(0xFFDFF5E1)
                              : const Color(0xFFFFF3C2);
                      return Container(
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
                                zona['estado'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add),
        onPressed: _showAddZonaDialog,
      ),
    );
  }
}
