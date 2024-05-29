import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pep_growth/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result2 extends StatefulWidget {
  @override
  _Result2State createState() => _Result2State();
}

class _Result2State extends State<Result2> {
  bool loading = true;
  List<FrequentItemset> frequentItemsets = [];
  late DateTime startTime;
  late DateTime endTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    endTime = DateTime.now(); // Initialize endTime here
    fetchFrequentItemsets();
  }

  Future<void> fetchFrequentItemsets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String valueString = prefs.getString('value') ?? "1";
    String supportString = prefs.getString('support') ?? "0.5";
    int _value = int.tryParse(valueString) ?? 1;
    double _support = double.tryParse(supportString) ?? 0.5;

    try {
      final response = await http.get(Uri.parse(
          'https://pep-fastapi.onrender.com/apriori?value=$_value&support=$_support'));

      // final response = await http
      //   .get(Uri.parse('http://10.0.2.2:8000?value=$_value&support=$_support'));

      if (response.statusCode == 200) {
        final List<dynamic> frequentItemsetsJson =
            json.decode(response.body)['frequent_itemsets'];

        endTime = DateTime.now();

        setState(() {
          frequentItemsets = frequentItemsetsJson
              .map((json) => FrequentItemset.fromJson(json))
              .toList();
          loading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('תבניות שכיחות'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/');
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
                              "פריטים",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "תדירות",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "תמיכה",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: frequentItemsets
                            .map((itemset) => DataRow(
                                  cells: [
                                    DataCell(Text(itemset.items.join(', '))),
                                    DataCell(Text(itemset.freq.toString())),
                                    DataCell(Text(
                                        itemset.support.toStringAsFixed(2))),
                                  ],
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'זמן ביצוע: ${(endTime.difference(startTime).inMilliseconds / 1000).toStringAsFixed(2)} שניות',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class FrequentItemset {
  final List<String> items;
  final double freq;
  final double support;

  FrequentItemset({
    required this.items,
    required this.freq,
    required this.support,
  });

  factory FrequentItemset.fromJson(Map<String, dynamic> json) {
    return FrequentItemset(
      items: List<String>.from(json['itemsets'].map((item) => item as String)),
      freq: json['freq'].toDouble(),
      support: json['support'].toDouble(),
    );
  }
}
