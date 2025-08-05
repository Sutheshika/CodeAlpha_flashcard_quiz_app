import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlashcardQuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

}

class Flashcard{
  final String id;
  String question;
  String answer;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
  });
}

class FlashcardQuizScreen extends StatefulWidget{
  @override
  _FlashcardQuizScreenState createState() => _FlashcardQuizScreenState();
}

class _FlashcardQuizScreenState extends State<FlashcardQuizScreen>
    with TickerProviderStateMixin {
  List<Flashcard> flashcards = [
    Flashcard(
      id: '1',
      question: 'What is the capital of France?',
      answer: 'Paris',
    ),
    Flashcard(
      id: '2',
      question: 'What is 2 + 2?',
      answer: '4',
    ),
    Flashcard(
      id: '3',
      question: 'Who wrote Romeo and Juliet?',
      answer: 'William Shakespeare',
    ),
  ];

  int currentIndex = 0;
  bool showAnswer = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState(){
    super.initState();
    _flipController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin:0.0,
      end: 1.0,
     ).animate(CurvedAnimation(
      parent:_flipController,
      curve: Curves.easeInOut,
     ));
  }

  @override
  void dispose(){
    _flipController.dispose();
    super.dispose();
  }

  void _nextCard(){
    if (currentIndex< flashcards.length - 1){
      setState((){
        currentIndex++;
        showAnswer = false;
      });
      _flipController.reset();
    }
  }

  void _previousCard(){
    if (currentIndex>0){
      setState((){
        currentIndex--;
        showAnswer =false;
      });
      _flipController.reset();
    }
  }