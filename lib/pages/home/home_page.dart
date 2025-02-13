// ignore_for_file: dead_code
import 'dart:math';

import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam/exam_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/grade_viewable.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';
import 'package:confetti/confetti.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group/absence_group_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/cretification/certification_card.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/timetable/changed_lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/updates/updates_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'home_page.i18n.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late UserProvider user;
  late SettingsProvider settings;
  late UpdateProvider updateProvider;
  late StatusProvider statusProvider;
  late GradeProvider gradeProvider;
  late TimetableProvider timetableProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late HomeworkProvider homeworkProvider;
  late ExamProvider examProvider;
  late NoteProvider noteProvider;
  late EventProvider eventProvider;

  late LiveCardController _liveController;
  late PageController _pageController;
  ConfettiController? _confettiController;

  late String greeting;
  late String firstName;

  List<String> listOrder = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    user = Provider.of<UserProvider>(context, listen: false);
    _liveController = LiveCardController(context: context, vsync: this);

    DateTime now = DateTime.now();
    if (now.isBefore(DateTime(now.year, DateTime.august, 31)) && now.isAfter(DateTime(now.year, DateTime.june, 14))) {
      greeting = "goodrest";

      if (NavigationScreen.of(context)?.init("confetti") ?? false) {
        _confettiController = ConfettiController(duration: const Duration(seconds: 1));
        Future.delayed(const Duration(seconds: 1)).then((value) => mounted ? _confettiController?.play() : null);
      }
    } else if (now.month == user.student?.birth.month && now.day == user.student?.birth.day) {
      greeting = "happybirthday";

      if (NavigationScreen.of(context)?.init("confetti") ?? false) {
        _confettiController = ConfettiController(duration: const Duration(seconds: 3));
        Future.delayed(const Duration(seconds: 1)).then((value) => mounted ? _confettiController?.play() : null);
      }
    } else if (now.month == DateTime.december && now.day >= 24 && now.day <= 26) {
      greeting = "merryxmas";
    } else if (now.month == DateTime.january && now.day == 1) {
      greeting = "happynewyear";
    } else if (now.hour >= 18) {
      greeting = "goodevening";
    } else if (now.hour >= 10) {
      greeting = "goodafternoon";
    } else if (now.hour >= 4) {
      greeting = "goodmorning";
    } else {
      greeting = "goodevening";
    }
  }

  @override
  void dispose() {
    // _filterController.dispose();
    _liveController.dispose();
    _pageController.dispose();
    _tabController.dispose();
    _confettiController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    statusProvider = Provider.of<StatusProvider>(context, listen: false);
    gradeProvider = Provider.of<GradeProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);
    messageProvider = Provider.of<MessageProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    examProvider = Provider.of<ExamProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    eventProvider = Provider.of<EventProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "Béla";
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: NestedScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                headerSliverBuilder: (context, _) => [
                      AnimatedBuilder(
                        animation: _liveController.animation,
                        builder: (context, child) {
                          return SliverAppBar(
                            automaticallyImplyLeading: false,
                            centerTitle: false,
                            titleSpacing: 0.0,
                            // Welcome text
                            title: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                greeting.i18n.fill([firstName]),
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                ),
                              ),
                            ),
                            actions: [
                              // TODO: Search Button
                              // IconButton(
                              //   icon: Icon(FeatherIcons.search),
                              //   color: Theme.of(context).textTheme.bodyText1?.color,
                              //   splashRadius: 24.0,
                              //   onPressed: () {},
                              // ),

                              // Profile Icon
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: ProfileButton(
                                  child: ProfileImage(
                                    heroTag: "profile",
                                    name: firstName,
                                    backgroundColor: !settings.presentationMode
                                        ? ColorUtils.stringToColor(user.name ?? "?")
                                        : Theme.of(context).colorScheme.secondary,
                                    badge: updateProvider.available,
                                    role: user.role,
                                  ),
                                ),
                              ),
                            ],

                            expandedHeight: _liveController.animation.value * 234.0,

                            // Live Card
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding: EdgeInsets.only(
                                  left: 24.0,
                                  right: 24.0,
                                  top: 58.0 + MediaQuery.of(context).padding.top,
                                  bottom: 52.0,
                                ),
                                child: LiveCard(
                                  controller: _liveController,
                                ),
                              ),
                            ),
                            shadowColor: Colors.black,

                            // Filter Bar
                            bottom: FilterBar(
                              items: [
                                Tab(text: "All".i18n),
                                Tab(text: "Grades".i18n),
                                Tab(text: "Messages".i18n),
                                Tab(text: "Absences".i18n),
                              ],
                              controller: _tabController,
                              onTap: (i) async {
                                int selectedPage = _pageController.page!.round();

                                if (i == selectedPage) return;
                                if (_pageController.page?.roundToDouble() != _pageController.page) {
                                  _pageController.animateToPage(i, curve: Curves.easeIn, duration: kTabScrollDuration);
                                  return;
                                }

                                // swap current page with target page
                                setState(() {
                                  _pageController.jumpToPage(i);
                                  String currentList = listOrder[selectedPage];
                                  listOrder[selectedPage] = listOrder[i];
                                  listOrder[i] = currentList;
                                });
                              },
                            ),
                            pinned: true,
                            floating: false,
                            snap: false,
                          );
                        },
                      ),
                    ],
                body: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // from flutter source
                      if (notification is ScrollUpdateNotification && !_tabController.indexIsChanging) {
                        if ((_pageController.page! - _tabController.index).abs() > 1.0) {
                          _tabController.index = _pageController.page!.floor();
                        }
                        _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                      } else if (notification is ScrollEndNotification) {
                        _tabController.index = _pageController.page!.round();
                        if (!_tabController.indexIsChanging) _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                      }
                      return false;
                    },
                    child: PageView.custom(
                      controller: _pageController,
                      childrenDelegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return FutureBuilder<List<DateWidget>>(
                              key: ValueKey<String>(listOrder[index]),
                              future: getFilterWidgets(HomeFilter.values[index]),
                              builder: (context, dateWidgets) => dateWidgets.data != null
                                  ? RefreshIndicator(
                                      color: Theme.of(context).colorScheme.secondary,
                                      onRefresh: () => syncAll(context),
                                      child: ImplicitlyAnimatedList<Widget>(
                                        items: sortDateWidgets(context, dateWidgets: dateWidgets.data!),
                                        itemBuilder: _itemBuilder,
                                        spawnIsolate: false,
                                        areItemsTheSame: (a, b) => a.key == b.key,
                                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                      ))
                                  : Container(),
                            );
                          },
                          childCount: 4,
                          findChildIndexCallback: (Key key) {
                            final ValueKey<String> valueKey = key as ValueKey<String>;
                            final String data = valueKey.value;
                            return listOrder.indexOf(data);
                          }),
                      physics: const PageScrollPhysics().applyTo(const BouncingScrollPhysics()),
                    ),
                  ),
                )),
          ),

          // confetti 🎊
          if (_confettiController != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _confettiController!,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 80,
                maxBlastForce: 100,
                minBlastForce: 90,
                gravity: 0.3,
                minimumSize: const Size(5, 5),
                maximumSize: const Size(20, 20),
              ),
            ),
        ],
      ),
    );
  }

  Future<List<DateWidget>> getFilterWidgets(HomeFilter activeData, {bool absencesNoExcused = false}) async {
    List<DateWidget> items = [];

    switch (activeData) {
      // All
      case HomeFilter.all:
        final all = await Future.wait<List<DateWidget>>([
          getFilterWidgets(HomeFilter.grades),
          getFilterWidgets(HomeFilter.lessons),
          getFilterWidgets(HomeFilter.messages),
          getFilterWidgets(HomeFilter.absences, absencesNoExcused: true),
          getFilterWidgets(HomeFilter.homework),
          getFilterWidgets(HomeFilter.exams),
          getFilterWidgets(HomeFilter.updates),
          getFilterWidgets(HomeFilter.certifications),
          getFilterWidgets(HomeFilter.missedExams),
        ]);
        items.addAll(all.expand((x) => x));

        break;

      // Grades
      case HomeFilter.grades:
        for (var grade in gradeProvider.grades) {
          if (grade.type == GradeType.midYear) {
            items.add(DateWidget(
              key: grade.id,
              date: grade.date,
              widget: GradeViewable(grade),
            ));
          }
        }
        break;

      // Certifications
      case HomeFilter.certifications:
        for (var gradeType in GradeType.values) {
          if ([GradeType.midYear, GradeType.unknown, GradeType.levelExam].contains(gradeType)) continue;

          List<Grade> grades = gradeProvider.grades.where((grade) => grade.type == gradeType).toList();
          if (grades.isNotEmpty) {
            grades.sort((a, b) => -a.date.compareTo(b.date));

            items.add(DateWidget(
              date: grades.first.date,
              widget: CertificationCard(
                grades,
                gradeType: gradeType,
              ),
            ));
          }
        }
        break;

      // Messages
      case HomeFilter.messages:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
                key: "${message.id}",
                date: message.date,
                widget: MessageTile(
                  message,
                )));
          }
        }
        items.addAll(await getFilterWidgets(HomeFilter.notes));
        items.addAll(await getFilterWidgets(HomeFilter.events));
        break;

      // Absences
      case HomeFilter.absences:
        absenceProvider.absences.where((a) => !absencesNoExcused || a.state != Justification.excused).forEach((absence) {
          items.add(DateWidget(
            key: absence.id,
            date: absence.date,
            widget: AbsenceViewable(absence),
          ));
        });
        break;

      // Homework
      case HomeFilter.homework:
        final now = DateTime.now();
        homeworkProvider.homework.where((h) => h.deadline.hour == 0 ? _sameDate(h.deadline, now) : h.deadline.isAfter(now)).forEach((homework) {
          items.add(DateWidget(
              key: homework.id,
              date: homework.deadline.year != 0 ? homework.deadline : homework.date,
              widget: HomeworkTile(
                homework,
                onTap: () => HomeworkView.show(homework, context: context),
              )));
        });
        break;

      // Exams
      case HomeFilter.exams:
        for (var exam in examProvider.exams) {
          items.add(DateWidget(
            key: exam.id,
            date: exam.writeDate.year != 0 ? exam.writeDate : exam.date,
            widget: ExamViewable(exam),
          ));
        }
        break;

      // Notes
      case HomeFilter.notes:
        for (var note in noteProvider.notes) {
          items.add(DateWidget(
              key: note.id,
              date: note.date,
              widget: NoteTile(
                note,
                onTap: () => NoteView.show(note, context: context),
              )));
        }
        break;

      // Events
      case HomeFilter.events:
        for (var event in eventProvider.events) {
          items.add(DateWidget(
              key: event.id,
              date: event.start,
              widget: EventTile(
                event,
                onTap: () => EventView.show(event, context: context),
              )));
        }
        break;

      // Changed Lessons
      case HomeFilter.lessons:
        timetableProvider.lessons.where((l) => l.isChanged && l.start.isAfter(DateTime.now())).forEach((lesson) {
          items.add(DateWidget(
              key: lesson.id,
              date: lesson.date,
              widget: ChangedLessonTile(
                lesson,
                onTap: () => TimetablePage.jump(context, lesson: lesson),
              )));
        });
        break;

      // Updates
      case HomeFilter.updates:
        if (updateProvider.available) {
          items.add(DateWidget(
            date: DateTime.now(),
            widget: PanelButton(
              onPressed: () => openUpdates(context),
              title: Text("update_available".i18n),
              leading: const Icon(FeatherIcons.download),
              trailing: Text(
                updateProvider.releases.first.tag,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ));
        }
        break;

      // Missed Exams
      case HomeFilter.missedExams:
        List<Lesson> missedExams = [];

        for (var lesson in timetableProvider.lessons) {
          final desc = lesson.description.toLowerCase().specialChars();
          if (!lesson.studentPresence &&
              (lesson.exam != "" ||
                  desc.contains("dolgozat") ||
                  desc.contains("feleles") ||
                  desc.contains("temazaro") ||
                  desc.contains("szamonkeres") ||
                  desc == "tz") &&
              !(desc.contains("felkeszules") || desc.contains("gyakorlas"))) {
            missedExams.add(lesson);
          }
        }

        if (missedExams.isNotEmpty) {
          missedExams.sort((a, b) => -a.date.compareTo(b.date));

          items.add(
            DateWidget(
              date: missedExams.first.date,
              widget: PanelButton(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                leading: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      FeatherIcons.slash,
                      color: AppColors.of(context).red.withOpacity(.75),
                      size: 28.0,
                    )),
                title: Text("missed_exams".plural(missedExams.length).fill([missedExams.length])),
                trailing: const Icon(FeatherIcons.arrowRight),
                onPressed: () => showRoundedModalBottomSheet(context,
                    child: Column(
                      children: missedExams
                          .map((lesson) => Material(
                                type: MaterialType.transparency,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    leading: Icon(
                                      SubjectIcon.lookup(subject: lesson.subject),
                                      color: AppColors.of(context).text.withOpacity(.8),
                                      size: 32.0,
                                    ),
                                    title: Text(
                                      "${lesson.subject.name.capital()} • ${lesson.date.format(context)}",
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      "missed_exam_contact".i18n.fill([lesson.teacher]),
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    trailing: const Icon(FeatherIcons.arrowRight),
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                      TimetablePage.jump(context, lesson: lesson);
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    )),
              ),
            ),
          );
        }
        break;
    }
    return items;
  }

  void openUpdates(BuildContext context) => UpdateView.show(updateProvider.releases.first, context: context);

  Future<Widget> filterViewBuilder(context, int activeData) async {
    HomeFilter activeFilter = HomeFilter.values[activeData];

    List<Widget> filterWidgets = sortDateWidgets(context, dateWidgets: await getFilterWidgets(activeFilter), showDivider: true);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => syncAll(context),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: filterWidgets[index],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}

// difference.inDays is not reliable
bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);

