import 'package:flutter/material.dart';
import 'package:pep_growth/screens/insert.dart';
import 'package:pep_growth/screens/result.dart';
import 'package:pep_growth/screens/result2.dart';
import 'package:pep_growth/screens/resultMlxtend.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Insert(),
          '/result': (context) => Result(),
          '/resultMlxtend': (context) => ResultMlxtend(),
          '/result2': (context) => Result2(),
        }));
