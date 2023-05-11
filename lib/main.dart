import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess my number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GuessNumberPage(title: 'Guess my number'),
    );
  }
}

class GuessNumberPage extends StatefulWidget {
  const GuessNumberPage({super.key, required this.title});

  final String title;

  @override
  State<GuessNumberPage> createState() => _GuessNumberPageState();
}

class _GuessNumberPageState extends State<GuessNumberPage> {
  final TextEditingController _inputNumberController = TextEditingController();
  String outputMessage = '';
  static Random randomInstance = Random();
  int randomNumber = randomInstance.nextInt(100);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Guess my number'),
          ),
        ),
        body: Form(
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  'Please, input a number between 1 and 100.',
                  style: TextStyle(fontSize: 30, color: Colors.lightBlue),
                ),
                const Text(
                  "It's your turn to guess my number!",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Please enter a number',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _inputNumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            guessNumber();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Result is :  '),
                                content: Text(
                                  outputMessage,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Try Again'))
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Guess my number...',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void guessNumber() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final int enteredGuessedNumber = int.parse(_inputNumberController.text);

    if (enteredGuessedNumber < 1 || enteredGuessedNumber > 100) {
      outputMessage = 'Please input a number between [1..100] ';
      _inputNumberController.clear();
      return;
    }

    if (enteredGuessedNumber > randomNumber) {
      outputMessage = 'Try lower number';
    } else if (enteredGuessedNumber < randomNumber) {
      outputMessage = 'Try higher number';
    } else if (enteredGuessedNumber == randomNumber) {
      outputMessage = 'Bingo!!!! Number is: $randomNumber ';
      randomNumber = randomInstance.nextInt(100);
    }
    _inputNumberController.clear();
  }
}
