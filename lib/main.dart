import 'package:flutter/material.dart';
import 'package:pep_growth/screens/insert.dart';
import 'package:pep_growth/screens/result.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Insert(),
          '/result': (context) => Result(),
        }));
