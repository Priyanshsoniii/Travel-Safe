import 'package:flutter/material.dart';
import 'package:gang/utils/quotes.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  //const CustomAppBar({super.key});

  Function? onTap;
  int? quoteIndex;
  CustomAppBar({super.key, this.onTap, this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
          child: Text(sweetSayings[quoteIndex!],
              style: const TextStyle(
                fontSize: 22,
              ))),
    );
  }
}
