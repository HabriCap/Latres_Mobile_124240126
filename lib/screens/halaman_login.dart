import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await Get.find<AuthController>().login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB45C).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      color: Color(0xFFFFB45C),
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Cerita bagus,\ndi satu layar.',
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w800, height: 1.12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Masuk untuk menjelajahi serial pilihanmu.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 34),
                  TextField(
                    key: const Key('username-field'),
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('password-field'),
                    controller: _passwordController,
                    obscureText: true,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Obx(() {
                    final error = authController.errorMessage.value;
                    if (error == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 22),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _submit,
                        child: authController.isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Masuk'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      'Gunakan NIM ${AuthController.studentId} dan password '
                      '${AuthController.password}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
