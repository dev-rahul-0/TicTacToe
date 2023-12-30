import 'package:flutter/material.dart';
import 'package:tiktak/widgets/mainboard.dart';
import 'package:tiktak/widgets/minitictactoe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool oTurn = true;
  int oScore = 0;
  int xScore = 0;
  List<List<String>> displayElement = [
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ],
    [
      '', '', '', //
      '', '', '', //
      '', '', '', //
    ]
  ];
  int filledBoxes = 0;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Supper Tic Tac Toe',
          style: TextStyle(color: !isDarkMode ? Colors.black : Colors.white),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: !isDarkMode ? Colors.black : Colors.white),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black38 : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'Player X',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getTextColor()),
                  ),
                ),
                Text(
                  "= $xScore",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'Player 0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(),
                    ),
                  ),
                ),
                Text(
                  "= $oScore",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(),
                  ),
                ),
              ],
            ),
          ),
          MainBoard(
              getBigBorderColor: getBigBorderColor(),
              getSmallBorderColor: getSmallBorderColor(),
              displayElement: displayElement,
              getTextColor: getTextColor(),
              tapped: _tapped),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _clearScoreBoard,
                  child: const Text("Clear Score Board"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getTextColor() {
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color getSmallBorderColor() {
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color getBigBorderColor() {
    return isDarkMode
        ? Color.fromARGB(255, 60, 255, 0)
        : Color.fromARGB(255, 255, 0, 0);
  }

  void _tapped(int mainBoardIndex, int miniBoardIndex) {
    setState(() {
      // Your logic here for what happens when a cell is tapped
      // This is just a placeholder logic to put an 'X' or 'O'
      String currentValue = displayElement[mainBoardIndex][miniBoardIndex];
      // Check if the selected cell is empty
      if (currentValue == '') {
        // Determine the current player
        String currentPlayer = oTurn ? 'O' : 'X';

        // Update the selected cell with the current player's symbol
        displayElement[mainBoardIndex][miniBoardIndex] = currentPlayer;

        // Check for a winner in the small board
        if (_checkSmallBoardWinner(mainBoardIndex, miniBoardIndex)) {
          _showWinDialog(currentPlayer);
        }

        // Toggle the current player
        oTurn = !oTurn;

        // Increment the filled boxes count
        filledBoxes++;

        // Check for a draw or overall winner
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    for (int row = 0; row < 9; row += 3) {
      for (int col = 0; col < 9; col += 3) {
        if (_checkSmallBoardWinner(row, col)) {
          return;
        }
      }
    }
    if (filledBoxes == 81) {
      _showDrawDialog();
    }
  }

  bool _checkSmallBoardWinner(int row, int col) {
    // Check each row in the small board
    for (int r = row; r < row + 3; r++) {
      if (displayElement[r][col] == displayElement[r][col + 1] &&
          displayElement[r][col] == displayElement[r][col + 2] &&
          displayElement[r][col] != '') {
        _showWinDialog(displayElement[r][col]);
        return true;
      }
    }

    // Check each column in the small board
    for (int c = col; c < col + 3; c++) {
      if (displayElement[row][c] == displayElement[row + 1][c] &&
          displayElement[row][c] == displayElement[row + 2][c] &&
          displayElement[row][c] != '') {
        _showWinDialog(displayElement[row][c]);
        return true;
      }
    }

    // Check diagonals in the small board
    if (displayElement[row][col] == displayElement[row + 1][col + 1] &&
        displayElement[row][col] == displayElement[row + 2][col + 2] &&
        displayElement[row][col] != '') {
      _showWinDialog(displayElement[row][col]);
      return true;
    }
    if (displayElement[row][col + 2] == displayElement[row + 1][col + 1] &&
        displayElement[row][col + 2] == displayElement[row + 2][col] &&
        displayElement[row][col + 2] != '') {
      _showWinDialog(displayElement[row][col + 2]);
      return true;
    }
    return false;
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Draw"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
  }

  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      for (int i = 0; i < 9; i++) {
        displayElement[i] = [
          '', '', '', //
          '', '', '', //
          '', '', '', //
        ];
      }
    });
    filledBoxes = 0;
  }

  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("\" $winner\" is winner!!!"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }
}
