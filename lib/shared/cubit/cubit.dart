import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';


import '../../modules/archive_tasks/archive_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];
  int currentIndex = 0;
  late Database database;

  List<Widget> screen = [
    const NewTasks(),
    const DoneTasks(),
    const ArchiveTasks()
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppCurrentIndex());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];


  void createDataBase() {
    openDatabase("todo.db", version: 1,
      onCreate: (database, version) {
        debugPrint("dataBase Created");
        database.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT , status TEXT  )"
        ).then((value) {
          debugPrint("table Created");
        }).catchError((error) {
          debugPrint("error when creating ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        debugPrint("database Open");
      },

    ).then((value) {
      database = value;
      emit(AppCreatedDataBase());

    }


    );
  }


  void getDataFromDataBase(database) {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];

    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        }

        else {
          archiveTasks.add(element);
        }
      }
      emit(AppGetDataBase());

    });

  }

  void insertDataBase({
    required String title,
    required String time,
    required String date,
  })
  async{
    await  database.transaction((txn){
      return txn.rawInsert('INSERT INTO tasks (title, time, date, status) VALUES ("$title","$time","$date","new")').then((value){
        debugPrint("$value insert done");
        emit(AppInsertDataBase());


        getDataFromDataBase(database);
      }).catchError((error)
      {
        debugPrint("Error when Insert new record ${error.toString()}");
      });
    });
  }



  void updateData({
    required int id,
    required String status

  }){
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status,id]).then((value){
      getDataFromDataBase(database);
      emit(AppUpdateDataBase());
    });


  }



  void deleteData({required int id}) {

    database.rawDelete("DELETE FROM tasks WHERE id = ?", [id]).then((value){
      getDataFromDataBase(database);
      emit(AppDeleteDataBase());
    });

  }

  bool isBottomSheet = false;


  void changeBottomSheetState ({required bool isShow}){

    isBottomSheet = isShow;
    emit(AppChangeBottom());
  }




}

