import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/bloc_observer.dart';
import 'package:todo/shared/cubit/cubit.dart';


import 'modules/layout/layout.dart';

void main() {

  Bloc.observer = SimpleObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDataBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo tasks',
        home: Layout(),
      ),
    );
  }
}