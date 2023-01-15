import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/tarefas.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.tarefa,
    required this.onDelete,
  }) : super(key: key);

  final Tarefa tarefa;
  final Function(Tarefa) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 0.20,
        secondaryActions: [
          IconSlideAction(
              color: Colors.red,
              icon: Icons.delete,
              caption: 'Excluir',
              onTap: () {
                onDelete(tarefa);
              }),
        ],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.today,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm - EE').format(tarefa.date),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    tarefa.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
