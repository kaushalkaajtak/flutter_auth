import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class AuthButton extends StatelessWidget {
  final AssetGenImage image;
  final String buttonText;
  final VoidCallback ontap;
  final bool isVisible;
  final double? iconSize;
  final EdgeInsetsGeometry? margin;

  const AuthButton(
      {super.key,
      required this.image,
      required this.buttonText,
      required this.ontap,
      required this.isVisible,
      this.margin,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          width: 307,
          height: 50,
          margin: margin,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                image.image(height: iconSize ?? 20, width: iconSize ?? 20),
                const SizedBox(width: 12),
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
