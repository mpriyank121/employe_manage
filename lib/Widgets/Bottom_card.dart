import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class BottomCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const BottomCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BottomCardConfig.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(BottomCardConfig.borderRadius),
          bottomRight: Radius.circular(BottomCardConfig.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Worked Days', textAlign: TextAlign.center, style: BottomCardConfig.commonTextStyle),
                  Text('52 Days', textAlign: TextAlign.center, style: BottomCardConfig.commonTextStyle),
                ],
              ),
            ),
            if (i != 2) // Add separator only between items
              Container(
                width: screenWidth * BottomCardConfig.separatorWidthFactor,
                height: screenHeight * BottomCardConfig.separatorHeightFactor,
                color: BottomCardConfig.separatorColor,
              ),
          ],
        ],
      ),
    );
  }
}
