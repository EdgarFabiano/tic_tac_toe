import 'package:flutter/material.dart';
import 'package:tic_tac_toe/play.dart';
import 'package:tic_tac_toe/utils.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final countMatrix = 3;
  static final double size = 92;

  Play lastMove = Play.none;
  late List<List<Play>> matrix;

  @override
  void initState() {
    super.initState();

    setEmptyFields();
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Play.none),
      ));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: lastMove.backgroundColor,
        appBar: AppBar(
            title: Center(
              child:
                  Text(lastMove.nextPlay.value, style: TextStyle(fontSize: 32)),
            ),
            backgroundColor: lastMove.nextPlay.fieldColor),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
        ),
      );

  Widget buildRow(int x) {
    final values = matrix[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Widget buildField(int x, int y) {
    final play = matrix[x][y];

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, size),
          primary: play.fieldColor,
        ),
        child: Text(play.value, style: TextStyle(fontSize: 32)),
        onPressed: () => selectField(play, x, y),
      ),
    );
  }

  void selectField(Play value, int x, int y) {
    if (value == Play.none) {
      final newValue = lastMove == Play.X ? Play.O : Play.X;

      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog(newValue);
      } else if (isEnd()) {
        showEndDialog(null);
      }
    }
  }

  bool isEnd() =>
      matrix.every((values) => values.every((value) => value != Play.none));

  /// Check out logic here: https://stackoverflow.com/a/1058804
  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    final n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(Play? winner) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var title =
              winner != null ? winner.winnerValue : PlayExtension.tieValue;
          return AlertDialog(
            title: Center(child: Text(title, style: TextStyle(fontSize: 32))),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  setEmptyFields();
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.restart_alt),
              )
            ],
          );
        },
      );
}
