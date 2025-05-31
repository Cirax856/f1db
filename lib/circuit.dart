import 'package:flutter/material.dart';

// pages
import './main.dart';

// components
import './templates/card.dart';

// api
import 'api/jolpica.dart';

// utilities
import './utils/colors.dart';

class Circuit extends StatelessWidget {
  final String circuitId;

  const Circuit({super.key, required this.circuitId});

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
                  future: getCircuit(circuitId),
                  builder:(context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Circuit $circuitId not found. Try a more general name for the circuit."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Home()
                                      )
                                    );
                                  },
                                  child: const Text("OK")
                                ),
                              ]
                            );
                          },
                        );
                      });

                      return const SizedBox();
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found.'));
                    } else {
                      final circuit = snapshot.data!;
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(circuit['circuitName'], style: const TextStyle(fontSize: 20, color: AppColors.primary)),
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${circuit['Location']['locality']}, ${circuit['Location']['country']}", style: const TextStyle(fontSize: 16)),
                                Text("lat: ${circuit['Location']['lat']}", style: const TextStyle(fontSize: 16)),
                                Text("long: ${circuit['Location']['long']}", style: const TextStyle(fontSize: 16)),
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