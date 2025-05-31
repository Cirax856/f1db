import 'package:flutter/material.dart';

// pages
import './main.dart';

// components
import './templates/card.dart';

// utilities
import './utils/colors.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('ABOUT F1DB', style: TextStyle(fontSize: 36, color: AppColors.primary)),
                CustomCard(
                  child: Text('F1DB is an open-source app for Formula 1 data, providing information about real-time and historical F1 events, circuits, drivers, teams, and more. It is designed to be easy to use and search for information.', textAlign: TextAlign.center),
                ),
                CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Home()
                              )
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10)
                          ),
                          child: const Text('BACK', style: TextStyle(fontSize: 11))
                        ),
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}