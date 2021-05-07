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
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;
  TextEditingController _toDoController = TextEditingController();

  @override
  void initState() {
    //Para carregar os dados salvos no app
    super.initState();
    _readData().then(
      (data) {
        setState(
          () {
            _toDoList = jsonDecode(data);
          },
        );
      },
    );
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text; //Adiciona o texto no title
      _toDoController.text = ""; //zero o controller para novas adições
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

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
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  onPressed: _addToDo,
                  color: Colors.blueAccent,
                  child: Text('ADD'),
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          Expanded(
            //Necessario o expanded para poder saber até onde vai o ListView, caso não coloque
            //não irá aparecer nada
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  //Nos instanciamos o index para chamar o index da lista e context para chamar o contexto do index solicitado.
                  return buildItem(context, index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        onChanged: (check) {
          setState(() {
            //seria para mudar o estado do ok, de false para true e vice-versa
            _toDoList[index]["ok"] = check;
            _saveData();
          });
        },
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        title: Text(_toDoList[index]["title"]),
      ),
      background: Container(
        color: Colors.red,
        child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            )),
      ),
      onDismissed: (direction) {
        //Seria uma função para quando for deletado a note,
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Tarefa ${_lastRemoved["title"]} removida!! "),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
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
