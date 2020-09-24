import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/style/theme.dart' as Theme;
import 'package:prefecthabittracer/ui/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _question1 = '';
String _question2 = '';
String _question3 = '';
String _question4 = '';
String _question5 = '';
String _q1 =
    'What is your most important goal that you want to achieve after 90 days?';
String _q2 = 'How should you go to this goal?';
String _q3 = 'Why do you want to achieve this goal?';
String _q4 = 'What will this feature save you?';
String _q5 = 'What difficulties can you face when trying to achieve this goal?';

class AddChallenge extends StatefulWidget {
  @override
  _AddChallengeState createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double screenHeight, screenWidth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Create a 90 days Challenge',
            style: prefix0.TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: prefix0.Colors.transparent,
          elevation: 0,
        ),
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildStepper(user.uid),
              )
            ],
          ),
        ));
  }

  int currentStep = 0;
  CupertinoStepper _buildStepper(String uid) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 4;
    return CupertinoStepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepTapped: (step) => setState(() => currentStep = step),
        onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
        onStepContinue: canContinue
            ? () {
                setState(() {
                  ++currentStep;
                });
              }
            : () {
                setState(() {
                  _submitDetails(uid);
                });
              },
        steps: steps);
  }

  List<Step> steps = [
    Step(
      title: Row(
        children: <Widget>[
          Text(
            'Question 1',
            overflow: TextOverflow.fade,
            softWrap: true,
            maxLines: 2,
          ),
        ],
      ),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          Text(
            _q1,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: TextFormField(
              maxLines: 6,
              cursorColor: Theme.Colors.loginGradientStart,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              validator: (val) => val.isEmpty ? 'Can\'t be empty' : null,
              onChanged: (String value) {
                _question1 = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your answer',
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: false,
      title: const Text('Question 2'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _q2,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: TextFormField(
              maxLines: 6,
              cursorColor: Theme.Colors.loginGradientStart,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              validator: (val) => val.isEmpty ? 'Can\'t be empty' : null,
              onChanged: (val) {
                _question2 = val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your answer',
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: false,
      //state: StepState.indexed,
      title: const Text('Question 3'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _q3,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: TextFormField(
              maxLines: 6,
              cursorColor: Theme.Colors.loginGradientStart,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              validator: (val) => val.isEmpty ? 'Can\'t be empty' : null,
              onChanged: (val) {
                _question3 = val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your answer',
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: false,
      // state: StepState.indexed,
      title: const Text('Question 4'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _q4,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: TextFormField(
              maxLines: 6,
              cursorColor: Theme.Colors.loginGradientStart,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              validator: (val) => val.isEmpty ? 'Can\'t be empty' : null,
              onChanged: (val) {
                _question4 = val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your answer',
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: false,
      //  state: StepState.indexed,
      title: const Text('Question 5'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _q5,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: TextFormField(
              maxLines: 6,
              cursorColor: Theme.Colors.loginGradientStart,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              validator: (val) => val.isEmpty ? 'Can\'t be empty' : null,
              onChanged: (val) {
                _question5 = val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your answer',
              ),
            ),
          )
        ],
      ),
    ),
  ];
  saveData(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("_key_name", value);
    return true;
  }

  _submitDetails(String uid) async {
    final FormState formState = _formKey.currentState;
    if (formState.validate()) {
      await Firestore.instance
          .collection('UserData')
          .document(uid)
          .collection('90 Day Challenge')
          .document('Challenge')
          .setData({
        'Date': DateTime.now(),
        _q1: _question1,
        _q2: _question2,
        _q3: _question3,
        _q4: _question4,
        _q5: _question5
      });
      await saveData(true);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx) => Wrapper()), (route) => false);
    } else {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Alert"),
            content: new SingleChildScrollView(
              child: new Text("Please answer all Questions"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }
  }
}
