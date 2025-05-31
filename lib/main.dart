import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// pages
import './calendar.dart';
import './about.dart';
import './driverstandings.dart';
import './constructorsstandings.dart';
import './circuit.dart';
import './driver.dart';
import './constructor.dart';

// components
import './templates/card.dart';

// api
import 'api/jolpica.dart';

// utilities
import './utils/colors.dart';
import './utils/funcs.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter'
      ),
      home: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text('F1 DATABASE', style: TextStyle(fontSize: 36, color: AppColors.primary)),

                CustomCard(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                            future: getNextSession(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return const Center(child: Text('Season finished.'));
                              } else {
                                const Map<String, String> sessionNames = {
                                  "FirstPractice": "FP1",
                                  "SecondPractice": "FP2",
                                  "ThirdPractice": "FP3",
                                  "SprintQualifying": "SQ",
                                  "Sprint": "Sprint",
                                  "Qualifying": "Quali",
                                  "Race": "Race"
                                };

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Next race...', style: TextStyle(fontSize: 20)),
                                    Text(snapshot.data!['location'].toUpperCase(), style: TextStyle(fontSize: 30)),
                                    Text("${sessionNames[snapshot.data!["session"]]}, ${DateFormat("MMM d").format(snapshot.data!['dateTime'])}${suffix(snapshot.data!['dateTime'].day)} ${DateFormat("h:mm a").format(snapshot.data!['dateTime'].toLocal())}"),
                                  ]
                                );
                              }
                            },
                          )
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Builder(
                          builder: (BuildContext innerContext) {
                            return TextButton(
                              onPressed: () {
                                Navigator.of(innerContext).push(
                                  MaterialPageRoute(
                                    builder: (context) => Calendar(year: DateTime.now().year.toString())
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                backgroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
                              ),
                              child: Text('${DateTime.now().year.toString()} calendar')
                            );
                          }
                        )
                      )
                    ]
                  )
                ),

                CustomCard(
                  child: Column(
                    children: [
                      const Text('STANDINGS', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(innerContext).push(
                                      MaterialPageRoute(
                                        builder: (context) => DriverStandings(year: DateTime.now().year.toString())
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
                                  child: const Text('DRIVERS', style: TextStyle(fontSize: 11))
                                );
                              }
                            )
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(innerContext).push(
                                      MaterialPageRoute(
                                        builder: (context) => ConstructorsStandings(year: DateTime.now().year.toString())
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
                                  child: const Text('CONSTRUCTORS', style: TextStyle(fontSize: 10))
                                );
                              }
                            )
                          )
                        ]
                      ),
                      const SizedBox(height: 10),
                    ]
                  ),
                ),

                CustomCard(
                  child: Column(
                    children: [
                      const Text("SEARCH DATA", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    int currentYear = DateTime.now().year;
                                    int selectedYear = currentYear;

                                    showDialog(
                                      context: innerContext,
                                      builder: (innerContext) {
                                        return AlertDialog(
                                          title: const Text('Select Year'),
                                          content: StatefulBuilder(
                                            builder: (context, setState) {
                                              return TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(labelText: 'Enter Year'),
                                                onChanged: (value) {
                                                  final parsed = int.tryParse(value);
                                                  if (parsed != null) {
                                                    setState(() {
                                                      selectedYear = parsed;
                                                    });
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(innerContext).pop();
                                                Navigator.of(innerContext).push(
                                                  MaterialPageRoute(builder: (context) => Calendar(year: selectedYear.toString()))
                                                );
                                              },
                                              child: const Text('OK'),
                                            )
                                          ],
                                        );
                                      },
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
                                  child: const Text('CALENDARS', style: TextStyle(fontSize: 11))
                                );
                              }
                            )
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: innerContext,
                                      builder: (innerContext) {
                                        String selectedCircuit = '';

                                        return AlertDialog(
                                          title: const Text('Select Circuit'),
                                          content: StatefulBuilder(
                                            builder: (context, setState) {
                                              return TextField(
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(labelText: 'Enter Circuit'),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCircuit = value;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(innerContext).pop();
                                                Navigator.of(innerContext).push(
                                                  MaterialPageRoute(builder: (context) => Circuit(circuitId: selectedCircuit.toString()))
                                                );
                                              },
                                              child: const Text('OK'),
                                            )
                                          ],
                                        );
                                      },
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
                                  child: const Text('CIRCUITS', style: TextStyle(fontSize: 11))
                                );
                              }
                            )
                          )
                        ]
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: innerContext,
                                      builder: (innerContext) {
                                        return FutureBuilder<List<dynamic>>(
                                          future: getDrivers(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(child: CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(child: Text('Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData) {
                                              return const Center(child: Text('No driver data available.'));
                                            } else {
                                              String selectedCircuit = snapshot.data![0]['driverId'];

                                              return AlertDialog(
                                                title: const Text('Select Driver'),
                                                content: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return DropdownButton<String>(
                                                      value: selectedCircuit,
                                                      items: [
                                                        ...snapshot.data!.map((circuit) {
                                                          return DropdownMenuItem(value: (circuit as Map<String, dynamic>)['driverId'] as String, child: Text("${circuit['givenName'].toString()} ${circuit['familyName'].toString()}", style: const TextStyle(fontSize: 11)));
                                                        })
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedCircuit = value!;
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(innerContext).pop();
                                                      Navigator.of(innerContext).push(
                                                        MaterialPageRoute(builder: (context) => Driver(driverName: selectedCircuit.toString()))
                                                      );
                                                    },
                                                    child: const Text('OK'),
                                                  )
                                                ],
                                              );
                                            }
                                          }
                                        );
                                      },
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
                                  child: const Text('DRIVERS', style: TextStyle(fontSize: 11))
                                );
                              }
                            )
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: innerContext,
                                      builder: (innerContext) {
                                        return FutureBuilder<List<dynamic>>(
                                          future: getConstructors(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(child: CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(child: Text('Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData) {
                                              return const Center(child: Text('No driver data available.'));
                                            } else {
                                              String selectedCircuit = snapshot.data![0]['constructorId'];

                                              return AlertDialog(
                                                title: const Text('Select Constructor'),
                                                content: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return DropdownButton<String>(
                                                      value: selectedCircuit,
                                                      items: [
                                                        ...snapshot.data!.map((circuit) {
                                                          return DropdownMenuItem(value: (circuit as Map<String, dynamic>)['constructorId'] as String, child: Text(circuit['name'].toString(), style: const TextStyle(fontSize: 11)));
                                                        })
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedCircuit = value!;
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(innerContext).pop();
                                                      Navigator.of(innerContext).push(
                                                        MaterialPageRoute(builder: (context) => Constructor(constructorName: selectedCircuit.toString()))
                                                      );
                                                    },
                                                    child: const Text('OK'),
                                                  )
                                                ],
                                              );
                                            }
                                          }
                                        );
                                      },
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
                                  child: const Text('CONSTRUCTORS', style: TextStyle(fontSize: 10))
                                );
                              }
                            )
                          )
                        ]
                      )
                    ],
                  )
                ),

                CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: Builder(
                          builder: (BuildContext innerContext) {
                            return TextButton(
                              onPressed: () {
                                Navigator.of(innerContext).push(
                                  MaterialPageRoute(
                                    builder: (context) => const About()
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
                              child: const Text('ABOUT', style: TextStyle(fontSize: 11))
                            );
                          }
                        )
                      )
                    ]
                  )
                )
              ],
            )
          )
        )
      ),
    );
  }
}
