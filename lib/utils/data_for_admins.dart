import 'dart:async';
import 'dart:convert';

import 'package:green_scout/utils/app_state.dart';

class AdminData {
  static const noActiveUserSelected =
      "[[CURRENTLY NO ACTIVE USER IS SELECTED AT THIS MOMENT]]";

  static StreamController<Map<String, String>> usersController = StreamController();

  static Map<String, String> users = {
    "None": noActiveUserSelected,
  };

  static Future<void> updateUserRoster() async {
    usersController = StreamController();
    users = {
      "None": noActiveUserSelected,
    };

    await App.httpGet(
      "allUsers",
      "",
      (response) {
        final respList = jsonDecode(response.body);

        respList.forEach((element) {
          Iterable<MapEntry> entries;
          entries = (element as Map).entries;

          users[entries.first.value] = entries.last.value;
        });

        usersController.add(users);
        usersController.done.then((value) {
          usersController.close();
        });
      }
    );
  }

  static List<String> getDisplayNames() {
    return users.keys.toList();
  }

  static List<String> getUserIDs() {
    return users.values.toList();
  }
}