import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _mostrarAlerta(BuildContext context, String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: InputDecoration(labelText: 'Nome')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _senhaController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Entrar"),
              onPressed: () {
                String email = _emailController.text;
                String senha = _senhaController.text;
                String nome = _nomeController.text;

                if (email == 'admin@admin.com' && senha == '12345') {
                  Navigator.pushNamed(context, '/lista', arguments: nome);
                } else {
                  _mostrarAlerta(context, "Dados inválidos", "Usuário e/ou senha incorreto(a).");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
