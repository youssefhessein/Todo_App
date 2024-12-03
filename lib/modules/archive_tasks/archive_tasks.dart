import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppState>(builder: (context, state) {
      var tasks = AppCubit.get(context).archiveTasks;

      return TaskItem(
        tasks: tasks,
      );



    });
  }
}
