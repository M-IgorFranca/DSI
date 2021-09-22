import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Walcome to flutter",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
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
            title: Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mikael_Igor - gerador de nomes'),
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
              _suggestions.removeAt(index);
              _saved.remove(WordPair);
            });
          },
        );
      },
    );
  }

  Set<WordPair> get newMethod => _saved;

  //Quando eu quiser adicionar o arrastar para o lado e excluir
  //Provavelmente vai ser aqui na buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //Adicionando os ícones para favoritar as palavras
      trailing: Icon(
        // alreadySaved tem valor boleano 1 ou 0
        // Terá um ícone preenchido e vermelho se o valor for 1 e uma borda com cor null(cinza) se o valor for 0
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      //Adiciona interação ao toque
      onTap: () {
        //serState faz com que a tela se atualize e mostre a mudança
        setState(() {
          // Se estiver favoritado e o ícone for clicado remove do conjunto _saved
          if (alreadySaved) {
            _saved.remove(pair);
            // Se não estiver favoritado e o ícone for clicado adiciona no conjunto _saved
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
