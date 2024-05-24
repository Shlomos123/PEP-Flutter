import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pep_growth/models/associationRule.dart';
import 'package:pep_growth/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool loading = true;
  List<AssociationRule> associationRules = [];
  late DateTime startTime;
  late DateTime endTime;

  //String _value = "1";

  @override
  void initState() {
    super.initState();

    startTime = DateTime.now();
    fetchAssociationRules();
  }

  // _loadValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() async {
  //     _value = (await prefs.getString('value') ?? "1");
  //   });
  // }

  Future<void> fetchAssociationRules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the value as a string
    String valueString = prefs.getString('value') ?? "1";

    // Convert the string value to an integer
    int _value = int.tryParse(valueString) ?? 1;

    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8000?value=$_value')); // "http://10.0.2.2:8000"; "http://localhost:8000"; adb reverse tcp:8000 tcp:8000; "http://127.0.0.1:8000";
    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(response.body)['association_rules'];

      endTime = DateTime.now();

      setState(() {
        associationRules = jsonList
            .map((json) => AssociationRule.fromJson(jsonDecode(json)))
            .toList();
        loading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('חוקי ההקשר'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    //setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/');
                    //});
                  },
                ),
              ],
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
                  child: Column(
                    children: [
                      DataTable(
                        columnSpacing: 9,
                        columns: [
                          DataColumn(
                            label: Text(
                              "הקודם",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "התוצאה",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "ביטחון",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: associationRules
                            .map(
                              (rule) => DataRow(
                                cells: [
                                  DataCell(Text(rule.antecedent.toString())),
                                  DataCell(Text(rule.consequent.toString())),
                                  DataCell(Text(rule.confidence.toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'זמן ביצוע: ${(endTime.difference(startTime).inMilliseconds / 1000).toStringAsFixed(2)} שניות',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
