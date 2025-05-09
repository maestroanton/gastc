import 'package:flutter/material.dart';
import '../models/avaria.dart';
import '../helpers/database_helper.dart';
import 'avaria_form.dart';

class AvariaListScreen extends StatefulWidget {
  const AvariaListScreen({super.key});

  @override
  State<AvariaListScreen> createState() => _AvariaListScreenState();
}

class _AvariaListScreenState extends State<AvariaListScreen> {
  List<Avaria> _avarias = [];
  List<Avaria> _filteredAvarias = [];

  String _searchQuery = '';
  String _sortBy = 'Data (recente primeiro)';

  final List<String> _sortOptions = [
    'Data (recente primeiro)',
    'Data (antigo primeiro)',
    'Valor (maior primeiro)',
    'Valor (menor primeiro)',
  ];

  @override
  void initState() {
    super.initState();
    _loadAvarias();
  }

  Future<void> _loadAvarias() async {
    final data = await DatabaseHelper().getAvarias();
    setState(() {
      _avarias = data;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Avaria> filtered =
        _avarias
            .where(
              (a) =>
                  a.descricao.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  a.utilidade.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();

    switch (_sortBy) {
      case 'Data (recente primeiro)':
        filtered.sort((a, b) => b.dataAvaria.compareTo(a.dataAvaria));
        break;
      case 'Data (antigo primeiro)':
        filtered.sort((a, b) => a.dataAvaria.compareTo(b.dataAvaria));
        break;
      case 'Valor (maior primeiro)':
        filtered.sort((a, b) => b.valorAvaria.compareTo(a.valorAvaria));
        break;
      case 'Valor (menor primeiro)':
        filtered.sort((a, b) => a.valorAvaria.compareTo(b.valorAvaria));
        break;
    }

    setState(() {
      _filteredAvarias = filtered;
    });
  }

  void _deleteAvaria(int id) async {
    await DatabaseHelper().deleteAvaria(id);
    _loadAvarias();
  }

  void _navigateToForm({Avaria? avaria}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AvariaFormScreen(avaria: avaria)),
    );
    _loadAvarias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Avarias'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por descrição ou utilidade...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  items:
                      _sortOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          _filteredAvarias.isEmpty
              ? const Center(child: Text('Nenhuma avaria encontrada.'))
              : ListView.builder(
                itemCount: _filteredAvarias.length,
                itemBuilder: (_, index) {
                  final a = _filteredAvarias[index];
                  return ListTile(
                    title: Text(a.descricao),
                    subtitle: Text(
                      'Utilidade: ${a.utilidade} | Valor: ${a.valorAvaria}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToForm(avaria: a),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteAvaria(a.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
