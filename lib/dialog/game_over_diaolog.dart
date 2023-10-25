import 'package:flutter/material.dart';

class GameOverDialog extends StatefulWidget {
  final Function onRestart;
  const GameOverDialog({super.key,required this.onRestart});
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<GameOverDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          widget.onRestart();
          Navigator.pop(context);
        },
        child: Text('重新开始'),
      ),
    );
  }
}
