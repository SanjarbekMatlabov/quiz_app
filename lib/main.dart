import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English-Uzbek Quiz',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordPair {
  final String english;
  final String uzbek;
  final String partOfSpeech;

  WordPair({
    required this.english,
    required this.uzbek,
    required this.partOfSpeech,
  });
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentWordIndex = 0;
  int correctAnswers = 0;
  String? selectedAnswer;
  bool answered = false;
  bool isCorrect = false;
  Random random = Random();

  // List of word pairs (English-Uzbek)
  final List<WordPair> wordPairs = [
    WordPair(english: 'Awkward', uzbek: 'Noqulay', partOfSpeech: 'adjective [adj]'),
    WordPair(english: 'Beautiful', uzbek: 'Chiroyli', partOfSpeech: 'adjective [adj]'),
    WordPair(english: 'Important', uzbek: 'Muhim', partOfSpeech: 'adjective [adj]'),
    WordPair(english: 'Remember', uzbek: 'Eslamoq', partOfSpeech: 'verb [v]'),
    WordPair(english: 'Friend', uzbek: 'Do\'st', partOfSpeech: 'noun [n]'),
    WordPair(english: 'Happy', uzbek: 'Baxtli', partOfSpeech: 'adjective [adj]'),
    WordPair(english: 'Sleep', uzbek: 'Uxlamoq', partOfSpeech: 'verb [v]'),
    WordPair(english: 'Knowledge', uzbek: 'Bilim', partOfSpeech: 'noun [n]'),
    WordPair(english: 'Difficult', uzbek: 'Qiyin', partOfSpeech: 'adjective [adj]'),
    WordPair(english: 'Fast', uzbek: 'Tez', partOfSpeech: 'adjective [adj]'),
  ];

  // List of incorrect Uzbek translations to use as distractors
  final List<String> distractors = [
    'Asos solmoq', 'O\'rnatmoq', 'Kayfiyatni ko\'taradigan', 'Imo-ishora',
    'Yoqimli', 'Kuchli', 'Yumshoq', 'Sovuq', 'Issiq', 'Qattiq',
    'Uchirmoq', 'Yurmoq', 'O\'qimoq', 'Yozmoq', 'Gapirmoq',
    'Qorong\'u', 'Yorug\'', 'Katta', 'Kichik', 'Uzoq',
    'Yaqin', 'Qisqa', 'Uzun', 'Keng', 'Tor',
    'Og\'ir', 'Yengil', 'Qimmat', 'Arzon', 'Yangi',
  ];

  List<String> getOptions() {
    // Current word's correct answer
    String correctAnswer = wordPairs[currentWordIndex].uzbek;
    
    // Create a set to avoid duplicate options
    Set<String> optionsSet = {correctAnswer};
    
    // Add three random distractors
    while (optionsSet.length < 4) {
      String distractor = distractors[random.nextInt(distractors.length)];
      if (distractor != correctAnswer) {
        optionsSet.add(distractor);
      }
    }
    
    // Convert to list and shuffle
    List<String> options = optionsSet.toList();
    options.shuffle();
    
    return options;
  }

  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      answered = true;
      
      if (answer == wordPairs[currentWordIndex].uzbek) {
        correctAnswers++;
        isCorrect = true;
      } else {
        isCorrect = false;
      }
    });
  }

  void nextWord() {
    setState(() {
      if (currentWordIndex < wordPairs.length - 1) {
        currentWordIndex++;
        selectedAnswer = null;
        answered = false;
        isCorrect = false;
      } else {
        // Quiz completed, show results
        showResults();
      }
    });
  }

  void showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('You got $correctAnswers out of ${wordPairs.length} correct!'),
          actions: [
            TextButton(
              child: Text('Restart Quiz'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentWordIndex = 0;
                  correctAnswers = 0;
                  selectedAnswer = null;
                  answered = false;
                  isCorrect = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = getOptions();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('English-Uzbek Quiz (${currentWordIndex + 1}/${wordPairs.length})'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: answered && !isCorrect ? Color(0xFFFDE9E9) : null, // Light red background for incorrect answers
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Choose the correct translation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.help_outline,
                            size: 60,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wordPairs[currentWordIndex].english,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        wordPairs[currentWordIndex].partOfSpeech,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.volume_up, color: Colors.amber),
                          onPressed: () {
                            // Audio functionality would be implemented here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: selectedAnswer == option ? Colors.white : Colors.black, backgroundColor: selectedAnswer == option
                        ? (option == wordPairs[currentWordIndex].uzbek ? Colors.green : Colors.red)
                        : Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: answered ? null : () => checkAnswer(option),
                  child: Text(option),
                ),
              )).toList(),
              SizedBox(height: 24),
              if (answered)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect ? Colors.green : Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: nextWord,
                  child: Text(
                    isCorrect ? 'Next' : 'Incorrect',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              if (answered && !isCorrect)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Correct answer: ${wordPairs[currentWordIndex].uzbek}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}