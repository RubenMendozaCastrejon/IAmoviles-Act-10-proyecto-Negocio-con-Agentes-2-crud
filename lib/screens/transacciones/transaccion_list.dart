import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaccion_provider.dart';
import '../../models/transaccion_model.dart';
import 'transaccion_create.dart';
import 'transaccion_edit.dart';

class TransaccionListScreen extends StatefulWidget {
  const TransaccionListScreen({super.key});

  @override
  State<TransaccionListScreen> createState() => _TransaccionListScreenState();
}

class _TransaccionListScreenState extends State<TransaccionListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TransaccionProvider>().fetchTransacciones());
  }

  void _confirmarEliminar(BuildContext context, TransaccionModel t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: Text('¿Deseas eliminar "${t.concepto}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TransaccionProvider>().deleteTransaccion(t.id!);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransaccionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.transacciones.isEmpty
              ? const Center(child: Text('No hay transacciones registradas.'))
              : ListView.builder(
                  itemCount: provider.transacciones.length,
                  itemBuilder: (context, index) {
                    final t = provider.transacciones[index];
                    final esIngreso = t.tipo == 'ingreso';
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          esIngreso
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: esIngreso ? Colors.green : Colors.red,
                        ),
                        title: Text(t.concepto,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${t.fecha} — \$${t.monto.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TransaccionEditScreen(transaccion: t),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _confirmarEliminar(context, t),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const TransaccionCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}