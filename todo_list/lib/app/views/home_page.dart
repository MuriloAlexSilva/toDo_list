import 'dart:io'; //File
import 'dart:async'; //Future
import 'dart:convert'; //Arquivos json
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 17, top: 1, right: 7, bottom: 1),
            child: Row(
              children: [
                Expanded(
                  //Necessitamos colocar o expanded para o app saber qual o
                  //tamanho do textField, assim ele irá colocar o textField
                  //no maximo que ele puder.
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.blueAccent,
                  child: Text('ADD'),
                  textColor: Colors.white,
                )
              ],
            ),
          )
        ],
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
    //o nome data podemos alterar para o nome desejado
  }

  Future<File> _saveData() async {
    /*Aqui estamos pegando a todoList transformando em json e armazenando
    em uma String com o nome de data
    */
    String data = jsonEncode(_toDoList);
    //Precisamos colocar o await pq o getFile é um valor futuro
    final file = await _getFile();
    //Aqui iremos escrever o arquivo data em String no file
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    //O try catch irá tentar exibir algo (try) e caso de errado irá exibir o erro descrito em catch
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
