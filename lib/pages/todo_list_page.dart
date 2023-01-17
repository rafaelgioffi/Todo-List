import 'package:flutter/material.dart';
import 'package:todo_list/models/tarefas.dart';
import 'package:todo_list/repositories/tarefa_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tarefasController = TextEditingController();
  final TarefaRepository tarefaRepository = TarefaRepository();

  List<Tarefa> tarefas = [];
  Tarefa? deletedTarefa;
  int? posDelTarefa;
  String? errorMsg;

  @override
  void initState() {
    super.initState();

    tarefaRepository.LerTarefas().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tarefasController,
                        decoration: InputDecoration(
                          labelText: 'Crie uma tarefa',
                          labelStyle: const TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                          hintText: 'Informe a tarefa a ser adicionada',
                          errorText: errorMsg,
                          // prefixText: 'R\$ ',
                          // suffixText: 'cm',
                          border: OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = tarefasController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorMsg = 'A tarefa não pode ser vazia';
                          });
                          return;
                        }
                        String prim = text.substring(0, 1);
                        text = prim.toUpperCase() + text.substring(1);
                        Tarefa novaTarefa =
                            Tarefa(title: text, date: DateTime.now());
                        setState(() {
                          tarefas.add(novaTarefa);
                          errorMsg = null;
                        });
                        tarefasController.clear();
                        tarefaRepository.SalvarTarefas(tarefas);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    shrinkWrap: true,
                    children: [
                      for (Tarefa tarefa in tarefas)
                        TodoListItem(
                          tarefa: tarefa,
                          onDelete: onDelete,
                        ),
                      // title: Text(tarefa),
                      // subtitle: Text('10/01/2023'),
                      // leading: Icon(
                      //   Icons.calendar_month,
                      //   size: 24,
                      // ),
                      // onTap: () {
                      //   print('tocou "$tarefa"');
                      // },
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Você possui ${tarefas.length} tarefas pendentes',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: ConfLimpaTudo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14),
                        ),
                        child: const Text('Limpar tudo'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Tarefa tarefa) {
    deletedTarefa = tarefa;
    posDelTarefa = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });
    tarefaRepository.SalvarTarefas(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[200],
        duration: Duration(seconds: 20),
        content: Text(
          'Tarefa "${tarefa.title}" removida.',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 74, 74),
          ),
          textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: 'desfazer',
          textColor: Color.fromARGB(255, 255, 74, 74),
          onPressed: () {
            setState(() {
              tarefas.insert(posDelTarefa!, deletedTarefa!);
            });
            tarefaRepository.SalvarTarefas(tarefas);
          },
        ),
      ),
    );
  }

  void ConfLimpaTudo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar todas as tarefas?'),
        content: const Text(
          'Você tem certeza que deseja apagar todas as tarefas?\nEssa ação é irreversível!',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  LimparTudo();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  'Limpar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void LimparTudo() {
    setState(() {
      tarefas.clear();
    });
    tarefaRepository.SalvarTarefas(tarefas);
  }
}
