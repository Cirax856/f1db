import 'package:flutter/material.dart';

// pages
import './main.dart';

// components
import './templates/dropdown.dart';
import './templates/card.dart';

// api
import 'api/jolpica.dart';

// utilities
import './utils/colors.dart';
import './utils/funcs.dart';

class Calendar extends StatelessWidget {
  final String year;

  const Calendar({super.key, required this.year});

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
            child: FutureBuilder(
              future: getCalendar(year),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  try
                  {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('$year CALENDAR', style: TextStyle(fontSize: 36, color: AppColors.primary)),
                          ...snapshot.data!.map((session) {
                            const Map<String, String> sessionNames = {
                              "FirstPractice": "Free Practice 1",
                              "SecondPractice": "Free Practice 2",
                              "ThirdPractice": "Free Practice 3",
                              "SprintQualifying": "Sprint Qualifying",
                              "Sprint": "Sprint",
                              "Qualifying": "Qualifying",
                            };

                            return Column(
                              children: [
                                CustomDropdown(
                                  child1: Text("${session['raceName']}, ${session['Circuit']['Location']['country']}"),
                                  child2: [
                                    ...["FirstPractice", "SecondPractice", "ThirdPractice", "SprintQualifying", "Sprint", "Qualifying"].map((sessionType) {
                                      if (session[sessionType] != null) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(sessionNames[sessionType]!),
                                                    Text(parseDate(session[sessionType]['date'], session[sessionType]['time']), style: TextStyle(color: Colors.grey)),
                                                  ]
                                                ),
                                                DateTime.parse("${session[sessionType]['date']}T${session[sessionType]['time']}").isBefore(DateTime.now().toUtc())
                                                ?
                                                TextButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: AppColors.primary,
                                                    backgroundColor: AppColors.secondary,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4)
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10)
                                                  ),
                                                  child: const Text('RESULTS', style: TextStyle(fontSize: 8))
                                                )
                                                :
                                                const SizedBox.shrink(),
                                              ]
                                            ),
                                            const SizedBox(height: 10),
                                          ]
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Race"),
                                                Text(parseDate(session['date'], session['time']), style: TextStyle(color: Colors.grey)),
                                              ]
                                            ),
                                            DateTime.parse("${session['date']}T${session['time']}").isBefore(DateTime.now().toUtc())
                                            ?
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                foregroundColor: AppColors.primary,
                                                backgroundColor: AppColors.secondary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4)
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10)
                                              ),
                                              child: const Text('RESULTS', style: TextStyle(fontSize: 8))
                                            )
                                            :
                                            const SizedBox.shrink(),
                                          ]
                                        ),
                                        const SizedBox(height: 10),
                                      ]
                                    )
                                  ]
                                ),
                                const SizedBox(height: 10),
                              ]
                            );
                          }),
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
                    );
                  } catch (e) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Calendar for year $year not found. Keep in mind the first F1 season was in 1950, with many seasons not having a calendar available yet."),
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
                  }
                }
              },
            )
          )
        )
      )
    );
  }
}