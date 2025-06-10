import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBD() async {
    final caminho = await getDatabasesPath();
    final local = join(caminho, "bancodados.db");

    var retorno = await openDatabase(
      local,
      version: 1,
      onCreate: (db, dbVersaoRecente) {
        String sql = "CREATE TABLE usuarios ("
            "matricula TEXT PRIMARY KEY, "
            "nome TEXT, "
            "idade INTEGER, "
            "curso TEXT)";
        db.execute(sql);
      },
    );

    print("Aberto ${retorno.isOpen.toString()}");
    return retorno;
  }

  _salvarDados(BuildContext context, String nome, int idade, String matricula, String curso) async {
    Database db = await _recuperarBD();

    Map<String, dynamic> dadosUsuario = {
      "matricula": matricula,
      "nome": nome,
      "idade": idade,
      "curso": curso,
    };

    try {
      await db.insert("usuarios", dadosUsuario);
      _mostrarDialogo(context, "Usuário salvo com sucesso!");
    } catch (e) {
      _mostrarDialogo(context, "Erro ao salvar: matrícula já existe.");
    }
  }

  _mostrarDialogo(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Resultado"),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  _listarUsuarios() async {
    Database db = await _recuperarBD();
    List usuarios = await db.query("usuarios");

    for (var usu in usuarios) {
      print("Matricula: ${usu['matricula']} | Nome: ${usu['nome']} | Idade: ${usu['idade']} | Curso: ${usu['curso']}");
    }
  }

  _listarUmUsuario(BuildContext context, String matricula) async {
    Database db = await _recuperarBD();

    List usuarios = await db.query(
      "usuarios",
      where: "matricula = ?",
      whereArgs: [matricula],
    );

    if (usuarios.isNotEmpty) {
      var usuario = usuarios.first;
      _mostrarDialogo(context,
          "Matrícula: ${usuario['matricula']}\nNome: ${usuario['nome']}\nIdade: ${usuario['idade']}\nCurso: ${usuario['curso']}");
    } else {
      _mostrarDialogo(context, "Usuário com matrícula $matricula não encontrado.");
    }
  }

  _excluirUsuario(BuildContext context, String matricula) async {
    Database db = await _recuperarBD();

    int retorno = await db.delete(
      "usuarios",
      where: "matricula = ?",
      whereArgs: [matricula],
    );

    if (retorno > 0) {
      _mostrarDialogo(context, "Usuário com matrícula $matricula excluído com sucesso.");
    } else {
      _mostrarDialogo(context, "Nenhum usuário com matrícula $matricula foi encontrado.");
    }
  }

  _atualizarUsuario(BuildContext context, String matricula, String? nome, int? idade, String? curso) async {
    Database db = await _recuperarBD();

    Map<String, dynamic> dadosUsuario = {};
    if (nome != null && nome.isNotEmpty) dadosUsuario["nome"] = nome;
    if (idade != null) dadosUsuario["idade"] = idade;
    if (curso != null && curso.isNotEmpty) dadosUsuario["curso"] = curso;

    if (dadosUsuario.isNotEmpty) {
      int retorno = await db.update(
        "usuarios",
        dadosUsuario,
        where: "matricula = ?",
        whereArgs: [matricula],
      );

      if (retorno > 0) {
        _mostrarDialogo(context, "Usuário com matrícula $matricula atualizado com sucesso.");
      } else {
        _mostrarDialogo(context, "Usuário não encontrado.");
      }
    } else {
      _mostrarDialogo(context, "Nenhuma informação para atualizar.");
    }
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _matriculaController,
                decoration: const InputDecoration(labelText: 'Matrícula'),
              ),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _cursoController,
                decoration: const InputDecoration(labelText: 'Curso'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _salvarDados(
                    context,
                    _nomeController.text,
                    int.tryParse(_idadeController.text) ?? 0,
                    _matriculaController.text,
                    _cursoController.text,
                  );
                },
                child: const Text("Salvar um usuário"),
              ),
              ElevatedButton(
                onPressed: _listarUsuarios,
                child: const Text("Listar todos os usuários (Console)"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_matriculaController.text.isNotEmpty) {
                    _listarUmUsuario(context, _matriculaController.text);
                  } else {
                    _mostrarDialogo(context, "Insira a matrícula para buscar.");
                  }
                },
                child: const Text("Listar um usuário"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_matriculaController.text.isNotEmpty) {
                    _excluirUsuario(context, _matriculaController.text);
                  } else {
                    _mostrarDialogo(context, "Insira a matrícula para excluir.");
                  }
                },
                child: const Text("Excluir usuário"),
              ),
              ElevatedButton(
                onPressed: () {
                  _atualizarUsuario(
                    context,
                    _matriculaController.text,
                    _nomeController.text,
                    int.tryParse(_idadeController.text),
                    _cursoController.text,
                  );
                },
                child: const Text("Atualizar usuário"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
