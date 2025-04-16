import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).value;
    _usernameController = TextEditingController(text: user?.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authStateProvider.notifier).updateProfile(
        username: _usernameController.text,
      );
    }
  }

  Future<void> _logout() async {
    await ref.read(authStateProvider.notifier).logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Utilisateur non connecté'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatar != null
                          ? NetworkImage(user.avatar!)
                          : null,
                      child: user.avatar == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom d\'utilisateur',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${user.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _updateProfile,
                      child: authState.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Mettre à jour le profil'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 