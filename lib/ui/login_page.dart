import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prefecthabittracer/services/Authf.dart';
import 'package:prefecthabittracer/shared/loading.dart';
import 'package:prefecthabittracer/style/theme.dart' as Theme;
import 'package:prefecthabittracer/ui/wrapper.dart';
import 'package:prefecthabittracer/utils/bubble_indication_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

String name;

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signinformKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  PageController _pageController;

  bool changeCardSize = false;
  bool changeSigninCardSize = false;
  double screenWidth;
  double screenHeight;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              child: Container(
                width: screenWidth,
                height: screenHeight >= 600.0
                    ? MediaQuery.of(context).size.height
                    : 600.0,
                decoration: new BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.12,
                            bottom: screenHeight * 0.08),
                        child: Image.asset(
                          'assets/landlogo.png',
                          width: 280,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  String signinemail, signinPass;
  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 3.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  width: screenWidth - 0.1 * screenWidth,
                  height: changeSigninCardSize ? 230.0 : 170,
                  child: Form(
                    key: _signinformKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            cursorColor: Theme.Colors.loginGradientStart,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) {
                              signinemail = val;
                            },
                            validator: ((value) => value.isEmpty
                                ? "Email is required"
                                : validateEmail(value.trim())),
                            style: TextStyle(
                                // fontFamily: "WorkSansSemiBold",
                                fontSize: 18.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Email',
                              icon: Icon(
                                FontAwesomeIcons.solidEnvelope,
                                color: Color(0x552B2Baa),
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            cursorColor: Theme.Colors.loginGradientStart,
                            obscureText: _obscureTextLogin,
                            onChanged: (val) {
                              signinPass = val;
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Password can\'t be empty' : null,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 18.0,
                                color: Color(0x552B2Baa),
                              ),
                              labelText: 'Password',
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin:
                    EdgeInsets.only(top: changeSigninCardSize ? 210.0 : 150),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 60.0),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          //fontFamily: "WorkSansBold"
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_signinformKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                          changeSigninCardSize = false;
                        });
                        var result = await AuthService()
                            .login(email: signinemail, password: signinPass);
                        setState(() {
                          loading = false;
                        });
                        if (result is String) {
                          showInSnackBar(result);
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctn) => Wrapper()));
                        }
                      }
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black54,
                    fontSize: 16.0,
                    //fontFamily: "WorkSansMedium"
                  ),
                )),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0), child: orSeparator()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, right: 40.0),
                child: GestureDetector(
                  onTap: () {
                    //TODO
                  },
                  child: GestureDetector(
                    onTap: () => showInSnackBar("Facebook login not available"),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: new Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Google login not available"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String signupemail, signupPass;
  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Stack(
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
                  height: changeCardSize ? 350.0 : 270,
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            autofocus: true,
                            cursorColor: Theme.Colors.loginGradientStart,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (val) {
                              name = val;
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Name can\'t be empty' : null,
                            style: TextStyle(
                                //fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Color(0x552B2Baa),
                                  size: 18.0,
                                ),
                                labelText: 'Name'),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            cursorColor: Theme.Colors.loginGradientStart,
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            onChanged: (val) {
                              signupemail = val;
                            },
                            validator: ((value) => value.isEmpty
                                ? "Email is required"
                                : validateEmail(value.trim())),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.solidEnvelope,
                                  size: 18,
                                  color: Color(0x552B2Baa),
                                ),
                                labelText: 'Email'),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            cursorColor: Theme.Colors.loginGradientStart,
                            obscureText: _obscureTextSignup,
                            controller: signupPasswordController,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            onChanged: (val) {
                              signupPass = val;
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Password can\'t be empty' : null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 18,
                                color: Color(0x552B2Baa),
                              ),
                              labelText: 'Password',
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            cursorColor: Theme.Colors.loginGradientStart,
                            controller: signupConfirmPasswordController,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            validator: (val) => val.isEmpty
                                ? 'Confirm password field can\'t be empty'
                                : null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 18,
                                color: Color(0x552B2Baa),
                              ),
                              labelText: 'Confirm Password',
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
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
                margin: EdgeInsets.only(top: changeCardSize ? 335 : 255.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 2.0),
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
                          vertical: 0.0, horizontal: 42.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        var result = await AuthService()
                            .singup(email: signupemail, password: signupPass);
                        await saveData(false);

                        setState(() {
                          loading = false;
                        });
                        if (result is String) {
                          showInSnackBar(result);
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: orSeparator(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Facebook button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: GestureDetector(
                  onTap: () {
                    showInSnackBar("Google button pressed");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String validateEmail(String value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);
    if (!regExp.hasMatch(value))
      return 'Example@mail.com';
    else
      return null;
  }

  void _onSignInButtonPress() {
    setState(() {
      changeSigninCardSize = false;
    });
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() async {
//    setState(() {
//      changeCardSize = false;
//    });
    await _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Widget orSeparator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.black12,
                  Colors.black,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          width: 100.0,
          height: 1.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Text(
            "Or",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
              //fontFamily: "WorkSansMedium"
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black12,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          width: 100.0,
          height: 1.0,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 4),
    ));
  }

  saveData(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("_key_name", value);
    return true;
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      // width: screenWidth - 0.15*screenWidth,
      width: screenWidth >= 320.0 ? 300 : screenWidth - 0.15 * screenWidth,

      height: 50,
      decoration: BoxDecoration(
        color: Color(0x552B2Baa),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            prefix0.Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.white,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),

            //Container(height: 33.0, width: 1.0, color: Colors.red),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                    //fontFamily: "WorkSansSemiBold"
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  bool _isLoading = false;
  Widget circularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container();
  }

  String _errorMessage;
  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
