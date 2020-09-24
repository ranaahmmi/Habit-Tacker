import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/style/theme.dart' as Theme;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:prefecthabittracer/ui/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddWeeklyHabbit extends StatefulWidget {
  @override
  _AddWeeklyHabbitState createState() => _AddWeeklyHabbitState();
}

class _AddWeeklyHabbitState extends State<AddWeeklyHabbit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  double screenHeight, screenWidth; //only this day or everyday?
  String selectedTimesToRepeat =
      "One time per day"; //number of times to reapeat the reminder
  int ontimeday = 1;
  final format = DateFormat("yyyy-MM-dd");
  final formatf = DateFormat("HH:mm");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String weeklyTaskName;
  DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String finalday = DateFormat('EEEE').format(DateTime.now());
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Add weekly task to accomplish',
            style: prefix0.TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: prefix0.Colors.white,
          elevation: 0,
        ),
        key: _scaffoldKey,
        body: finalday == 'Thursday'
            ? NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: SingleChildScrollView(
                  child: _addHabbitForm(context),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  'You Can only Add Weekly Task on Sunday'
                      .text
                      .xl
                      .color(Colors.blue)
                      .makeCentered(),
                  20.heightBox,
                  Container(
                    width: context.screenWidth * 0.5,
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
                        splashColor: Theme.Colors.loginGradientEnd,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              //fontFamily: "WorkSansBold"
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ));
  }

  Widget _addHabbitForm(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: prefix0.CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: screenWidth - 0.1 * screenWidth,
                    height: selectedTimesToRepeat == 1
                        ? 350.0
                        : selectedTimesToRepeat == 2 ? 410 : 470,
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.title,
                                      color: Color(0x552B2Baa),
                                      size: 18.0,
                                    ),
                                    labelText: 'Your Weekly Habbit Title'),
                                validator: (val) => val.isEmpty
                                    ? 'Title can\'t be empty'
                                    : null,
                                onChanged: (value) {
                                  weeklyTaskName = value.trim();
                                }),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: DateTimeField(
                            decoration: prefix0.InputDecoration(
                              labelText: 'Due',
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0x552B2Baa),
                                size: 18.0,
                              ),
                              border: prefix0.InputBorder.none,
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 7)));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                setState(() {
                                  dateTime = DateTimeField.combine(date, time);
                                });
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    labelText:
                                        'No. of times to remind per day?',
                                    icon: Icon(
                                      Icons.add_alert,
                                      color: Color(0x552B2Baa),
                                      size: 18.0,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                                value: 1,
                                onChanged: (val) {
                                  setState(() {
                                    ontimeday = val;
                                    if (val == 2) {}
                                    selectedTimesToRepeat = "Two times per day";

                                    if (val == 3)
                                      selectedTimesToRepeat =
                                          "Three times per day";
                                  });
                                },
                                items: [
                                  DropdownMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      "One time per day",
                                    ),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 2,
                                    child: Text(
                                      "Two times per day",
                                    ),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 3,
                                    child: Text(
                                      "Three times per day",
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ontimeday,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: DateTimeField(
                                      format: formatf,
                                      decoration: prefix0.InputDecoration(
                                          border: prefix0.InputBorder.none,
                                          labelText: 'Remind me',
                                          icon: Icon(
                                            Icons.alarm,
                                            color: Color(0x552B2Baa),
                                            size: 18.0,
                                          )),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        return DateTimeField.convert(time);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(
                      bottom: 10,
                      top: selectedTimesToRepeat == 1
                          ? 330.0
                          : selectedTimesToRepeat == 2 ? 390 : 450),
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
                        begin: const FractionalOffset(1.2, 0.2),
                        end: const FractionalOffset(1.0, 2.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: .0, horizontal: 50.0),
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await Firestore.instance
                              .collection('UserData')
                              .document(user.uid)
                              .collection('WeeklyEvents')
                              .document(weeklyTaskName)
                              .setData({
                            "title": weeklyTaskName,
                            "timeInDay": selectedTimesToRepeat,
                            "event_date":
                                dateTime == null ? DateTime.now() : dateTime
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (ctx) => Wrapper()),
                              (route) => false);
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
