import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   CustomButton({required this.onTap,required this.buttonText});

   VoidCallback? onTap;
   String? buttonText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 60,
        width: double.infinity,
        child: Center(
            child: Text(
          '$buttonText',
          style: TextStyle(
            fontSize: 22,
          ),
        )),
      ),
    );
  }
}
