import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfileScreen extends GetView<AuthController> {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout() async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Sesi login kamu akan dihapus dari perangkat ini.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) await controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    final username = controller.username ?? 'Pengguna';
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 18),
          CircleAvatar(
            radius: 42,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 42,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            username,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kesan & pesan',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Praktikumnya enak kok dan mudah dimengerti walaupun kadang terlalu cepat (ini sebenarnya akunya sih yang lemot), tapi ya materinya mobile, dan mobile terbuat dari es teh yang menyegarkan banget :)))) (nulis ini sambil stress ngerjain latihan responsi)',
                    style: TextStyle(height: 1.5, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
