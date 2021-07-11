// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {

    final alreadysaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadysaved ? Icons.favorite : Icons.favorite_border,
        color: alreadysaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadysaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [IconButton(onPressed: _pushSaved, icon: Icon(Icons.list))],
      ),
            body: _buildSuggestions(),
    );
  }

  void _pushSaved () {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final tiles = _saved.map(
                (WordPair pair) {
                  return ListTile(
                      title:Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                  );
                }
            );

            final divided = tiles.isNotEmpty ? ListTile.divideTiles(tiles: tiles, context:context).toList() : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: Text("Saved Suggestion"),
              ),
              body: ListView(children: divided),
            );
          },
        ),
      );
  }

}
