import 'package:flutter/material.dart';
import 'package:quiz_app/quiz.dart';
import './result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

 @override
 _MyAppState createState() => _MyAppState();
// State<StatefulWidget> createState() {
//   return _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Green', 'score': 3},
        {'text': 'White', 'score': 1},
      ],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 3},
        {'text': 'Snake', 'score': 11},
        {'text': 'Elephant', 'score': 5},
        {'text': 'Lion', 'score': 9},
      ],
    },
    {
      'questionText': 'What\'s your favorite programming language?',
      'answers': [
        {'text': 'Java', 'score': 10},
        {'text': 'Dart', 'score': 5},
        {'text': 'PHP', 'score': 3},
        {'text': 'Javascript', 'score': 1},
      ],
    },
  ];

  var _qIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _qIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _qIndex = _qIndex + 1;
    });

  print(_qIndex);

  if (_qIndex < _questions.length) {
    print('We have more questions!');
  }
  else {
    print('No more questions!');
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: _qIndex < _questions.length
        ? Quiz(
          answerQuestion: _answerQuestion,
          qIndex: _qIndex,
          questions: _questions,
          )
          : Result(_totalScore, _resetQuiz),
        ),
    );
  }
  }
  
