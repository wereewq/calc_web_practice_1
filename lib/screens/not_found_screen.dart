import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  final String location;
  const NotFoundScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Страница не найдена (404)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 80, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text('404', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Адрес "$location" не существует в данном приложении.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('На главную страницу'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}