import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pep_growth/models/algorithm.dart';
import 'package:pep_growth/models/file.dart';
import 'package:pep_growth/shared/constants.dart';
import 'package:pep_growth/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Insert extends StatefulWidget {
  @override
  _InsertState createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = "";
  String errorFile = "";
  String errorAlgo = "";
  List<File> files = [
    File(name: "בחר קובץ נתונים", value: "0"),
    File(name: "fruits.json", value: "1"),
    File(name: "vegetables.json", value: "2"),
  ];

  List<Algo> algs = [
    Algo(name: "בחר אלגוריתם", value: "0"),
    Algo(name: "PFP Growth", value: "1"),
    Algo(name: "Apriori", value: "2"),
  ];
  String currentFile = "0";
  String chosenAlgo = "0";
  String support = "0.5";
  String n_jobs = "-1";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  confirm() async {
    if (_formKey.currentState!.validate() &&
        (currentFile != "0") &&
        (chosenAlgo != "0")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('value', currentFile);
      await prefs.setString('support', support);
      await prefs.setString('n_jobs', n_jobs);
      if (chosenAlgo == "1") {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/resultMlxtend');
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/result2');
      }
      //Navigator.of(context).pushNamed('/result');
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
      if (chosenAlgo == "0") {
        setState(() {
          errorAlgo = "שום אלגוריתם לא נבחר";
        });
      } else {
        setState(() {
          errorAlgo = "";
        });
      }

      setState(() {
        error = "תקן את השגיאות המודגשות";
        loading = false;
      });
    }
  }

  confirm2() async {
    if (_formKey.currentState!.validate() && (currentFile != "0")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('value', currentFile);
      await prefs.setString('support', support);
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/result2');
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
              title: Text("הכנס נתונים"),
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
                          SizedBox(
                            height: 10.0,
                          ),
                          DropdownButtonFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "בחר אלגוריתם",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.line_weight,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            value: currentFile,
                            validator: (val) =>
                                val == 0 ? "בחר אלגוריתם" : null,
                            items: algs.map((g) {
                              return DropdownMenuItem(
                                value: g.value,
                                child: Text('${g.name}'),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => chosenAlgo = val!),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            errorAlgo,
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          DropdownButtonFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "בחר אלגוריתם",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.line_weight,
                                  color: Colors.grey,
                                ),
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
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                              DecimalRangeTextInputFormatter(
                                  min: 0.0, max: 1.0),
                            ],
                            decoration: textInputDecoration.copyWith(
                              hintText: "הכנס minSupport",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.line_weight,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "לא הוכנס ערך";
                              } else {
                                double? value = double.tryParse(val);
                                if (value == null || value < 0 || value > 1) {
                                  return "הכנס ערך בין 0 ל-1";
                                }
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => support = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          (chosenAlgo == "1")
                              ? TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^-?\d*')), // ערכים שלמים כולל שליליים
                                  ],
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "כמות תהליכים שירוצו במקביל",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.line_weight,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  keyboardType:
                                      TextInputType.number, // ערכים שלמים בלבד
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "לא הוכנס ערך";
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    setState(() => n_jobs = val);
                                  },
                                )
                              : SizedBox(height: 0.0),
                          (chosenAlgo == "1")
                              ? SizedBox(height: 20.0)
                              : SizedBox(height: 0.0),
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
                          SizedBox(height: 0.0),
                          // Container(
                          //   padding: EdgeInsets.symmetric(vertical: 5.0),
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       elevation: 5.0,
                          //       padding: EdgeInsets.all(15.0),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(30.0),
                          //       ),
                          //       backgroundColor: Colors.white,
                          //     ),
                          //     onPressed: () {
                          //       confirm2();
                          //     },
                          //     child: Text(
                          //       "הרץ Apriori",
                          //       style: TextStyle(
                          //         color: Color(0xFF527DAA),
                          //         letterSpacing: 1.5,
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.bold,
                          //         fontFamily: 'OpenSans',
                          //       ),
                          //     ),
                          //   ),
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

class DecimalRangeTextInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  DecimalRangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? value = double.tryParse(newValue.text);
    if (value == null || value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}



























// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pep_growth/models/file.dart';
// import 'package:pep_growth/shared/constants.dart';
// import 'package:pep_growth/shared/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Insert extends StatefulWidget {
//   @override
//   _InsertState createState() => _InsertState();
// }

