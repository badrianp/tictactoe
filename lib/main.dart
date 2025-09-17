import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Game Mode"),
        backgroundColor: Colors.grey[100],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text("TicTacToe modes:", style: TextStyle(color: Colors.black, fontSize: 36)),
            // const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey[200]; 
                  }
                  return Colors.white; 
                }),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TicTacToeApp(gameMode: "pvp")),
                );
              },
              child: const Text("Player vs Player", style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey[200]; 
                  }
                  return Colors.white; 
                }),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DifficultyScreen()),
                );
              },
              child: const Text("Player vs AI", style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  void selectDifficulty(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicTacToeApp(gameMode: "pve", difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Select Difficulty"), backgroundColor: Colors.grey[100],),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey[200]; 
                  }
                  return Colors.white; 
                }),
              ),
              onPressed: () => selectDifficulty(context, 'easy'),
              child: const Text('Easy', style: TextStyle(color: Colors.black, fontSize: 20))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey[200]; 
                  }
                  return Colors.white; 
                }),
              ),
              onPressed: () => selectDifficulty(context, 'medium'),
              child: const Text('Medium', style: TextStyle(color: Colors.black, fontSize: 20))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey[200]; 
                  }
                  return Colors.white; 
                }),
              ),
              onPressed: () => selectDifficulty(context, 'hard'),
              child: const Text('Hard', style: TextStyle(color: Colors.black, fontSize: 20))
            ),
          ],
        ),
      ),
    );
  }
}

class TicTacToeApp extends StatefulWidget {
  final String gameMode;
  final String? difficulty;
  const TicTacToeApp({super.key, this.gameMode = "pvp", this.difficulty = "easy"});

  @override
  State<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  List<String> board = List.filled(9, "");
  List<int> winningLine = List.empty();
  bool isXTurn = true;
  bool isGameOver = false;
  String? winner;
  final List<List<int>> winningCombinations = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  void checkWinner() {
    for (var combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (board[a] != "" && board[a] == board[b] && board[a] == board[c]) {
        setState(() {
          winningLine = combo;
          isGameOver = true;
          winner = board[a];
        });
        return;
      }
    }
    if (board.every((cell) => cell != "")) {
      setState(() {
        isGameOver = true;
        winner = "draw";
      });
    }
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      isXTurn = true;
      isGameOver = false;
      winner = null;
      winningLine = List.empty();
    });
  }

  void showGameOverDialog(String winner) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.black.withAlpha((0.8 * 255).toInt()),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  winner == "draw" ? "It's a draw!" : "$winner won!",
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text("Play again", style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text("Change mode", style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void makeDelayedMove(int index, String player, int delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (!mounted || isGameOver) return;
      makeMove(index, player);
    });
  }

  int getDefenseIndex(String opponent) {
    for (var combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (board[a] == "" && board[b] == board[c] && board[b] == opponent) {
        return a;
      }
      if (board[b] == "" && board[a] == board[c] && board[a] == opponent) {
        return b;
      }
      if (board[c] == "" && board[a] == board[b] && board[a] == opponent) {
        return c;
      }
    }
    return -1;
  }

  int getOffenseIndex(String player) {
    for (var combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (board[a] == "" && board[b] == board[c] && board[b] == player) {
        return a;
      }
      if (board[b] == "" && board[a] == board[c] && board[a] == player) {
        return b;
      }
      if (board[c] == "" && board[a] == board[b] && board[a] == player) {
        return c;
      }
    }
    return -1;
  }

  void makeAIMove(String difficulty) {
    final emptyIndexes = [for (int i = 0; i < board.length; i++) if (board[i] == "") i];
    final emptyEdges = [for (var edge in [0,2,6,8]) if (board[edge] == "") edge];
    const int aiDelay = 400;
    switch (difficulty) {
      case "easy":
        final randomIndex = emptyIndexes[Random().nextInt(emptyIndexes.length)];
        makeDelayedMove(randomIndex, "O", aiDelay);
        break;
      case "medium":
        int defenseIndex = getDefenseIndex("X");
        if (defenseIndex != -1) {
          makeDelayedMove(defenseIndex, "O", aiDelay);
        } else {
          makeAIMove("easy");
        }
        break;
      case "hard":
        int offenseIndex = getOffenseIndex("O");
        if (offenseIndex != -1) {
          makeDelayedMove(offenseIndex, "O", aiDelay);
        } else {
          int defenseIndex = getDefenseIndex("X");
          if (defenseIndex != -1) {
            makeDelayedMove(defenseIndex, "O", aiDelay);
          } else {
            if (board[4] == "") {

              makeDelayedMove(4, "O", aiDelay);
            } else {
              if(board[4] == "O") {
                for(var edge in [1,3,5,7]) {
                  if (board[edge] == ""){
                    makeDelayedMove(edge, "O", aiDelay);
                    break;
                  }
                }
              } else {
                if (emptyEdges.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: aiDelay), () {
                      if (!mounted || isGameOver) return;
                      makeMove(emptyEdges[Random().nextInt(emptyEdges.length)], "O");
                    });
                } else {
                  makeAIMove("easy");
                }
              }
            }
          }
        }
        break;
    }
  }

  void makeMove(int index, String player) {
    setState(() {
      board[index] = player;
      isXTurn = !isXTurn;
      checkWinner();
      if (isGameOver) {
        Future.delayed(const Duration(milliseconds: 600), () {
          showGameOverDialog(winner!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    final turnIndicator = SizedBox(
      height: 72,
      width: 72,
      child: isXTurn
          ? const Icon(Icons.close, size: 54)
          : const Icon(Icons.circle_outlined, size: 54),
    );

    final boardWidget = AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(9, (index) {
            return GestureDetector(
              onTap: () {
                if (board[index] == "" && !isGameOver) {
                  makeMove(index, isXTurn ? "X" : "O");
                  if (!isXTurn && !isGameOver && widget.gameMode == "pve") {
                    makeAIMove(widget.difficulty!);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: winningLine.contains(index)? Colors.green : Colors.black, width: winningLine.contains(index)? 2.5 : 1),
                  color: Colors.white54,
                ),
                child: Center(
                  child: board[index] == "O"
                      ? const Icon(Icons.circle_outlined, size: 54)
                      : board[index] == "X"
                          ? const Icon(Icons.close, size: 54)
                          : const SizedBox(),
                ),
              ),
            );
          }),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(isXTurn? "X to move":"O to move"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset game',
            onPressed: resetGame,
          )
        ],
      ),
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  if (!isXTurn) turnIndicator else const SizedBox(width: 72),
                  const SizedBox(width: 16),
                  Flexible(child: Center(child: boardWidget)),
                  const SizedBox(width: 16),
                  if (isXTurn) turnIndicator else const SizedBox(width: 72),
                  const SizedBox(width: 16),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  if (!isXTurn) turnIndicator else const SizedBox(height: 72),
                  const SizedBox(height: 16),
                  Flexible(child: Center(child: boardWidget)),
                  const SizedBox(height: 16),
                  if (isXTurn) turnIndicator else const SizedBox(height: 72),
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }
}