import 'package:flutter/material.dart';

class MiniTicTacToe extends StatelessWidget {
  final void Function(int)? tapped;
  final Color getBorderColor;
  final List displayElement;
  final Color getTextColor;
  const MiniTicTacToe({
    super.key,
    this.tapped,
    required this.getBorderColor,
    required this.displayElement,
    required this.getTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                tapped!(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getBorderColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    displayElement[index],
                    style: TextStyle(color: getTextColor, fontSize: 35),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