// class _InsertState extends State<Insert> {
//   final _formKey = GlobalKey<FormState>();
//   bool loading = false;
//   String error = "";
//   String errorFile = "";
//   List<File> files = [
//     File(name: "בחר קובץ נתונים", value: "0"),
//     File(name: "fruits.json", value: "1"),
//     File(name: "vegetables.json", value: "2"),
//   ];
//   String currentFile = "0";
//   String support = "0.5";

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   confirm() async {
//     if (_formKey.currentState!.validate() && (currentFile != "0")) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('value', currentFile);
//       await prefs.setString('support', support);
//       Navigator.of(context).pop();
//       Navigator.of(context).pushNamed('/resultMlxtend');
//       //Navigator.of(context).pushNamed('/result');
//     } else {
//       if (currentFile == "0") {
//         setState(() {
//           errorFile = "שום קובץ נתונים לא נבחר";
//         });
//       } else {
//         setState(() {
//           errorFile = "";
//         });
//       }

//       setState(() {
//         error = "שום קובץ נתונים לא נבחר";
//         loading = false;
//       });
//     }
//   }

//   confirm2() async {
//     if (_formKey.currentState!.validate() && (currentFile != "0")) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('value', currentFile);
//       await prefs.setString('support', support);
//       Navigator.of(context).pop();
//       Navigator.of(context).pushNamed('/result2');
//     } else {
//       if (currentFile == "0") {
//         setState(() {
//           errorFile = "שום קובץ נתונים לא נבחר";
//         });
//       } else {
//         setState(() {
//           errorFile = "";
//         });
//       }

//       setState(() {
//         error = "שום קובץ נתונים לא נבחר";
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? Loading()
//         : Scaffold(
//             resizeToAvoidBottomInset: false,
//             backgroundColor: Colors.blue[100],
//             appBar: AppBar(
//               backgroundColor: Colors.blue[400],
//               elevation: 0.0,
//               title: Text("הכנס נתונים"),
//             ),
//             body: Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/cover.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           DropdownButtonFormField(
//                             decoration: textInputDecoration.copyWith(
//                               hintText: "בחר קובץ נתונים",
//                               prefixIcon: Padding(
//                                 padding: EdgeInsets.all(0.0),
//                                 child: Icon(
//                                   Icons.line_weight,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             value: currentFile,
//                             validator: (val) =>
//                                 val == 0 ? "בחר קובץ נתונים" : null,
//                             items: files.map((g) {
//                               return DropdownMenuItem(
//                                 value: g.value,
//                                 child: Text('${g.name}'),
//                               );
//                             }).toList(),
//                             onChanged: (val) =>
//                                 setState(() => currentFile = val!),
//                           ),
//                           SizedBox(
//                             height: 2.0,
//                           ),
//                           Text(
//                             errorFile,
//                             style: TextStyle(color: Colors.red, fontSize: 12.0),
//                           ),
//                           SizedBox(height: 20.0),
//                           TextFormField(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                   RegExp(r'^\d*\.?\d*')),
//                               DecimalRangeTextInputFormatter(
//                                   min: 0.0, max: 1.0),
//                             ],
//                             decoration: textInputDecoration.copyWith(
//                               hintText: "הכנס minSupport",
//                               prefixIcon: Padding(
//                                 padding: EdgeInsets.all(0.0),
//                                 child: Icon(
//                                   Icons.line_weight,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             keyboardType:
//                                 TextInputType.numberWithOptions(decimal: true),
//                             validator: (val) {
//                               if (val == null || val.isEmpty) {
//                                 return "לא הוכנס ערך";
//                               } else {
//                                 double? value = double.tryParse(val);
//                                 if (value == null || value < 0 || value > 1) {
//                                   return "הכנס ערך בין 0 ל-1";
//                                 }
//                               }
//                               return null;
//                             },
//                             onChanged: (val) {
//                               setState(() => support = val);
//                             },
//                           ),
//                           SizedBox(height: 20.0),
//                           Container(
//                             padding: EdgeInsets.symmetric(vertical: 25.0),
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 5.0,
//                                 padding: EdgeInsets.all(15.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 backgroundColor: Colors.white,
//                               ),
//                               onPressed: () {
//                                 confirm();
//                               },
//                               child: Text(
//                                 "הרץ PFP-Growth",
//                                 style: TextStyle(
//                                   color: Color(0xFF527DAA),
//                                   letterSpacing: 1.5,
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'OpenSans',
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 0.0),
//                           Container(
//                             padding: EdgeInsets.symmetric(vertical: 5.0),
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 5.0,
//                                 padding: EdgeInsets.all(15.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 backgroundColor: Colors.white,
//                               ),
//                               onPressed: () {
//                                 confirm2();
//                               },
//                               child: Text(
//                                 "הרץ Apriori",
//                                 style: TextStyle(
//                                   color: Color(0xFF527DAA),
//                                   letterSpacing: 1.5,
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'OpenSans',
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             error,
//                             style: TextStyle(color: Colors.red, fontSize: 14.0),
//                           ),
//                           SizedBox(
//                               height: 400.0,
//                               width: (MediaQuery.of(context).size.width)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class DecimalRangeTextInputFormatter extends TextInputFormatter {
//   final double min;
//   final double max;

//   DecimalRangeTextInputFormatter({required this.min, required this.max});

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.isEmpty) {
//       return newValue;
//     }

//     final double? value = double.tryParse(newValue.text);
//     if (value == null || value < min || value > max) {
//       return oldValue;
//     }

//     return newValue;
//   }
// }
