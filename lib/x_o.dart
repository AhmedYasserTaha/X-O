import 'dart:math';

import 'package:flutter/material.dart';

class XOGame extends StatefulWidget {
  final String gameMode; // لتحديد إذا كان اللعب مع الكمبيوتر أو مع صديق

  const XOGame({super.key, required this.gameMode});

  @override
  // ignore: library_private_types_in_public_api
  _XOGameState createState() => _XOGameState();
}

class _XOGameState extends State<XOGame> {
  List<String> grid = List.filled(9, ''); // شبكة اللعبة
  String currentPlayer = 'X'; // اللاعب الحالي
  String winner = ''; // الفائز
  Random random = Random(); // لإنشاء أرقام عشوائية

  // حالات الفوز
  List<List<int>> winningCombinations = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // الصفوف
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // الأعمدة
    [0, 4, 8], [2, 4, 6], // الأقطار
  ];

  void _handleTap(int index) {
    if (grid[index] == '' && winner == '') {
      setState(() {
        grid[index] = currentPlayer;
        if (_checkWinner()) {
          winner = currentPlayer;
        } else if (!grid.contains('')) {
          winner = 'Draw';
        } else {
          if (widget.gameMode == 'Computer' && currentPlayer == 'X') {
            currentPlayer = 'O'; // تبديل إلى الكمبيوتر
            _computerMove();
          } else {
            currentPlayer =
                (currentPlayer == 'X') ? 'O' : 'X'; // تبديل الدور بين اللاعبين
          }
        }
      });
    }
  }

  // حركة الكمبيوتر الذكية
  void _computerMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // البحث عن حركة للفوز
        int? winningMove = _findBestMove('O');
        if (winningMove != null) {
          grid[winningMove] = currentPlayer;
        } else {
          // منع اللاعب من الفوز
          int? blockingMove = _findBestMove('X');
          if (blockingMove != null) {
            grid[blockingMove] = currentPlayer;
          } else {
            // اختيار المركز إذا كان فارغًا
            if (grid[4] == '') {
              grid[4] = currentPlayer;
            } else {
              // اختيار الزوايا الفارغة
              List<int> corners = [0, 2, 6, 8];
              List<int> emptyCorners =
                  corners.where((index) => grid[index] == '').toList();
              if (emptyCorners.isNotEmpty) {
                grid[emptyCorners[0]] = currentPlayer;
              } else {
                // اختيار حركة عشوائية
                List<int> emptyCells = [];
                for (int i = 0; i < grid.length; i++) {
                  if (grid[i] == '') emptyCells.add(i);
                }
                if (emptyCells.isNotEmpty) {
                  int randomIndex =
                      emptyCells[random.nextInt(emptyCells.length)];
                  grid[randomIndex] = currentPlayer;
                }
              }
            }
          }
        }

        // التحقق من الفوز أو التعادل
        if (_checkWinner()) {
          winner = currentPlayer;
        } else if (!grid.contains('')) {
          winner = 'Draw';
        } else {
          currentPlayer = 'X'; // العودة لدور اللاعب
        }
      });
    });
  }

  // البحث عن أفضل حركة للكمبيوتر أو اللاعب
  int? _findBestMove(String player) {
    for (var combination in winningCombinations) {
      int count = 0;
      int? emptyIndex;
      for (int index in combination) {
        if (grid[index] == player) count++;
        if (grid[index] == '') emptyIndex = index;
      }
      if (count == 2 && emptyIndex != null) {
        return emptyIndex; // حركة لتحقيق الفوز أو منعه
      }
    }
    return null; // لا توجد حركة مناسبة
  }

  // التحقق من الفائز
  bool _checkWinner() {
    for (var combination in winningCombinations) {
      if (grid[combination[0]] == currentPlayer &&
          grid[combination[1]] == currentPlayer &&
          grid[combination[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  // إعادة تشغيل اللعبة
  void _resetGame() {
    setState(() {
      grid = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00796b),
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 30, color: Colors.black),
        backgroundColor: const Color(0xff00796b),
        title: const Text(
          'XO Game',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          grid[index],
                          style: const TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              winner == ''
                  ? 'Current Player: $currentPlayer'
                  : (winner == 'Draw' ? 'It\'s a Draw!' : 'Winner: $winner'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // لون النص
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // حواف دائرية
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 20), // المسافة الداخلية
                elevation: 5, // الظل
              ),
              child: const Text(
                'Reset Game',
                style: TextStyle(
                  fontSize: 20, // حجم النص
                  fontWeight: FontWeight.bold, // سمك الخط
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
