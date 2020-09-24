import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:prefecthabittracer/models/destinationBottomNavigation.dart';
import 'package:prefecthabittracer/models/event.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/shared/Imagepicker.dart';
import 'package:prefecthabittracer/shared/loading.dart';
import 'package:prefecthabittracer/ui/addWeeklyHabbit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:prefecthabittracer/style/theme.dart' as Theme;
import 'package:velocity_x/velocity_x.dart';
import 'addChallengeScreen.dart';
import 'addDailyHabbit.dart';
import 'feedbackScreen.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView>
    with prefix0.SingleTickerProviderStateMixin {
  loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('_key_name');
  }

  setData() {
    loadData().then((value) {
      setState(() {
        firstA = value;
      });
    });
  }

  TextEditingController _textController;
  Map<DateTime, List> _dailyevents = {};
  Map<DateTime, List> _weeklyevents = {};
  List _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool firstA = false;

  @override
  void initState() {
    super.initState();
    setData();
    _textController = TextEditingController(
      text: 'sample text: ${widget.destination.title}',
    );
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  final Firestore db = Firestore.instance;
  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  Stream<List<EventModel>> getUserTaskLists(String uid) {
    Stream<QuerySnapshot> stream = db
        .collection('UserData')
        .document(uid)
        .collection('events')
        .snapshots();

    return stream.map((qShot) => qShot.documents
        .map((data) => EventModel(
              title: data['title'],
              repeat: data['repeat'],
              perday: data['timeInDay'],
              dones: data['dones'],
              eventDate: data['event_date'].toDate(),
            ))
        .toList());
  }

  Stream<List<EventModel>> getweeklytask(String uid) {
    Stream<QuerySnapshot> stream = db
        .collection('UserData')
        .document(uid)
        .collection('WeeklyEvents')
        .snapshots();

    return stream.map((qShot) => qShot.documents
        .map((data) => EventModel(
              title: data['title'],
              perday: data['timeInDay'],
              dones: data['dones'],
              eventDate: data['event_date'].toDate(),
            ))
        .toList());
  }

  String finalUserId;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    finalUserId = user.uid;
    return Scaffold(
      body: StreamBuilder(
          stream: getUserTaskLists(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _dailyevents = _groupEvents(allEvents);
              }
            }
            return Center(
                child: widget.destination.title == 'Daily Tasks'
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _buildTableCalendar(_dailyevents),
                          const SizedBox(height: 8.0),
                          Expanded(child: _buildEventList(user.uid)),
                          const SizedBox(height: 8.0),
                          _addHabbitButton(),
                        ],
                      )
                    : widget.destination.title == 'Weekly Tasks'
                        ? StreamBuilder(
                            stream: getweeklytask(user.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List weeklyevents = snapshot.data;
                                if (weeklyevents.isNotEmpty) {
                                  _weeklyevents = _groupEvents(weeklyevents);
                                }
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _buildTableWeekCalendar(_weeklyevents),
                                  const SizedBox(height: 8.0),
                                  Expanded(child: _buildEventList(user.uid)),
                                  const SizedBox(height: 8.0),
                                  _addHabbitButton(),
                                ],
                              );
                            })
                        : widget.destination.title == '90 Day Habbit'
                            ? StreamBuilder(
                                stream: db
                                    .collection('UserData')
                                    .document(user.uid)
                                    .collection('90 Day Challenge')
                                    .document('Challenge')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final doc = snapshot.data;
                                    if (firstA == true || firstA == null) {
                                      return Column(
                                        children: <Widget>[
                                          Text(
                                            doc['What is your most important goal that you want to achieve after 90 days?'],
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Expanded(
                                              child: _activeChallengeLayout(
                                                  doc['Date'])),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              'What is your most important goal that you want to achieve after 90 days?',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          _addChallengeButton()
                                        ],
                                      );
                                    }
                                  } else {
                                    return Loading();
                                  }
                                })
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                (MediaQuery.of(context)
                                                        .padding
                                                        .bottom +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top +
                                                    52 +
                                                    52 +
                                                    40),
                                        color: Colors.pink,
                                        child: ChatScreen()),
                                    //SizedBox(height: 8.0),
                                  ],
                                ),
                              ));
          }),
    );
  }

  Widget _buildTableCalendar(Map<DateTime, List> events) {
    return TableCalendar(
      calendarController: _calendarController,
      events: events,
      formatAnimation: FormatAnimation.slide,
      initialCalendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
          holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
          selectedColor: Colors.indigoAccent,
          todayColor: Colors.grey,
          markersColor: Colors.grey[400],
          outsideDaysVisible: true),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildTableWeekCalendar(Map<DateTime, List> events) {
    return TableCalendar(
      calendarController: _calendarController,
      events: events,
      formatAnimation: FormatAnimation.slide,
      initialCalendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
          holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
          selectedColor: Colors.indigoAccent,
          todayColor: Colors.grey,
          markersColor: Colors.grey[400],
          outsideDaysVisible: true),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventList(String uid) {
    if (_selectedEvents.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Text(
          'You don\'t have Habbits for this day. Create one now',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        )),
      );
    }
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    event.dones == "true"
                        ? Text(event.title)
                            .text
                            .capitalize
                            .xl2
                            .green600
                            .bold
                            .lineThrough
                            .make()
                            .p12()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title)
                                  .text
                                  .capitalize
                                  .xl2
                                  .green600
                                  .bold
                                  .make(),
                              5.heightBox,
                              event.repeat == null
                                  ? Container()
                                  : Text(event.repeat).text.make(),
                              5.heightBox,
                              Text(event.perday).text.make(),
                              5.heightBox,
                              Text(DateFormat.yMMMd()
                                      .add_jm()
                                      .format(event.eventDate))
                                  .text
                                  .center
                                  .make(),
                            ],
                          ).px16().py12(),
                    formattedDate ==
                                DateFormat('yyyy-MM-dd')
                                    .format(event.eventDate) &&
                            event.dones == "false"
                        ? PopupMenuButton(
                            icon: Icon(
                              Icons.settings,
                              size: 25,
                              color: Vx.blue800,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: InkWell(
                                  onTap: () async {
                                    await Firestore.instance
                                        .collection('UserData')
                                        .document(finalUserId)
                                        .collection('events')
                                        .document(event.title)
                                        .updateData({'dones': 'true'});

                                    setState(() {
                                      _selectedEvents.remove(event);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Done",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: InkWell(
                                  onTap: () async {
                                    await Firestore.instance
                                        .collection('UserData')
                                        .document(finalUserId)
                                        .collection('events')
                                        .document(event.title)
                                        .delete();
                                    setState(() {
                                      _selectedEvents.remove(event);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Remove",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddDailyHabbit(
                                                  note: false,
                                                  name: event.title,
                                                )));
                                  },
                                  child: Text(
                                    "Edit",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text('')
                  ],
                ),
              ))
          .toList(),
    );
    //}
  }

  Widget _activeChallengeLayout(Timestamp stamp) {
    final createDate = stamp.toDate();
    final date2 = DateTime.now();
    final difference = date2.difference(createDate).inDays;
    return Container(
//        color: Colors.pink,
        child: GridView.builder(
            itemCount: 91,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: index <= difference
                        ? LinearGradient(
                            colors: [
                              Theme.Colors.loginGradientEnd,
                              Theme.Colors.loginGradientStart
                            ],
                            begin: const FractionalOffset(1.8, 0.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)
                        : LinearGradient(
                            colors: [Colors.grey[400], Colors.grey[300]],
                            begin: const FractionalOffset(0.2, 2.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      if (index == difference + 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImagePickers(
                                      day: index,
                                    )));
                      }
                    },
                    child: index <= difference
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : index == difference + 1
                            ? Icon(
                                Icons.camera_alt,
                                size: 30,
                              )
                            : Center(
                                child: Text(
                                'Day $index',
                                style: TextStyle(
                                    color: index == 0 || index == 1
                                        ? Colors.white
                                        : Colors.grey[600]),
                              )),
                  ),
                ),
              );
            }));
  }

  Widget _addChallengeButton() {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.Colors.loginGradientEnd,
            offset: Offset(1.0, 2.0),
            // blurRadius: 10.0,
          ),
        ],
        gradient: new LinearGradient(
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart
            ],
            begin: const FractionalOffset(1.0, 2.2),
            end: const FractionalOffset(2.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          //splashColor: Theme.Colors.loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.destination.title == 'Daily Task'
                      ? AddDailyHabbit(
                          note: true,
                        )
                      : AddChallenge()),
            );
            setState(() {});
          }),
    );
  }

  Widget _addHabbitButton() {
    return Container(
      width: prefix0.MediaQuery.of(context).size.width - 20,
      height: 40,
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.Colors.loginGradientStart,
            offset: Offset(1.0, 2.0),
            //blurRadius: 20.0,
          ),
          BoxShadow(
            color: Theme.Colors.loginGradientEnd,
            offset: Offset(1.0, 2.0),
            // blurRadius: 20.0,
          ),
        ],
        gradient: new LinearGradient(
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart
            ],
            begin: const FractionalOffset(0.2, 3.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          //splashColor: Theme.Colors.loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Center(
            child: Text(
              widget.destination.title == 'Daily Tasks'
                  ? "Add Today Task"
                  : "Add Weekly Task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                //fontFamily: "WorkSansBold"
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      widget.destination.title == 'Daily Tasks'
                          ? AddDailyHabbit(
                              note: true,
                            )
                          : AddWeeklyHabbit()),
            ).then((value) => () {
                  setState(() {});
                });
          }),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    _animationController.forward(from: 0.0);
    if (events != null) {
      setState(() {
        _selectedEvents = events;
      });
    }
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }
}
