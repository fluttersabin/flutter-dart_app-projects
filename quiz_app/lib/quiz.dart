import 'package:flutter/material.dart';
import 'package:quiz_app/question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
   final List<Map<String, Object>> questions;
   final int qIndex;
   final Function answerQuestion;

    Quiz({
     required this.questions,
     required this.answerQuestion,
     required this.qIndex,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Question(
          questions[qIndex]['questionText'] as String,
        ),
        ...(questions[qIndex]['answers'] as List<Map<String, Object>>).map((answer) {
          return Answer(() => answerQuestion(answer['score']), answer['text'] as String);
        }).toList()
    ],
    );
  }
}