import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_scout/utils/app_state.dart';
import 'package:green_scout/utils/main_app_data_helper.dart';

/// Generic class for holding data related to prefilling match schedules.
class MatchInfo {
  const MatchInfo(this.matchNum, this.team, this.isBlue, this.driveTeamNum);

  final int matchNum;
  final int team;

  final bool isBlue;
  final int driveTeamNum;
}

/// A class designed to pull and store data related to match scouting, which 
/// is all and assigned matches.
class MatchesData {
  static List<MatchInfo> allParsedMatches = [];
  static List<MatchInfo> allAssignedMatches = [];

  @protected
  static const String matchScheduleJsonKey = "Match Schedules";

  @protected
  static const String assignedMatchScheduleJsonKey = "Assigned Matches Schedule";

  static void getAllMatchesFromServer() async {
    await App.httpRequest("schedule", "", onGet: (response) {
      App.setString(matchScheduleJsonKey, response.body);
    });

    await App.httpRequest("singleSchedule", MainAppData.scouterName, onGet: (response) {
      App.setString(assignedMatchScheduleJsonKey, response.body);
    });

    parseMatches();
  }

  static MapEntry<bool, int> toMatchInformation(int obfuscated) {
    bool isBlue = obfuscated > 3;
    int dsNum = (obfuscated - 1) % 3 + 1;
    return MapEntry(isBlue, dsNum);
  }

  static void parseMatches() {
    String? scheduleJsonString = App.getString(matchScheduleJsonKey);
    String? assignedJsonString = App.getString(assignedMatchScheduleJsonKey);

    if (scheduleJsonString == null || scheduleJsonString == "") {
      return;
    }

    if (assignedJsonString == null || assignedJsonString == "") {
      return;
    }

    try {
      final scheduleJson =
          jsonDecode(scheduleJsonString) as Map<dynamic, dynamic>;

      if (scheduleJson.isEmpty) {
        return;
      }

      allParsedMatches.clear();
      allAssignedMatches.clear();
      for (var entry in scheduleJson.entries) {
        final matchNum = int.parse(entry.key);
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Red"][0], false, 1));
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Red"][1], false, 2));
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Red"][2], false, 3));
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Blue"][0], true, 1));
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Blue"][1], true, 2));
        allParsedMatches
            .add(MatchInfo(matchNum, entry.value["Blue"][2], true, 3));
      }

      Map<String, dynamic> assignedJson = jsonDecode(assignedJsonString);

      List<dynamic> ranges = assignedJson['Ranges'];

      List<List<int>> ranges2D = ranges.map((range) {
        return List<int>.from(range);
      }).toList();

      for (var range in ranges2D) {
        int beginning = range[0];
        int end = range[1];

        for (int i = beginning - 1; i < end; i++) {
          allAssignedMatches
              .add(allParsedMatches.elementAt(i * 6 + range[2] - 1));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
