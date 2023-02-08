import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String description;
  final String title;
  final Widget? headerWidget;

  const TitleWidget(
      {super.key,
      required this.headerWidget,
      required this.description,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: headerWidget ??
              Container(
                height: 66,
                width: 66,
                color: Colors.grey.shade400,
              ),
        ),
        const SizedBox(height: 50),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
