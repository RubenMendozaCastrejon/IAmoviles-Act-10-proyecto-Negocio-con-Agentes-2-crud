import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activo_provider.dart';
import '../../models/activo_model.dart';
import 'activo_create.dart';
import 'activo_edit.dart';

class ActivoListScreen extends StatefulWidget {
  const ActivoListScreen({super.key});

  @override
  State<ActivoListScreen> createState() => _ActivoListScreenState();
}

class _ActivoListScreenState extends State<ActivoListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar activos al abrir la pantalla
    Future.microtask(
        () => context.read<ActivoProvider>().fetchActivos());
  }

  void _confirmarEliminar(BuildContext context, ActivoModel activo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar activo'),
        content: Text('¿Deseas eliminar "${activo.nombre}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ActivoProvider>().deleteActivo(activo.id!);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.activos.isEmpty
              ? const Center(child: Text('No hay activos registrados.'))
              : ListView.builder(
                  itemCount: provider.activos.length,
                  itemBuilder: (context, index) {
                    final activo = provider.activos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.account_balance_wallet,
                            color: Colors.indigo),
                        title: Text(activo.nombre,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${activo.tipo} — \$${activo.valor.toStringAsFixed(2)}'),
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
                                        ActivoEditScreen(activo: activo),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _confirmarEliminar(context, activo),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivoCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}