import 'package:flutter/material.dart';

class GuessButtonWidget extends StatefulWidget{
  final Function _submitAnswer;

  const GuessButtonWidget(this._submitAnswer, {super.key});

  @override
  State<GuessButtonWidget> createState() => _GuessButtonWidgetState();
}

class _GuessButtonWidgetState extends State<GuessButtonWidget> {
  bool _isEnable = true;

  void _disableButton(){
    setState(() {
      _isEnable = false;
    });
    widget._submitAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.9,
      child: ElevatedButton(
        onPressed: _isEnable ? () => _disableButton() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Confirmer la réponse',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}