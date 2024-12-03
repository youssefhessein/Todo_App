import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';


class TaskItem extends StatelessWidget {
  final List<Map> tasks;

  const TaskItem({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isNotEmpty) {
      return Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          child: Text(
                            tasks[index]['time'],
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasks[index]['title'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(tasks[index]['date'],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ]),
                      ),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                                id: tasks[index]['id'], status: "done");
                          },
                          icon: const Icon(
                            Icons.check_box,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                                id: tasks[index]['id'], status: "archive");
                          },
                          icon: const Icon(
                            Icons.archive,
                          )),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context)
                                .deleteData(id: tasks[index]['id']);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
            itemCount: tasks.length),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.edit,
              size: 100,
              color: Colors.grey,
            ),
            Text('No Tasks PLease add some Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      );
    }
  }
}
