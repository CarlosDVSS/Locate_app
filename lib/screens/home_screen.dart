import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_app/providers/space_provider.dart';
import 'package:locate_app/screens/tabs/books_tab.dart';
import 'package:locate_app/screens/tabs/home_tab.dart';
import 'login.dart'; 

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Função para fazer logout
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout realizado com sucesso!')),
      );
      // Redireciona para a tela de login após o logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(filteredSpacesProvider);
    int _currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> _tabs = [
      HomeTab(spaces: spaces),
      BooksTab()
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BookEvents'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50), 
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 4),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchTermProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  hintText: 'Pesquisar espaços...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _logout(context), 
            ),
          ],
        ),
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Reservas'
            ),
          ],
        ),
      ),
    );
  }
}
