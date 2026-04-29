import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaccion_model.dart';
import '../../providers/transaccion_provider.dart';

class TransaccionCreateScreen extends StatefulWidget {
  const TransaccionCreateScreen({super.key});

  @override
  State<TransaccionCreateScreen> createState() =>
      _TransaccionCreateScreenState();
}

class _TransaccionCreateScreenState extends State<TransaccionCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
  String _tipoSeleccionado = 'ingreso';

  @override
  void dispose() {
    _conceptoController.dispose();
    _montoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nueva = TransaccionModel(
        concepto: _conceptoController.text.trim(),
        tipo: _tipoSeleccionado,
        monto: double.tryParse(_montoController.text.trim()) ?? 0,
        fecha: _fechaController.text.trim(),
      );

      await context.read<TransaccionProvider>().addTransaccion(nueva);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transacción guardada correctamente')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TransaccionProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Transacción'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _conceptoController,
                  decoration: const InputDecoration(
                    labelText: 'Concepto',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // Tipo: Ingreso / Egreso
                DropdownButtonFormField<String>(
                  value: _tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon: Icon(Icons.swap_horiz),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                    DropdownMenuItem(value: 'egreso', child: Text('Egreso')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _tipoSeleccionado = val ?? 'ingreso';
                    });
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _montoController,
                  decoration: const InputDecoration(
                    labelText: 'Monto (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha (Ej. 2026-04-29)',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Guardar Transacción'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isLoading ? null : _guardar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}