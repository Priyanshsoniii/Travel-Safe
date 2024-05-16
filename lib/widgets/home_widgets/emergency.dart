import 'package:flutter/material.dart';
import 'package:gang/widgets/home_widgets/emergencies/AmbulanceEmergency.dart';
import 'package:gang/widgets/home_widgets/emergencies/ArmyEmergency.dart';
import 'package:gang/widgets/home_widgets/emergencies/FirebrigadeEmergency.dart';
import 'package:gang/widgets/home_widgets/emergencies/policeemergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: const [
           PoliceEmergency(),
          AmbulanceEmergency(),
          FirebrigadeEmergency(),
          ArmyEmergency(),
        ],
      ),
    );
  }
}
