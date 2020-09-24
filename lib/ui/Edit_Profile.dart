import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/shared/loading.dart';
import 'package:prefecthabittracer/shared/profileUpload.dart';
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
        Container(
          child: Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Image.network(data["profilePic"], fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  }),
                ),
              ).px16().py8().py24(),
              Positioned(
                  bottom: 30,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => UploadProfile()));
                    },
                    child: 'edit'
                        .text
                        .white
                        .make()
                        .box
                        .black
                        .roundedLg
                        .padding(
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10))
                        .make(),
                  ))
            ],
          ),
        ),
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
