import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_design/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:messenger_design/modules/done_tasks/done_tasks_screen.dart';
import 'package:messenger_design/modules/new_tasks/new_tasks_screen.dart';
import 'package:messenger_design/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

static AppCubit get (context)=>BlocProvider.of(context);
  int currentindex =0;
  List <Widget>Screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String>titls=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex (int index)
  {
    currentindex=index;
    emit(AppChangeBottomNavBarState());
  }
  Database? database;
  List<Map> newTaskes =[];
  List<Map> doneTaskes =[];
  List<Map> archivedTaskes =[];

  void creatDatabase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version)
      {
        print('database created');
        database.execute('CREATE TABLE taskes(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value){
          print('table created');
        }
        ).catchError((error)
        {
          print('error on database created ${error.toString()}');
        })
        ;
      },
      onOpen: (database){
         getDataFromDatabase(database);

               print('database opended');
      },
    ).then((value) 
     {
      database= value;
      emit(AppCreateDatabaseState());
     });
  }
   inserttoDatabase({
    required String title,
    required String time,
    required String date,

  }) async
  {
    await database!.transaction((txn)
    {
      txn.rawInsert(
          'INSERT INTO taskes(title,date,time,status)VALUES("$title","$date","$time","new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('error on insert to database  ${error.toString()}');
      });
      throw('there is null');


    });
  }
  void getDataFromDatabase(database)
  {
    newTaskes=[];
    doneTaskes=[];
    archivedTaskes=[];
    emit(AppGetDatabaseLoadingState());
     database!.rawQuery('SELECT * FROM taskes').then((value) {


       value.forEach((element) {
        if (element['status']=='new')
          newTaskes.add(element);
        else if(element['status']=='done')
          doneTaskes.add(element);
        else{
          archivedTaskes.add(element);
        }
       });

       emit(AppGetDatabaseState());
     });

  }

 void updateData({
  required String status,
  required int id
})async
  {
    database!.rawUpdate(
        'UPDATE taskes SET status = ? WHERE id = ?',
        ['$status', id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id
  })async
  {
    database!.rawDelete(
        'DELETE FROM taskes WHERE id = ?', [id],

    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isbuttonsheetshow =false;
  IconData fabicon =Icons.edit;

  void changeBottomSheetState({required bool isshow,required IconData icon})
  {
    isbuttonsheetshow=isshow;
    fabicon=icon;
    emit(AppChangeBottomSheetState());
  }

}