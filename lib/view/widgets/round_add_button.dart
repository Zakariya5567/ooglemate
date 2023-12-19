import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class RoundAddButton extends StatelessWidget {
  RoundAddButton({required this.onTap});
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration:
            const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
        child: const Icon(
          Icons.add,
          color: primaryWhite,
          size: 30,
        ),
      ),
    );
  }
}
