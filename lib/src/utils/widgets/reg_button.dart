import 'package:flutter/material.dart';

class RegularButton extends StatelessWidget {
  final VoidCallback? ontap;
  final String name;
  final bool isActive;

  const RegularButton(
      {super.key,
      required this.ontap,
      required this.name,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isActive ? null : ontap,
      child: Container(
        height: 45,
        width: 307,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
