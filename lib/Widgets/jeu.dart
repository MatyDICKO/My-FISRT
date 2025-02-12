import 'package:exercice/Widgets/db.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required category, required categoryId});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  late int totalQuestions;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int streak = 0;
  int coins = 0;
  bool isAnswered = false;
  late Timer _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _loadCoins();
    questions = DBHelper.getRandomQuestions(10);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0 && !isAnswered) {
          _timeLeft--;
        } else if (_timeLeft == 0 && !isAnswered) {
          _timer.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  Future<void> _loadCoins() async {
    coins = await DBHelper.getCoins();
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(bool isCorrect) {
    if (!isAnswered) {
      _timer.cancel();
      setState(() {
        isAnswered = true;
      });
      if (isCorrect) {
        setState(() {
          score++;
          streak++;
          coins += (streak * 5);
          DBHelper.saveCoins(coins);
        });
        _showSuccessDialog();
      } else {
        _showContinueDialog();
      }
    }
  }

  void _showTimeUpDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.red[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.timer_off, color: Colors.red, size: 30),
          SizedBox(width: 10),
          Text('Temps écoulé!', style: TextStyle(color: Colors.red[900])),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Vous n\'avez pas répondu à temps 😕'),
          SizedBox(height: 15),
          Text('Vos pièces: $coins 🪙',
              style: TextStyle(fontSize: 18, color: Colors.amber[700])),
          SizedBox(height: 10),
          if (coins >= 5)
            Text('Continuer pour 5 pièces?')
          else
            Text('Pièces insuffisantes!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        if (coins >= 5)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Continuer (-5 pièces)'),
            onPressed: () {
              setState(() {
                coins -= 5;
                streak = 0;
                DBHelper.saveCoins(coins);
                isAnswered = false;
              });
              Navigator.pop(context);
              _moveToNextQuestion();
            },
          ),
        TextButton(
          child: Text('Menu Principal'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Excellent!', style: TextStyle(color: Colors.green[900])),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bonne réponse! 🎉'),
            SizedBox(height: 10),
            Text('+ ${streak * 5} pièces',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700])),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Continuer'),
            onPressed: () {
              Navigator.pop(context);
              _moveToNextQuestion();
            },
          ),
        ],
      ),
    );
  }

  void _showContinueDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Oops!', style: TextStyle(color: Colors.red[900])),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mauvaise réponse 😕'),
            SizedBox(height: 15),
            Text('Vos pièces: $coins 🪙',
                style: TextStyle(fontSize: 18, color: Colors.amber[700])),
            SizedBox(height: 10),
            if (coins >= 5)
              Text('Continuer pour 5 pièces?')
            else
              Text('Pièces insuffisantes!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (coins >= 5)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Continuer (-10 pièces)'),
              onPressed: () {
                setState(() {
                  coins -= 10;
                  streak = 0;
                  DBHelper.saveCoins(coins);
                  isAnswered = false;
                });
                Navigator.pop(context);
                _moveToNextQuestion();
              },
            ),
          TextButton(
            child: Text('Menu Principal'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _moveToNextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        _animationController.forward(from: 0.0);
        _startTimer();
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final bonusCoins = score * 10;
    setState(() {
      coins += bonusCoins;
      DBHelper.saveCoins(coins);
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Column(
          children: [
            Icon(Icons.emoji_events, size: 50, color: Colors.amber),
            Text("Quiz Terminé!",
                style: TextStyle(color: Colors.indigo[900], fontSize: 24)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: $score / $totalQuestions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Bonus: +$bonusCoins pièces 🎉",
                style: TextStyle(fontSize: 18, color: Colors.amber[700])),
            Text("Total pièces: $coins 🪙",
                style: TextStyle(fontSize: 18, color: Colors.amber[700])),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Menu Principal"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Nouvelle Partie"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                streak = 0;
                currentQuestionIndex = 0;
                isAnswered = false;
                questions = DBHelper.getRandomQuestions(5);
                _startTimer();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo[900]!,
              Colors.purple[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No questions available.',
                      style: TextStyle(color: Colors.white)),
                );
              }

              final question = snapshot.data![currentQuestionIndex];
              totalQuestions = snapshot.data!.length;

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildQuestionCard(question),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Temps restant: $_timeLeft',
            style: TextStyle(
              color: _timeLeft <= 3 ? Colors.red : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('$score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Text(
                'Question ${currentQuestionIndex + 1}/$totalQuestions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('$coins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                question['question'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _buildOptions(question['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(int questionId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DBHelper.getOptions(questionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final options = snapshot.data!;
        return ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animation.value * 0.03),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.indigo[900],
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => _checkAnswer(option['is_correct'] == 1),
                      child: Text(
                        option['option'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
