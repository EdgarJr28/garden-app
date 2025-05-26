import 'package:flutter/material.dart';

class EducacionScreen extends StatelessWidget {
  const EducacionScreen({super.key});

  final List<Map<String, String>> datos = const [
    {
      'titulo': 'Compostaje',
      'descripcion':
          'Una tonelada de residuos orgánicos puede producir 300 kg de compost natural.',
      'imagen':
          'https://images.unsplash.com/photo-1579756423478-02bc82a97679?q=80&w=2022&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Huertas Urbanas',
      'descripcion':
          'Las huertas urbanas pueden reducir la temperatura ambiental en hasta 2°C.',
      'imagen':
          'https://images.unsplash.com/photo-1728492123458-43d0d8ca9c0d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Plantas Medicinales',
      'descripcion':
          'La sábila (aloe vera) tiene propiedades cicatrizantes y antiinflamatorias.',
      'imagen':
          'https://images.unsplash.com/photo-1694970660545-e74f47dfafcb?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Reciclaje',
      'descripcion':
          'Reciclar una lata de aluminio ahorra energía para ver 3 horas de televisión.',
      'imagen':
          'https://images.unsplash.com/photo-1579756423478-02bc82a97679?q=80&w=2022&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Captura de Agua',
      'descripcion':
          'Las plantas en terrazas pueden absorber hasta el 80% del agua lluvia.',
      'imagen':
          'https://images.unsplash.com/photo-1702386102154-9eb38507aa2a?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Contaminación del Suelo',
      'descripcion':
          'El plástico puede tardar hasta 1,000 años en degradarse en el suelo.',
      'imagen':
          'https://images.unsplash.com/photo-1657315304506-8c8a0028cf4b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Polinización',
      'descripcion': 'Una abeja puede visitar hasta 5,000 flores en un día.',
      'imagen':
          'https://images.unsplash.com/photo-1716275606707-5fdcd36f9ccb?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'titulo': 'Fotosíntesis',
      'descripcion':
          'Una hectárea de césped produce oxígeno para 64 personas al día.',
      'imagen':
          'https://images.unsplash.com/photo-1461907781792-c8530f80a0f5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Educación'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: datos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final item = datos[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      item['imagen']!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      item['titulo']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      item['descripcion']!,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
