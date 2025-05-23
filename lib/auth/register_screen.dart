import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final zoneController = TextEditingController();
  final daysController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .set({
              'nombre': nameController.text.trim(),
              'correo': emailController.text.trim(),
              'telefono': phoneController.text.trim(),
              'zona': zoneController.text.trim(),
              'diasDisponibles': daysController.text.trim(),
              'uid': uid,
            })
            .catchError((e) {
              debugPrint("🔥 Error en Firestore: $e");
            });
      }

      await FirebaseAuth.instance.currentUser?.reload();
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Cierra el loading
      Navigator.of(context).pop(); // Cierra el formulario y vuelve al AuthGate
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      String mensajeError;
      switch (e.code) {
        case 'email-already-in-use':
          mensajeError = 'Este correo ya está registrado.';
          break;
        case 'weak-password':
          mensajeError = 'La contraseña es muy débil.';
          break;
        default:
          mensajeError = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensajeError)));
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('>>> Error inesperado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado. Intenta más tarde.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(title: const Text('Registro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Card(
              color: const Color(0xFFE6F4EA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.eco, size: 64, color: Color(0xFF2E7D32)),
                      const SizedBox(height: 12),
                      const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Campo obligatorio'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator:
                            (value) =>
                                value == null || !value.contains('@')
                                    ? 'Correo inválido'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator:
                            (value) =>
                                value == null || value.length < 7
                                    ? 'Teléfono inválido'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: zoneController,
                        decoration: const InputDecoration(
                          labelText: 'Zona de residencia',
                          prefixIcon: Icon(Icons.map),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Campo obligatorio'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: daysController,
                        decoration: const InputDecoration(
                          labelText: 'Días disponibles',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Campo obligatorio'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator:
                            (value) =>
                                value != null && value.length < 6
                                    ? 'Mínimo 6 caracteres'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: registerUser,
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
