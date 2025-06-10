import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_lista.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => TelaLogin(),
      '/lista': (context) => TelaLista(),
    },
  ));
}
