import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class Layout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return  BlocBuilder<AppCubit , AppState>(builder: (context , state){
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            cubit.title[cubit.currentIndex],
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [cubit.screen[cubit.currentIndex]],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(cubit.isBottomSheet)
            {
              if(formKey.currentState!.validate()){
                cubit.insertDataBase(title: titleController.text, time: timeController.text, date: dateController.text);

              }
            }
            else {
              scaffoldKey
                  .currentState!.showBottomSheet((context) => Container(
                height: 300,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return "Title must Not be Empty";
                          }
                          return null;
                        } ,
                        controller: titleController,

                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.title)),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return "time must Not be Empty";
                          }
                          return null;
                        } ,
                        controller: timeController,
                        onTap: (){
                          showTimePicker(context: context, initialTime: TimeOfDay.now())
                              .then((value){
                            timeController.text = value!.format(context).toString();
                          });
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.timelapse),
                        ),
                      ),
                      const SizedBox(height: 10,),

                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return "Date must Not be Empty";
                          }
                          return null;
                        } ,
                        onTap: (){

                          showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030)).then((value){

                            dateController.text = DateFormat.yMMMd().format(value!);
                          });
                        },
                        controller: dateController,

                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.date_range)),
                      ),
                    ],
                  ),
                ),
              ),



              ).closed.then((value){
                cubit.changeBottomSheetState(isShow: false);
              });
            }

            cubit.changeBottomSheetState(isShow: true);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle), label: "Done Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archive Tasks"),
            ]),
      );
    });
  }
}