List<Widget> sortDateWidgets(
  BuildContext context, {
  required List<DateWidget> dateWidgets,
  bool showTitle = true,
  bool showDivider = false,
  bool hasShadow = false,
  EdgeInsetsGeometry? padding,
}) {
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<Conversation> conversations = [];
  List<DateWidget> convMessages = [];

  // Group messages into conversations
  for (var w in dateWidgets) {
    if (w.widget.runtimeType == MessageTile) {
      Message message = (w.widget as MessageTile).message;

      if (message.conversationId != null) {
        convMessages.add(w);

        Conversation conv = conversations.firstWhere((e) => e.id == message.conversationId, orElse: () => Conversation(id: message.conversationId!));
        conv.add(message);
        if (conv.messages.length == 1) conversations.add(conv);
      }

      if (conversations.any((c) => c.id == message.messageId)) {
        Conversation conv = conversations.firstWhere((e) => e.id == message.messageId);
        convMessages.add(w);
        conv.add(message);
      }
    }
  }

  // remove individual messages
  for (var e in convMessages) {
    dateWidgets.remove(e);
  }

  // Add conversations
  for (var conv in conversations) {
    conv.sort();

    dateWidgets.add(DateWidget(
      key: "${conv.newest.date.millisecondsSinceEpoch}-msg",
      date: conv.newest.date,
      widget: MessageTile(
        conv.newest,
      ),
    ));
  }

  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<List<DateWidget>> groupedDateWidgets = [[]];
  for (var element in dateWidgets) {
    if (groupedDateWidgets.last.isNotEmpty) {
      if (!_sameDate(element.date, groupedDateWidgets.last.last.date)) {
        groupedDateWidgets.add([element]);
        continue;
      }
    }
    groupedDateWidgets.last.add(element);
  }

  List<DateWidget> items = [];

  if (groupedDateWidgets.first.isNotEmpty) {
    for (var elements in groupedDateWidgets) {
      bool _showTitle = showTitle;

      // Group Absence Tiles
      List<DateWidget> absenceTileWidgets = elements.where((element) {
        return element.widget is AbsenceViewable && (element.widget as AbsenceViewable).absence.delay == 0;
      }).toList();
      List<AbsenceViewable> absenceTiles = absenceTileWidgets.map((e) => e.widget as AbsenceViewable).toList();
      if (absenceTiles.length > 1) {
        elements.removeWhere((element) => element.widget.runtimeType == AbsenceViewable && (element.widget as AbsenceViewable).absence.delay == 0);
        if (elements.isEmpty) {
          _showTitle = false;
        }
        elements.add(DateWidget(
            widget: AbsenceGroupTile(absenceTiles, showDate: !_showTitle),
            date: absenceTileWidgets.first.date,
            key: "${absenceTileWidgets.first.date.millisecondsSinceEpoch}-absence-group"));
      }

      // Bring Lesson Tiles to front & sort by index asc
      List<DateWidget> lessonTiles = elements.where((element) {
        return element.widget.runtimeType == ChangedLessonTile;
      }).toList();
      lessonTiles.sort((a, b) => (a.widget as ChangedLessonTile).lesson.lessonIndex.compareTo((b.widget as ChangedLessonTile).lesson.lessonIndex));
      elements.removeWhere((element) => element.widget.runtimeType == ChangedLessonTile);
      elements.insertAll(0, lessonTiles);

      final date = (elements + absenceTileWidgets).first.date;
      items.add(DateWidget(
        date: date,
        widget: Panel(
          key: ValueKey(date),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 6.0),
          title: _showTitle ? Text(date.format(context, forceToday: true)) : null,
          hasShadow: hasShadow,
          child: ImplicitlyAnimatedList<DateWidget>(
            areItemsTheSame: (a, b) => a.key == b.key,
            spawnIsolate: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, animation, item, index) => _itemBuilder(context, animation, item.widget, index),
            items: elements,
          ),
        ),
      ));
    }
  }

  final _now = DateTime.now();
  final now = DateTime(_now.year, _now.month, _now.day).subtract(const Duration(seconds: 1));

  if (showDivider && items.any((i) => i.date.isBefore(now)) && items.any((i) => i.date.isAfter(now))) {
    items.add(
      DateWidget(
        date: now,
        widget: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            height: 3.0,
            width: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: AppColors.of(context).text.withOpacity(.25),
            ),
          ),
        ),
      ),
    );
  }

  // Sort future dates asc, past dates desc
  items.sort((a, b) => (a.date.isAfter(now) && b.date.isAfter(now) ? 1 : -1) * a.date.compareTo(b.date));

  return items.map((e) => e.widget).toList();
}

class DateWidget {
  final DateTime date;
  final Widget widget;
  final String? key;
  const DateWidget({required this.date, required this.widget, this.key});
}

Widget _itemBuilder(BuildContext context, Animation<double> animation, Widget item, int index) {
  final wrappedItem = SizeFadeTransition(
    curve: Curves.easeInOutCubic,
    animation: animation,
    child: item,
  );
  return item is Panel
      // Re-add & animate shadow
      ? AnimatedBuilder(
          animation: animation,
          child: wrappedItem,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DecoratedBox(
                child: child,
                decoration: BoxDecoration(
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(
                        offset: const Offset(0, 21),
                        blurRadius: 23.0,
                        color: AppColors.of(context).shadow.withOpacity(
                              CurvedAnimation(
                                parent: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
                                curve: const Interval(2 / 3, 1.0),
                              ).value,
                            ),
                      ),
                  ],
                ),
              ),
            );
          })
      : wrappedItem;
}

enum HomeFilter { all, grades, messages, absences, homework, exams, notes, events, lessons, updates, certifications, missedExams }
