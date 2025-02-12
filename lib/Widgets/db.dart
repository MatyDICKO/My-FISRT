import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class DBHelper {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'quiz.db'),
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE questions(id INTEGER PRIMARY KEY AUTOINCREMENT, question TEXT NOT NULL);",
        );
        await database.execute(
          "CREATE TABLE options(id INTEGER PRIMARY KEY AUTOINCREMENT, question_id INTEGER, option TEXT NOT NULL, is_correct INTEGER NOT NULL, FOREIGN KEY(question_id) REFERENCES questions(id));",
        );
        await database.execute(
          "CREATE TABLE score(id INTEGER PRIMARY KEY AUTOINCREMENT, score INTEGER NOT NULL, coins INTEGER NOT NULL DEFAULT 0);",
        );

        // HTML Questions
        await insertQuestion(
            database, 'Quel élément HTML est utilisé pour insérer une image ?');
        await insertOption(database, 1, '<img>', true);
        await insertOption(database, 1, '<picture>', false);
        await insertOption(database, 1, '<image>', false);
        await insertOption(database, 1, '<media>', false);

        await insertQuestion(
            database, 'Quelle balise définit un lien hypertexte ?');
        await insertOption(database, 2, '<a>', true);
        await insertOption(database, 2, '<link>', false);
        await insertOption(database, 2, '<href>', false);
        await insertOption(database, 2, '<url>', false);

        await insertQuestion(
            database, 'Quel élément HTML est utilisé pour insérer une image ?');
        await insertOption(database, 1, '<img>', true);
        await insertOption(database, 1, '<picture>', false);
        await insertOption(database, 1, '<image>', false);
        await insertOption(database, 1, '<media>', false);

        await insertQuestion(
            database, 'Quelle balise définit un lien hypertexte ?');
        await insertOption(database, 2, '<a>', true);
        await insertOption(database, 2, '<link>', false);
        await insertOption(database, 2, '<href>', false);
        await insertOption(database, 2, '<url>', false);

        // CSS Questions
        await insertQuestion(
            database, 'Comment appliquer une couleur de fond en CSS ?');
        await insertOption(database, 3, 'background-color: red;', true);
        await insertOption(database, 3, 'color: red;', false);
        await insertOption(database, 3, 'bg-color: red;', false);
        await insertOption(database, 3, 'background: red;', false);

        await insertQuestion(
            database, 'Quelle propriété CSS définit la marge extérieure ?');
        await insertOption(database, 4, 'margin', true);
        await insertOption(database, 4, 'padding', false);
        await insertOption(database, 4, 'spacing', false);
        await insertOption(database, 4, 'border', false);

        await insertQuestion(
            database, 'Comment appliquer une couleur de fond en CSS ?');
        await insertOption(database, 3, 'background-color: red;', true);
        await insertOption(database, 3, 'color: red;', false);
        await insertOption(database, 3, 'bg-color: red;', false);
        await insertOption(database, 3, 'background: red;', false);


        await insertQuestion(
            database, 'Quelle propriété CSS définit la marge extérieure ?');
        await insertOption(database, 4, 'margin', true);
        await insertOption(database, 4, 'padding', false);
        await insertOption(database, 4, 'spacing', false);
        await insertOption(database, 4, 'border', false);

        // JavaScript Questions
        await insertQuestion(
            database, 'Comment déclarer une variable en JavaScript ?');
        await insertOption(database, 5, 'let x = 5;', true);
        await insertOption(database, 5, 'variable x = 5;', false);
        await insertOption(database, 5, 'x := 5;', false);
        await insertOption(database, 5, 'int x = 5;', false);

        await insertQuestion(database,
            'Quelle méthode ajoute un élément à la fin d\'un tableau ?');
        await insertOption(database, 6, 'push()', true);
        await insertOption(database, 6, 'append()', false);
        await insertOption(database, 6, 'add()', false);
        await insertOption(database, 6, 'insert()', false);

        await insertQuestion(
            database, 'Comment déclarer une variable en JavaScript ?');
        await insertOption(database, 5, 'let x = 5;', true);
        await insertOption(database, 5, 'variable x = 5;', false);
        await insertOption(database, 5, 'x := 5;', false);
        await insertOption(database, 5, 'int x = 5;', false);

        await insertQuestion(database,
            'Quelle méthode ajoute un élément à la fin d\'un tableau ?');
        await insertOption(database, 6, 'push()', true);
        await insertOption(database, 6, 'append()', false);
        await insertOption(database, 6, 'add()', false);
        await insertOption(database, 6, 'insert()', false);

        // Python Questions
        await insertQuestion(database, 'Comment créer une liste en Python ?');
        await insertOption(database, 7, 'ma_liste = []', true);
        await insertOption(database, 7, 'ma_liste = list()', false);
        await insertOption(database, 7, 'ma_liste = array()', false);
        await insertOption(database, 7, 'ma_liste = new List()', false);

        await insertQuestion(
            database, 'Quelle boucle utilise-t-on pour itérer sur une liste ?');
        await insertOption(database, 8, 'for item in liste:', true);
        await insertOption(database, 8, 'foreach item in liste:', false);
        await insertOption(database, 8, 'while item in liste:', false);
        await insertOption(database, 8, 'loop item in liste:', false);

        await insertQuestion(database, 'Comment créer une liste en Python ?');
        await insertOption(database, 7, 'ma_liste = []', true);
        await insertOption(database, 7, 'ma_liste = list()', false);
        await insertOption(database, 7, 'ma_liste = array()', false);
        await insertOption(database, 7, 'ma_liste = new List()', false);

        await insertQuestion(
            database, 'Quelle boucle utilise-t-on pour itérer sur une liste ?');
        await insertOption(database, 8, 'for item in liste:', true);
        await insertOption(database, 8, 'foreach item in liste:', false);
        await insertOption(database, 8, 'while item in liste:', false);
        await insertOption(database, 8, 'loop item in liste:', false);

        // Flutter Questions
        await insertQuestion(
            database, 'Quel widget crée une mise en page verticale ?');
        await insertOption(database, 9, 'Column', true);
        await insertOption(database, 9, 'Row', false);
        await insertOption(database, 9, 'Stack', false);
        await insertOption(database, 9, 'Container', false);

        await insertQuestion(database, 'Comment gérer l\'état d\'un widget ?');
        await insertOption(database, 10, 'setState(() {})', true);
        await insertOption(database, 10, 'updateState(() {})', false);
        await insertOption(database, 10, 'changeState(() {})', false);
        await insertOption(database, 10, 'modifyState(() {})', false);

        await insertQuestion(
            database, 'Quel widget crée une mise en page verticale ?');
        await insertOption(database, 9, 'Column', true);
        await insertOption(database, 9, 'Row', false);
        await insertOption(database, 9, 'Stack', false);
        await insertOption(database, 9, 'Container', false);

        await insertQuestion(database, 'Comment gérer l\'état d\'un widget ?');
        await insertOption(database, 10, 'setState(() {})', true);
        await insertOption(database, 10, 'updateState(() {})', false);
        await insertOption(database, 10, 'changeState(() {})', false);
        await insertOption(database, 10, 'modifyState(() {})', false);

        // Additional Questions
        await insertQuestion(database, 'Quelle est la commande Git pour cloner un dépôt ?');
        await insertOption(database, 11, 'git clone', true);
        await insertOption(database, 11, 'git pull', false);
        await insertOption(database, 11, 'git fetch', false);
        await insertOption(database, 11, 'git copy', false);

        await insertQuestion(database, 'Quel est le port par défaut pour HTTP ?');
        await insertOption(database, 12, '80', true);
        await insertOption(database, 12, '443', false);
        await insertOption(database, 12, '8080', false);
        await insertOption(database, 12, '3000', false);

        // Initialize score and coins
        await insertScore(database, 0, 50);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE score ADD COLUMN coins INTEGER NOT NULL DEFAULT 0;");
        }
      },
    );
  }

  static Future<int> insertQuestion(Database db, String question) async {
    final id = await db.insert(
      'questions',
      {'question': question},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<void> insertOption(
      Database db, int questionId, String option, bool isCorrect) async {
    await db.insert(
      'options',
      {'question_id': questionId, 'option': option, 'is_correct': isCorrect ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertScore(Database db, int score, int coins) async {
    await db.insert(
      'score',
      {'score': score, 'coins': coins},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await initializeDB();
    return await db.query('questions');
  }

  static Future<List<Map<String, dynamic>>> getOptions(int questionId) async {
    final db = await initializeDB();
    return await db.query('options', where: 'question_id = ?', whereArgs: [questionId]);
  }

  static Future<List<Map<String, dynamic>>> getRandomQuestions(int count) async {
    final db = await initializeDB();
    final questions = await db.query('questions');
    final random = Random();
    final selectedIndices = <int>{};
    final result = <Map<String, dynamic>>[];

    while (result.length < count && result.length < questions.length) {
      final randomIndex = random.nextInt(questions.length);
      if (selectedIndices.add(randomIndex)) {
        result.add(questions[randomIndex]);
      }
    }
    return result;
  }

  static Future<int> getCoins() async {
    final db = await initializeDB();
    final result = await db.query('score');
    return result.isNotEmpty ? result.first['coins'] as int : 0;
  }

  static Future<void> updateCoins(int coins) async {
    final db = await initializeDB();
    await db.update(
      'score',
      {'coins': coins},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  static Future<void> saveCoins(int coins) async {
    final db = await initializeDB();
    final result = await db.query('score');
    if (result.isEmpty) {
      await insertScore(db, 0, coins);
    } else {
      await updateCoins(coins);
    }
  }

  static Future<int> getScore() async {
    final db = await initializeDB();
    final result = await db.query('score');
    return result.isNotEmpty ? result.first['score'] as int : 0;
  }

  static Future<void> updateScore(int score) async {
    final db = await initializeDB();
    await db.update(
      'score',
      {'score': score},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
