import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_app/providers/space_provider.dart';
import 'login.dart'; 

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

    return Scaffold(
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
      body: spaces.isEmpty
        ? const Center(
          child: Text(
            'Nenhum Espaço encontrado...', 
            style: TextStyle(
              fontSize: 18,
              color: Colors.red
            ),
          ),
        ) :
      ListView.builder(
        itemCount: spaces.length,
        itemBuilder: (context, index) {
          final space = spaces[index];

          return GestureDetector(
            onTap: () => {},
            child: Card(
              color: Colors.grey[900],
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: ListTile(
                leading: Image.asset(
                  space.imageUri,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(space.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.available ? 'Disponível' : 'Ocupado',
                      style: TextStyle(
                        color: space.available ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      space.active ? 'Ativo' : 'Inativo',
                      style: TextStyle(
                        color: space.active ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ), 
              ),
            ),
          );
        },
      ),
    );
  }
}
