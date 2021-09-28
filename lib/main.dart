import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

final suggestions = <WordPair>[];
final _saved = <WordPair>{};
final _biggerFont = const TextStyle(fontSize: 18);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gerador de nomes",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//Classe Home com AppBar e botão que leva até Favorite
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
        appBar: AppBar(
          title: Text('Mikael Igor App'),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: RandomWords());
  }

  void _pushSaved() {
    // envia a rota para a pilha do Navigator.
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
          (WordPair pair) {
            // Retorna as linhas da listView
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Nomes favoritos'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }
}

// CLasse RandomWords será um Widget com estado
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// RandomWordsState retorna a ListView(Divider, Dismissible(Classe:buildRow))
class _RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    return list(context, suggestions);
  }

  Widget list(BuildContext context, _suggestions) {
    setState(() {});
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return dismissible(context, _suggestions[index], index);
      },
    );
  }

  Widget dismissible(BuildContext context, WordPair pair, int index) {
    final objeto = pair.asPascalCase;
    return Dismissible(
      key: Key(objeto),
      child: buildRow(context, pair, index, objeto),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (DismissDirection direction) {
        setState(() {
          var removido = suggestions.removeAt(index);
          _saved.remove(removido);
        });
      },
      confirmDismiss: (DismissDirection endToStart) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar"),
              content: const Text("Tem certeza que deseja deletar esse item?"),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Deletar")),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildRow(context, pair, int index, objeto) {
    final _alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Column(
          children: <Widget>[
            new Container(
              child: IconButton(
                icon: Icon(
                  _alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: _alreadySaved ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    // Se estiver favoritado e o ícone for clicado remove do conjunto _saved
                    if (_alreadySaved) {
                      _saved.remove(pair);
                      // Se não estiver favoritado e o ícone for clicado adiciona no conjunto _saved
                    } else {
                      _saved.add(pair);
                    }
                  });
                },
              ),
            )
          ],
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EditPage(),
            settings: RouteSettings(arguments: {'index': index, 'pair': pair})))
        //Adicionando os ícones para favoritar as palavras
        // Alterei a paternidade dos ícones para favoritar apenas no toque do icone e não da linha
        );
  }
}

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String? first = '';
  String? second = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var index = arguments['index'];
    var pair = arguments['pair'];
    first = pair.first;
    second = pair.second;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit item'),
      ),
      body: Container(
          color: Colors.white, child: updateNameForm(context, pair, index)),
    );
  }

  updateNameForm(context, pair, index) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: TextFormField(
              initialValue: first,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Primeira'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              onSaved: (newValue) {
                first = newValue;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: TextFormField(
              initialValue: second,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Segunda'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um nome válido';
                }
                return null;
              },
              onSaved: (value) {
                second = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: ElevatedButton(
              onPressed: () => _save(context, index),
              child: Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context, index) {
    _formKey.currentState!.save();
    print(suggestions);
    var pair = WordPair(first!, second!);
    suggestions[index] = pair;
    print(suggestions);
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (BuildContext context) => Home()));
  }
}
