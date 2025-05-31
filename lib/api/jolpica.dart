// https://api.jolpi.ca/ergast/f1/

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getCalendar(String year) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/$year/races'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['RaceTable']['Races'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load calendar');
  }
}

Future<Map<String, dynamic>> getNextSession() async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/current/next'));

  if (response.statusCode == 200) {
    final race = json.decode(utf8.decode(response.bodyBytes))['MRData']['RaceTable']['Races'][0];

    if (race.isEmpty) {
      throw Exception('Something bad happened.');
    }

    final now = DateTime.now().toUtc();

    final sessions = {
      "FirstPractice": race["FirstPractice"],
      "SecondPractice": race["SecondPractice"],
      "ThirdPractice": race["ThirdPractice"],
      "SprintQualifying": race["SprintQualifying"],
      "Sprint": race["Sprint"],
      "Qualifying": race["Qualifying"],
      "Race": {"date": race["date"], "time": race["time"]}
    };

    final upcoming = sessions.entries
      .where((e) => e.value != null)
      .map((e) => {
        "session": e.key,
        "dateTime": DateTime.parse("${e.value['date']}T${e.value['time']}"),
        "info": e.value
      })
      .where((e) => e["dateTime"].isAfter(now))
      .toList()
      ..sort((a, b) => a["dateTime"].compareTo(b["dateTime"]));

    if (upcoming.isEmpty) {
      throw Exception('No upcoming sessions found.');
    }

    final next = upcoming.first;

    return {
      "raceName": race["raceName"],
      "circuit": race["Circuit"]["circuitName"],
      "location": race["Circuit"]["Location"]["locality"],
      "country": race["Circuit"]["Location"]["country"],
      "round": race["round"],
      "season": race["season"],
      "session": next["session"],
      "dateTime": next["dateTime"],
      "date": next["info"]["date"],
      "time": next["info"]["time"]
    };
  } else {
    throw Exception('Failed to load calendar');
  }
}

Future<List<dynamic>> getDriverStandings(String year) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/$year/driverstandings'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<List<dynamic>> getConstructorsStandings(String year) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/$year/constructorstandings'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<List<dynamic>> getCircuits() async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/circuits'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['CircuitTable']['Circuits'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<Map<String, dynamic>> getCircuit(String id) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/circuits/$id'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['CircuitTable']['Circuits'][0];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<List<dynamic>> getDrivers() async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/drivers'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['DriverTable']['Drivers'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<Map<String, dynamic>> getDriver(String id) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/drivers/$id'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['DriverTable']['Drivers'][0];

    if (data.isEmpty) {
      throw Exception('No data found for the given driver');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver data');
  }
}

Future<List<dynamic>> getConstructors() async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/constructors'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['ConstructorTable']['Constructors'];

    if (data.isEmpty) {
      throw Exception('No data found for the given year');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver standings');
  }
}

Future<Map<String, dynamic>> getConstructor(String id) async {
  final response = await http.get(Uri.parse('https://api.jolpi.ca/ergast/f1/constructors/$id'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes))['MRData']['ConstructorTable']['Constructors'][0];

    if (data.isEmpty) {
      throw Exception('No data found for the given driver');
    } else {
      return data;
    }
  } else {
    throw Exception('Failed to load driver data');
  }
}