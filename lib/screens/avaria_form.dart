import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/avaria.dart';
import '../helpers/database_helper.dart';

class AvariaFormScreen extends StatefulWidget {
  final Avaria? avaria;
  const AvariaFormScreen({super.key, this.avaria});

  @override
  State<AvariaFormScreen> createState() => _AvariaFormScreenState();
}

class _AvariaFormScreenState extends State<AvariaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _utilidade;
  late String _descricao;
  late int _valorAvaria;

  @override
  void initState() {
    super.initState();
    _utilidade = widget.avaria?.utilidade ?? '';
    _descricao = widget.avaria?.descricao ?? '';
    _valorAvaria = widget.avaria?.valorAvaria ?? 0;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final newAvaria = Avaria(
        id: widget.avaria?.id,
        dataAvaria: formattedDate,
        utilidade: _utilidade,
        descricao: _descricao,
        valorAvaria: _valorAvaria,
      );

      if (widget.avaria == null) {
        await DatabaseHelper().insertAvaria(newAvaria);
      } else {
        await DatabaseHelper().updateAvaria(newAvaria);
      }

      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.avaria == null ? 'Nova Avaria' : 'Editar Avaria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _utilidade,
                decoration: const InputDecoration(labelText: 'Utilidade'),
                onSaved: (value) => _utilidade = value!,
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _descricao = value!,
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _valorAvaria.toString(),
                decoration: const InputDecoration(labelText: 'Valor da Avaria'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _valorAvaria = int.parse(value!),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveForm, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
