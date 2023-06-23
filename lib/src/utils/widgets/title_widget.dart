import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String description;
  final String title;
  final Widget? headerWidget;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  const TitleWidget(
      {super.key,
      required this.headerWidget,
      required this.description,
      required this.title,
      this.titleStyle,
      this.descriptionStyle});

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
          style: titleStyle ??
              const TextStyle(
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
            style: descriptionStyle ??
                const TextStyle(
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
