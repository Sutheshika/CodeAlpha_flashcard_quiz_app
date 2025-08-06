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

  void _toggleAnswer(){
    setState((){
      showAnswer = !showAnswer;
    });
    if (showAnswer){
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _resetQuiz(){
    setState((){
      currentIndex = 0;
      showAnswer = false;
    });
    _flipController.reset();
  }

  void _editCard(){
    _showCardDialog(isEditing: true);
  }

  void _addCard() {
    _showCardDialog(isEditing: false);
  }

  void _deleteCard() {
    if (flashcards.length > 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Card'),
            content: Text('Are you sure you want to delete this flashcard?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    flashcards.removeAt(currentIndex);
                    if (currentIndex >= flashcards.length) {
                      currentIndex = flashcards.length - 1;
                    }
                    showAnswer = false;
                  });
                  _flipController.reset();
                  Navigator.of(context).pop();
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot delete the last flashcard!')),
      );
    }
  }

  void _showCardDialog({bool isEditing = false}) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    if (isEditing) {
      questionController.text = flashcards[currentIndex].question;
      answerController.text = flashcards[currentIndex].answer;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Card' : 'Add New Card'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (questionController.text.trim().isNotEmpty &&
                    answerController.text.trim().isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      flashcards[currentIndex].question = questionController.text.trim();
                      flashcards[currentIndex].answer = answerController.text.trim();
                    } else {
                      flashcards.add(Flashcard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        question: questionController.text.trim(),
                        answer: answerController.text.trim(),
                      ));
                      currentIndex = flashcards.length - 1;
                    }
                    showAnswer = false;
                  });
                  _flipController.reset();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in both question and answer!')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Flashcard Quiz'),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[50]!, Colors.indigo[100]!],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz, size: 80, color: Colors.grey[400]),
                SizedBox(height: 20),
                Text(
                  'No flashcards available',
                  style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Text(
                  'Add your first card to get started!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _addCard,
                  icon: Icon(Icons.add),
                  label: Text('Add First Card'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetQuiz,
            tooltip: 'Reset Quiz',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.indigo[100]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress indicator
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress', style: TextStyle(color: Colors.grey[600])),
                          Text(
                            '${currentIndex + 1} of ${flashcards.length}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (currentIndex + 1) / flashcards.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Main flashcard
              Expanded(
                child: Card(
                  elevation: 8,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          showAnswer ? 'Answer' : 'Question',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 30),
                        AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_flipAnimation.value * 3.14159),
                              child: _flipAnimation.value <= 0.5
                                  ? Container(
                                      child: Text(
                                        flashcards[currentIndex].question,
                                        style: TextStyle(
                                          fontSize: 18,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()..rotateY(3.14159),
                                      child: Container(
                                        child: Text(
                                          flashcards[currentIndex].answer,
                                          style: TextStyle(
                                            fontSize: 18,
                                            height: 1.5,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _toggleAnswer,
                          child: Text(showAnswer ? 'Show Question' : 'Show Answer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Navigation controls
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: currentIndex > 0 ? _previousCard : null,
                        icon: Icon(Icons.chevron_left),
                        label: Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _editCard,
                            icon: Icon(Icons.edit),
                            tooltip: 'Edit Card',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.orange[100],
                              foregroundColor: Colors.orange[700],
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: flashcards.length > 1 ? _deleteCard : null,
                            icon: Icon(Icons.delete),
                            tooltip: 'Delete Card',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              foregroundColor: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: currentIndex < flashcards.length - 1 ? _nextCard : null,
                        icon: Icon(Icons.chevron_right),
                        label: Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Add card button
              ElevatedButton.icon(
                onPressed: _addCard,
                icon: Icon(Icons.add),
                label: Text('Add New Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }