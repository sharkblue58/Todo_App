import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_design/shared/cubit/cubit.dart';

Widget defultbutton ({
   double width=double.infinity,
   Color background=Colors.blue,
  required Function function,
  required String text,
})=>Container(
  width:width,
  color:background,
  child: MaterialButton(
    onPressed:(){}
    ,
    child:Text(text.toUpperCase(),style:TextStyle(color:Colors.white),) ,

  ),
);


Widget buildTaskItems (Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child:Text(
  
              '${model['time']}'
  
          ) ,
  
        ),
  
        SizedBox(
  
          width:20.0 ,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment:CrossAxisAlignment.start,
  
            children: [
  
              Text('${model['title']}',
  
                style: TextStyle(
  
                    fontSize:16.0,
  
                    fontWeight:FontWeight.bold
  
                ),
  
              ),
  
              Text('${model['date']}',
  
                style: TextStyle(
  
                    color: Colors.grey
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(width:20.0,
  
        ),
  
        IconButton(
  
            onPressed:(){
  
              AppCubit.get(context).updateData(status: 'Done', id: model['id']);
  
            },
  
            icon:Icon(Icons.check_box),
  
            color: Colors.green,
  
        ),
  
        IconButton(
  
          onPressed:(){},
  
          icon:Icon(Icons.archive),
  
          color: Colors.black45,
  
        ),
  
  
  
  
  
  
  
  
  
  
  
      ],
  
  
  
    ),
  
  ),
  onDismissed: (direction){
     AppCubit.get(context).deleteData(id: model['id']);
  },
);


Widget tasksBuilder ({required List<Map> taskes})=>ConditionalBuilder(
    condition:taskes.length>0 ,
    builder: (BuildContext context)=>ListView.separated(
      itemBuilder: (context,index)=>buildTaskItems (taskes[index],context),
      separatorBuilder:(context,index)=>Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey[300],
      ),
      itemCount: taskes.length,

    ),
    fallback:(context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text('No Taskes yet',
            style:TextStyle(fontSize: 16.0,fontWeight:FontWeight.bold, color: Colors.grey,) ,

          ),
        ],
      ),
    )
);

Widget buildlogintextfield(
{
  required TextEditingController controller,
  required TextInputType type ,
  required String lable,
  required IconData prefix,
  required double circle,

}
    )=> TextFormField(

  keyboardType:type,
  controller: controller,
  validator: (value){

    if (value!.isEmpty)
    {
      return 'Field Must Not Be Empty';
    }
    return null;
  },
  decoration: InputDecoration(
    labelText: lable,
    prefixIcon:Icon(
      prefix,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(circle),
    ),

  ),
  onFieldSubmitted: (value){
    print(value);
  },
  onChanged:(value){
    print(value);
  },
);

