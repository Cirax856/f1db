import 'package:flutter/material.dart';

// pages
import './main.dart';

// components
import './templates/card.dart';

// api
import 'api/jolpica.dart';

// utilities
import './utils/colors.dart';

class Constructor extends StatelessWidget {
  final String constructorName;

  const Constructor({super.key, required this.constructorName});

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
                
                FutureBuilder<Map<String, dynamic>>(
                  future: getConstructor(constructorName),
                  builder:(context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found.'));
                    } else {
                      final constructor = snapshot.data!;
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text("${constructor['name']}", style: const TextStyle(fontSize: 20, color: AppColors.primary)),
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("nationality: ${constructor['nationality']}", style: const TextStyle(fontSize: 16)),
                              ],
                            )
                          )
                        ],
                      );
                    }
                  },
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