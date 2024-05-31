import 'package:flutter/material.dart';
import 'package:green_scout/utils/achievement_manager.dart';
import 'package:green_scout/utils/action_bar.dart';
import 'package:green_scout/utils/app_state.dart';
import 'package:green_scout/utils/general_utils.dart';
import 'package:green_scout/widgets/header.dart';
import 'package:green_scout/widgets/navigation_layout.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final (width, widthPadding) =
        screenScaler(MediaQuery.of(context).size.width, 670, 0.5, 1.0);

    return Scaffold(
      drawer: const NavigationLayoutDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: createDefaultActionBar(),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          buildAchievementsList(context, AchievementManager.achievements,                                 "Achievements", true,  width, widthPadding, true),
          buildAchievementsList(context, AchievementManager.leaderboardBadges,                            "Badges",       false, width, widthPadding, false),
          buildAchievementsList(context, AchievementManager.silentBadges + AchievementManager.textBadges, "Other",        false, width, widthPadding, false),
        ],
      ),
    );
  }

  Widget buildProgressBar(double width, double percent) {
    return Center(
      child: LinearPercentIndicator(
        width: width,
        lineHeight: 20,
        percent: percent,
        backgroundColor: Colors.grey,
        progressColor: greenMachineGreen,
        alignment: MainAxisAlignment.center,
        barRadius: const Radius.circular(10),
        center: Text("${(percent * 100).truncate()}% complete"),
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 2000,
        curve: Curves.decelerate,
      ),
    );
  }

  List<Widget> buildUnlocksLayout(BuildContext context, Achievement achievement, double width, double widthPadding) {
    return [
      const Padding(padding: EdgeInsets.all(36)),

      const Text(
        "Unlocks",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),

      const Padding(padding: EdgeInsets.all(5)),

      Text(
        achievement.unlocks!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];
  } 

  void showInfoPopup(BuildContext context, Achievement achievement, double width, double widthPadding) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: widthPadding, vertical: 30),

            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(6)),

                  Text(
                    achievement.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),

                  const Padding(padding: EdgeInsets.all(20)),

                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: achievement.badge,
                  ),

                  const Padding(padding: EdgeInsets.all(6)),

                  Text(
                    achievement.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),

                  if (achievement.unlocks != null)
                    ...buildUnlocksLayout(context, achievement, width, widthPadding),

                  const Padding(padding: EdgeInsets.all(16)),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget buildAchievementsList(
    BuildContext context, List<Achievement> achievements, String header, bool unlockable, double width, double widthPadding, bool displayProgressBar
  ) {
    List<Widget> built = List.empty(growable: true);

    for (var value in achievements) {
      if (!unlockable && !value.met) {
        continue;
      }

      if (value.conditionMet != null) {
        value.conditionMet!(value.met);
      }

      built.add(
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 7),

          child: Stack(
            children: [
              if (value.showDescription && value.met)
                const Positioned(
                  left: 5,
                  top: 5,
                  child: Icon(Icons.info_outlined, size: 20, color: Colors.grey,), 
                ),

              InkWell( 
                // Weird hack, but what this does is make it so the button
                // doesn't have a clickable state when it doesn't have a description.
                onTap: !(value.showDescription && value.met) ? null : () {
                  // App.gotoPage(context, AchievementDescriptionPage(value), canGoBack: true);
                  showInfoPopup(context, value, width, widthPadding);
                },

                child: ConstrainedBox( 
                  constraints: BoxConstraints(
                    minHeight: width / 4,
                    minWidth: width / 4,
                  ),

                  child: Ink( 
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),

                      color: Colors.grey.shade100,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: 
                              value.met 
                              ? value.badge
                              : const Icon(Icons.lock_outline, size: 80),
                          ),
                          const Padding(padding: EdgeInsets.all(4)),
                          Text(
                            value.name, 
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (built.isNotEmpty) HeaderLabel(header, bold: true),

        if (displayProgressBar) 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),

            child: buildProgressBar(width, AchievementManager.getCompletionRatio()),
          ),

        const Padding(padding: EdgeInsets.all(8)),

        Wrap(
          spacing: 2,
          alignment: WrapAlignment.center,
          children: built.map((element) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),

              child: element,
            );
          }).toList(),
        ),

        const Padding(padding: EdgeInsets.all(16)),
      ],
    );
  }
}
