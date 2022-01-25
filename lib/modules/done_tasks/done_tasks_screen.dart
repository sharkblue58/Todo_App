import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_design/shared/components/components.dart';
import 'package:messenger_design/shared/cubit/cubit.dart';
import 'package:messenger_design/shared/cubit/states.dart';

class DoneTasksScreen extends  StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      listener:(context,state){} ,
      builder: (context,state){
        var taskes = AppCubit.get(context).doneTaskes;
        return tasksBuilder(taskes: taskes);
      },
    );
  }
}
