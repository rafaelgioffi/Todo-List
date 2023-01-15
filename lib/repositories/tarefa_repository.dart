import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarefas.dart';

const chaveTarefas = 'tarefas_list';

class TarefaRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> LerTarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(chaveTarefas) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();
  }

  void SalvarTarefas(List<Tarefa> tarefas) {
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString(chaveTarefas, jsonString);
  }
}
