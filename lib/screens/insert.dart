import 'package:flutter/material.dart';
import 'package:pep_growth/models/file.dart';
import 'package:pep_growth/shared/constants.dart';
import 'package:pep_growth/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Insert extends StatefulWidget {
  @override
  _InsertState createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text field state

  String error = "";

  String errorFile = "";

  List<File> files = [
    File(name: "בחר קובץ נתונים", value: "0"),
    File(name: "fruits.json", value: "1"),
    File(name: "vegetables.json", value: "2"),
  ];
  String currentFile = "0";

  @override
  void dispose() {
    // TODO: Dispose a RewardedAd object

    super.dispose();
  }

  @override
  void initState() {
    setState(() {});
    //_loadSettings();

    super.initState();
  }

  //Loading counter value on start
  // _loadSettings() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentLanguage = (prefs.getString('language') ?? "1");
  //     // myEmailController.text = email;
  //     // password = (prefs.getString('password') ?? "");
  //     // myPasswordController.text = password;
  //     // if (email != "" && password != "")
  //     //     _rememberMe = true;
  //   });
  // }

  confirm() async {
    if (_formKey.currentState!.validate() && (currentFile != "0")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('value', currentFile);
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/result');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Result(),
      //     // Pass the arguments as part of the RouteSettings. The
      //     // DetailScreen reads the arguments from these settings.
      //     settings: RouteSettings(
      //       arguments: currentFile,
      //     ),
      //   ),
      // );
    } else {
      if (currentFile == "0") {
        setState(() {
          errorFile = "שום קובץ נתונים לא נבחר";
        });
      } else {
        setState(() {
          errorFile = "";
        });
      }

      setState(() {
        error = "שום קובץ נתונים לא נבחר";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text("הכנס פרטים"),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // DropdownButton<String>(
                          //   items: genders.map((String g) {
                          //     return DropdownMenuItem<String>(
                          //       value: g,
                          //       child: Text(g),
                          //     );
                          //   }).toList(),
                          //   onChanged: (val) {

                          //   },
                          // ),

                          SizedBox(
                            height: 10.0,
                          ),
                          DropdownButtonFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "בחר קובץ נתונים",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.line_weight,
                                  color: Colors.grey,
                                ), // icon is 48px widget.
                              ),
                            ),
                            value: currentFile,
                            validator: (val) =>
                                val == 0 ? "בחר קובץ נתונים" : null,
                            items: files.map((g) {
                              return DropdownMenuItem(
                                value: g.value,
                                child: Text('${g.name}'),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => currentFile = val!),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            errorFile,
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                confirm();
                              },
                              child: Text(
                                "אישור",
                                style: TextStyle(
                                  color: Color(0xFF527DAA),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),

                          // RaisedButton(
                          //   color: Colors.pink[400],
                          //   child: Text(
                          //     'Register',
                          //     style: TextStyle(color: Colors.white)
                          //   ),
                          //   onPressed: () async {
                          //     if (_formKey.currentState.validate()) {//if true valid form
                          //       setState(() => loading = true );
                          //       dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          //       if (result == null) {
                          //           setState(() {
                          //             error = 'please supply a valid email';
                          //             loading = false;
                          //           });
                          //       }
                          //     }
                          //   }
                          // ),

                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                          SizedBox(
                              height: 400.0,
                              width: (MediaQuery.of(context).size.width)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
