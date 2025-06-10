import 'package:flutter/material.dart';

class TelaLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String nome = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Bem vindo(a), $nome")),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Alerta"),
                  content: Text("Você clicou no item ${index + 1}"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text("Sim")),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text("Não")),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
