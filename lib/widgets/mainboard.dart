import 'package:flutter/material.dart';
import 'package:tiktak/widgets/minitictactoe.dart';

class MainBoard extends StatelessWidget {
  final void Function(int)? tapped;
  final Color getBorderColor;
  final List<String> displayElement;
  final Color getTextColor;
  const MainBoard({
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
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return MiniTicTacToe(
              getBorderColor: getBorderColor,
              displayElement: displayElement,
              getTextColor: getTextColor);
        },
      ),
    );
  }
}
