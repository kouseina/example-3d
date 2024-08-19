import 'package:flutter/material.dart';

const _borderColor = Color(0xff1A170B);

class PixelButton extends StatelessWidget {
  const PixelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height,
              width: width - 8 * 2,
              decoration: const BoxDecoration(
                color: Color(0xffDCDCDC),
                border: Border(
                  top: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                  bottom: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                ),
              ),
            ),
            Container(
              height: height - 8,
              width: width - 8,
              decoration: const BoxDecoration(
                color: Color(0xffDCDCDC),
                border: Border(
                  left: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                  right: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                ),
              ),
            ),
            Container(
              height: height - 8 * 2,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                  right: BorderSide(
                    width: 4,
                    color: _borderColor,
                  ),
                ),
              ),
            ),
            Text("Get Started"),
          ],
        );
      },
    );
  }
}
