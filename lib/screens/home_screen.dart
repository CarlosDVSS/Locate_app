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

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout realizado com sucesso!')),
      );
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
    final spaces = ref.watch(filteredSpacesProvider); // Espaços filtrados
    final spacesNotifier = ref.read(spaceProvider.notifier);
    final isLoading = spacesNotifier.isLoading; // Obter estado de carregamento
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> tabs = [
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : HomeTab(spaces: spaces),
      const BooksTab(),
    ];

    // Função para recarregar os espaços quando a aba "Início" for selecionada
    void reloadSpaces() {
      // ignore: unused_result
      ref.refresh(spaceProvider);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BookEvents'),
          bottom: currentIndex == 0
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 4),
                    child: TextField(
                      onChanged: (value) {
                        ref.read(searchTermProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 16),
                        hintText: 'Pesquisar espaços...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: tabs[currentIndex], // Exibindo a aba ativa
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
            if (index == 0) {
              reloadSpaces(); // Recarrega os espaços quando "Início" é selecionado
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Reservas'),
          ],
        ),
      ),
    );
  }
}
