import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];  //list to store wordPair suggestions
  final Set<WordPair> _saved = Set<WordPair>();  // set where we save our favourited startup names
  // set is preferred to lists because it does not allow duplicate entries.
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);  // constant textstyle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget> [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    //navigator.push pushes the new route(page) to the navigator's stack
    Navigator.of(context).push(
      MaterialPageRoute <void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(pair.asPascalCase,
                style: _biggerFont,)
              );
            });

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles:tiles,
          ).toList();
        
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved suggestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),  //padding of 16.0 at all edges.

      //list builder  (iterates through each index of the list).
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider();  //if i is odd add divider to separate list items.
        }
        final int index = i ~/ 2;  //divide i by 2 and return nearest whole number without rounding.
        // 1, 2, 3, 4, 5 => 0, 1, 1, 2, 2

        // if the index (index of item on the list is equal to greater than suggestions.length)
        // generate another 10 sets of random word suggesstions. and append to list.
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));  //list generation
        } 
        return _buildRow(_suggestions[index]);
      }

    );
  }

  _buildRow(WordPair pair) {
    // check if pair is already in set "_saved" if true set alreadySaved to True
    // .contains() is a set method that returns a boolean.
    final bool _alreadySaved = _saved.contains(pair);  
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),

      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null, 
      ),
      //if listTile is tapped update state
      onTap: () {
        setState(() {
         if(_alreadySaved) {
           _saved.remove(pair);  //remove pair from set _saved
         } 
         else{
           _saved.add(pair);  //add pair from set _saved
         }
        });
      },
    );
  }

}