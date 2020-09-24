import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/shared/Imagepicker.dart';
import 'package:prefecthabittracer/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:prefecthabittracer/services/Database.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
            stream: userCollection.document(user.uid).snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              return !snapshot.hasData
                  ? Container(child: Center(child: Loading()))
                  : SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            screens(context, data),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 35),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    children: [
                                      FormClass(
                                        title: 'Weight',
                                        hint: data['Weight'],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      ),
                                      10.heightBox,
                                      FormClass(
                                        title: 'Age',
                                        hint: data['Age'].toString(),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      ),
                                      10.heightBox,
                                      FormClass(
                                        title: 'Height',
                                        hint: data['Height'],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      ),
                                      10.heightBox,
                                      FormClass(
                                        title: 'Gender',
                                        hint: data['Gender'],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      ),
                                      10.heightBox,
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]),
                    );
            }),
      ),
    );
  }

  Container screens(BuildContext context, var data) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(40.0),
              bottomRight: const Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent])),
      height: context.screenHeight * 0.4,
      width: context.screenWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        40.heightBox,
        Center(
          child: GestureDetector(
            onTap: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => ImagePickers()));
            },
            child: Container(
              height: 90,
              width: 90,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.dstATop),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        data["profilePic"],
                      ))),
              child: Text('Edit').text.xl2.bold.gray800.makeCentered(),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: "${data['first name']} ${data['last name']}"
              .text
              .white
              .capitalize
              .bold
              .xl2
              .make()
              .px12(),
        ).py2(),
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text(data['name']).text.white.bold.xl.make().px12(),
        ).py2()
      ]),
    );
  }
}

class FormClass extends StatelessWidget {
  final String title, hint;
  const FormClass({this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: context.percentWidth * 30,
            child: title.text.gray700.xl.make()),
        Container(
          width: context.percentWidth * 40,
          child: TextFormField(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintText: hint,
            ),
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'Please enter something';
//                              }
//                              return null;
//                            },
//                            onChanged: (value) {
//                              firstname = value;
//                            },
          ),
        ),
      ],
    );
  }
}
