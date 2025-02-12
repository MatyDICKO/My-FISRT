import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:exercice/Widgets/jeu.dart';

class CategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'id': 1, "name": "HTML", "icon": FontAwesomeIcons.html5},
    {'id': 2, "name": "CSS", "icon": FontAwesomeIcons.css3Alt},
    {'id': 3, "name": "Java", "icon": FontAwesomeIcons.java},
    {'id': 4, "name": "Python", "icon": FontAwesomeIcons.python},
    {'id': 5, "name": "C", "icon": FontAwesomeIcons.c},
    {'id': 6, "name": "C++", "icon": FontAwesomeIcons.code},
    {'id': 7, "name": "C#", "icon": FontAwesomeIcons.hashtag},
    {'id': 8, "name": "Dart", "icon": FontAwesomeIcons.cube},
    {'id': 9, "name": "Bootstrap", "icon": FontAwesomeIcons.bootstrap},
    {'id': 10, "name": "JEE", "icon": FontAwesomeIcons.server},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choisissez une catégorie"),
        backgroundColor: Color.fromARGB(240, 2, 136, 246),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(240, 2, 136, 246), Color.fromARGB(255, 8, 1, 65)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(categoryId: categories[index]['id'], category: null,),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(categories[index]['icon'], size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        categories[index]['name'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(blurRadius: 3, color: Colors.black45, offset: Offset(1, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}