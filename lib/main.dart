import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MikaelApp());

class MikaelApp extends StatelessWidget {
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

class _HomeState extends State<Home> {
  //aqui _suggestions recebe uma lista[] de WordPair.
  //O Underline em _suggestions significa que podemos acessa-lo em vários lugares.
  final _suggestions = <WordPair>[];
  //Criar um map vazio para palavras favotitadas
  final _saved = <WordPair>{};
  // O _biggerFont vai aumentar a font de um Widget text quando for chamado.
  final _biggerFont = const TextStyle(fontSize: 18);

  // Cria a nova página Saved Suggestion
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

  // Cria a nova página Saved Suggestion
  void _updateWordPair() {
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
            title: Text('Alterar nomes'),
          ),
          body: const UpdateNameForm(),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mikael Igor App'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    //Retorna um formato de lista do próprio flutter.
    //Com padding de 16
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        // Adiciona uma linha divisora de 1px em baixo de cada item da lista.
        if (i.isOdd) {
          return Divider();
        }
        // The syntax "i ~/ 2" divide i por 2 e retorna um numero inteiro.
        // Por exemplo: 1, 2, 3, 4, 5 se torna 0, 1, 1, 2, 2.
        final int index = i ~/ 2;
        // Se você alcançou o final da palavra disponível
        if (index >= _suggestions.length) {
          // então é serão adicionados mais 10 itens na lista
          _suggestions.addAll(generateWordPairs().take(10));
        }
        //Funcionalidade arrastar e remover
        return Dismissible(
          child: _buildRow(_suggestions[index]),
          background: Container(
            color: Colors.red,
          ),
          key: ValueKey(_suggestions[index]),
          onDismissed: (DismissDirection direction) {
            setState(() {
              var removido = _suggestions.removeAt(index);
              _saved.remove(removido);
            });
          },
          confirmDismiss: (DismissDirection endToStart) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar"),
                  content:
                      const Text("Tem certeza que deseja deletar esse item?"),
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
      },
    );
  }

  Set<WordPair> get newMethod => _saved;

  //Quando eu quiser adicionar o arrastar para o lado e excluir
  //Provavelmente vai ser aqui na buildRow
  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),

      onTap: _updateWordPair,

      //Adicionando os ícones para favoritar as palavras
      // Alterei a paternidade dos ícones para favoritar apenas no toque do icone e não da linha
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
      //Adicionar onTap
    );
  }
}

//Código removido e alterado da documentação flutter: https://flutter.dev/docs/cookbook/forms/text-input
class UpdateNameForm extends StatelessWidget {
  const UpdateNameForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'pair.First',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'pair.Second',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              //Função que retorna uma nova Strint para pair.asPascalCase
            },
            child: const Text('Alterar'),
          ),
        ),
      ],
    );
  }
}
