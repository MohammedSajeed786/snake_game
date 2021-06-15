import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Myapp(),
  ));
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  var noofsqr = 600;
  static List<int> pos = [45, 65, 85, 105, 125];
  static var randno = Random();
  int food = randno.nextInt(600);
  void generateFood() {
    food = randno.nextInt(600);
  }

  void start(BuildContext context) {
    pos = [45, 65, 85, 105,125];
    const dur = Duration(milliseconds: 300);
    Timer.periodic(dur, (Timer timer) {
      update();
      if (gameover()) {
        print("over");
        timer.cancel();
        showgameoverdialog();
      }
    });
  }

  var direction = "down";
  void update() {
    setState(() {
      switch (direction) {
        case "down":
          if (pos.last > 580) {
            pos.add(pos.last + 20 - 600);
          } else {
            pos.add(pos.last + 20);
          }
          break;
        case "right":
          if ((pos.last + 1) % 20 == 0) {
            pos.add(pos.last + 1 - 20);
          } else {
            pos.add(pos.last + 1);
          }
          break;
        case "up":
          if (pos.last < 20) {
            pos.add(pos.last - 20 + 600);
          } else {
            pos.add(pos.last - 20);
          }
          break;
        case "left":
          if (pos.last % 20 == 0) {
            pos.add(pos.last - 1 + 20);
          } else {
            pos.add(pos.last - 1);
          }
          break;
        default:
      }
      if (pos.last == food) {
        generateFood();
      } else {
        pos.removeAt(0);
      }
    });
  }

  void showgameoverdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("GAME OVER"),
            content: Text("Your score: " + pos.length.toString()),
            actions: [
              FlatButton(
                  onPressed: () {
                    start(context);
                    Navigator.of(context).pop();
                  },
                  child: Text("Play Again"))
            ],
          );
        });
  }

  bool gameover() {
    for (int i = 0; i < pos.length; i++) {
      int c = 0;
      for (int j = 0; j < pos.length; j++) {
        if (pos[i] == pos[j]) c++;
        if (c >= 2) return true;
      }
    }
    //if (c == 2) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // theme: ThemeData(
      //   primarySwatch: Colors.black
      // ),

      //appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onVerticalDragUpdate: (details) {
              //swipe down dy>0
              //swipe right dx>0
              if (direction != "down" && details.delta.dy < 0) {
                direction = "up";
              } else if (direction != "up" && details.delta.dy > 0) {
                direction = "down";
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direction != "right" && details.delta.dx < 0) {
                direction = "left";
              } else if (direction != "left" && details.delta.dx > 0) {
                direction = "right";
              }
            },
            child: Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: noofsqr,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20),
                    //how to represent food
                itemBuilder: (BuildContext context, int index) {
                  if (pos.contains(index)) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if (index == food) {
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.grey[900],
                          // child: Text(index.toString(),style:TextStyle(color:Colors.white)),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    start(context);
                  },
                  child: Text(
                    "s t a r t",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 0   1   2 3 4 5 .........19
// 20
// 30
// .
// .
// .
// .
// 580 ......................599
//always head is last index
//every 300s add a value at last which becomes head and remove first index