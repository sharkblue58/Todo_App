
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger_design/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:messenger_design/modules/done_tasks/done_tasks_screen.dart';
import 'package:messenger_design/modules/new_tasks/new_tasks_screen.dart';
import 'package:messenger_design/shared/components/constants.dart';
import 'package:messenger_design/shared/cubit/cubit.dart';
import 'package:messenger_design/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatelessWidget
{


  var scaffoldkey =GlobalKey<ScaffoldState>();
  var formkey =GlobalKey<FormState>();

  var  titlecontroller=TextEditingController();
  var  timecontroller=TextEditingController();
  var   datecontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: ( context, state){
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: ( context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                   AppCubit.get(context).titls[cubit.currentindex]
              ),
            ),
            body:ConditionalBuilder(
            condition: state is! AppGetDatabaseLoadingState,
    builder: (context) =>cubit.Screens[cubit.currentindex],
    fallback: (context) =>Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton:FloatingActionButton(
              onPressed: () {
                if (cubit.isbuttonsheetshow) {
                  if (formkey.currentState!.validate()) {
                    cubit.inserttoDatabase(title: titlecontroller.text, time: titlecontroller.text, date: datecontroller.text);

                  }
                  else {
                    scaffoldkey.currentState!.showBottomSheet((context) =>
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  onTap: () {
                                    print('title tapped');
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: titlecontroller,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Task Title',
                                    prefixIcon: Icon(Icons.title,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                TextFormField(

                                  keyboardType: TextInputType.datetime,
                                  controller: timecontroller,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timecontroller.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  }
                                  ,
                                  decoration: InputDecoration(
                                    labelText: 'Task Time',
                                    prefixIcon: Icon(Icons.watch,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: datecontroller,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2021-12-12'),
                                    ).then((value) {
                                      datecontroller.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'Task Date',
                                    prefixIcon: Icon(Icons.calendar_today,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      elevation: 15.0,
                    ).closed.then((value) {
                      cubit.changeBottomSheetState(isshow: false, icon: Icons
                          .edit);
                    });
                    cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                  }
                }},
                child:
                Icon(
                  cubit.fabicon,
                ),
              ),
            bottomNavigationBar:BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex:cubit.currentindex ,
              onTap: (index){

                 cubit.changeIndex(index);


              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),label:'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),label:'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),label:'Archived'
                )
              ],
            ),
          );
        },
      ),
    );
  }

}


