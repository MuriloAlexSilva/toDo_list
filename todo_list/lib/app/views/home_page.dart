import 'dart:io'; //File
import 'dart:async'; //Future
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
    );
  }

  Future<File> _getFile() async {
    /*Nesta função (getApplicationDocumentsDirectory()), iremos pegar o 
    diretorio que podemos adicionar os documentos do nosso app, ela já 
    adequa a questão de permissões do celular, porém como ele não é executado 
    no ato, utilizamos a função assincrona*/
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }
}
