import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/style/theme.dart' as Theme;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';

class AddDailyHabbit extends StatefulWidget {
  final bool note;
  final String name;

  const AddDailyHabbit({Key key, @required this.note, this.name})
      : super(key: key);
  @override
  _AddDailyHabbitState createState() => _AddDailyHabbitState();
}

class _AddDailyHabbitState extends State<AddDailyHabbit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeTitle = FocusNode(); //Text field
  final FocusNode myFocusNodeRepeat =
      FocusNode(); //only this day or everyday? --> Drop down
  final FocusNode myFocusNodeNmbrOfRepeatTimes = FocusNode(); //Dropdown

  String dailyTaskName;
  double screenHeight, screenWidth;
  String repeat = 'Only this day'; //only this day or everyday?
  String selectedTimesToRepeat =
      "One time per day"; //number of times to reapeat the reminder
  List<String> litems = ["1", "2", "Third", "4"];
  final format = DateFormat("HH:mm");
  final now = DateTime.now();
  int ontimeday = 1;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Add a daily task to accomplish',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: prefix0.Colors.white,
          elevation: 0,
        ),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: _addHabbitForm(context),
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
                        ? 300.0
                        : selectedTimesToRepeat == 2 ? 360 : 420,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              focusNode: myFocusNodeTitle,
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
                                  labelText: 'Daily task title'),
                              validator: (val) =>
                                  val.isEmpty ? 'Title can\'t be empty' : null,
                              onChanged: (value) {
                                dailyTaskName = value.trim();
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
                                child: DropdownButtonFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == 2) repeat = "Everyday";
                                      if (val == 1) repeat = "Only this day";
                                    });
                                  },
                                  hint: Text('Repeat'),
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      labelText: 'Repeat',
                                      icon: Icon(
                                        Icons.replay,
                                        color: Color(0x552B2Baa),
                                        size: 18.0,
                                      ),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  value: 1,
                                  items: [
                                    DropdownMenuItem<int>(
                                      value: 1,
                                      child: Text(
                                        "Only this day",
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 2,
                                      child: Text(
                                        "Everyday",
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
                                      selectedTimesToRepeat =
                                          "Two times per day";

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
                                        format: format,
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
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(
                      bottom: 10,
                      top: selectedTimesToRepeat == 1
                          ? 280.0
                          : selectedTimesToRepeat == 2 ? 340 : 400),
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
                          if (repeat == "Everyday") {
                            for (var i = 0; i < 15; i++) {
                              await Firestore.instance
                                  .collection('UserData')
                                  .document(user.uid)
                                  .collection('events')
                                  .document(dailyTaskName + " Day $i")
                                  .setData({
                                "title": dailyTaskName + " Day $i",
                                "repeat": repeat,
                                "timeInDay": selectedTimesToRepeat,
                                "event_date": DateTime(
                                    now.year, now.month, now.day + i, now.hour),
                                "dones": "false"
                              });
                            }
                          } else {
                            widget.note == true
                                ? await Firestore.instance
                                    .collection('UserData')
                                    .document(user.uid)
                                    .collection('events')
                                    .document(dailyTaskName)
                                    .setData({
                                    "title": dailyTaskName,
                                    "repeat": repeat,
                                    "timeInDay": selectedTimesToRepeat,
                                    "event_date": DateTime.now(),
                                    "dones": "false"
                                  })
                                : await Firestore.instance
                                    .collection('UserData')
                                    .document(user.uid)
                                    .collection('events')
                                    .document(widget.name)
                                    .setData({
                                    "title": dailyTaskName,
                                    "repeat": repeat,
                                    "timeInDay": selectedTimesToRepeat,
                                    "event_date": DateTime.now(),
                                    "dones": "false"
                                  });
                          }

                          Navigator.pop(context);
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
