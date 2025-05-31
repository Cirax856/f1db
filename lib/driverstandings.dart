import 'package:flutter/material.dart';

// pages
import './main.dart';

// components
import './templates/card.dart';

// api
import 'api/jolpica.dart';

// utilities
import './utils/colors.dart';

class DriverStandings extends StatelessWidget {
  final String year;

  const DriverStandings({super.key, required this.year});

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('DRIVER STANDINGS $year', style: TextStyle(fontSize: 28, color: AppColors.primary)),
                  FutureBuilder<List<dynamic>>(
                    future: getDriverStandings(year),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('Season finished.'));
                      } else {
                        return Column(
                          children: [
                            ...snapshot.data!.map((driver) {
                              return CustomCard(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${driver['position']}. ${driver['Driver']['givenName']} ${driver['Driver']['familyName']}", style: const TextStyle(fontSize: 16)),
                                    Text("${driver['points'].toString()} pts", style: const TextStyle(fontSize: 16))
                                  ]
                                )
                              );
                            })
                          ],
                        );
                      }
                    }
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
      )
    );
  }
}