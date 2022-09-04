
import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

import '../models/scan_model.dart';

class ScanListProvider extends ChangeNotifier {

  List<ScanModel> scans = [];
  String tipoSeleccionado = 'geo';

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = ScanModel(valor: valor);
    final id = await DbProvider.db.nuevoScan(nuevoScan);

    nuevoScan.id = id;

    if (tipoSeleccionado == nuevoScan.tipo){
      scans.add(nuevoScan);
      notifyListeners();
    }

    return nuevoScan;

  }

  cargarScans() async {
    final dbscans = await DbProvider.db.getTodosScans();
    scans = [...dbscans];
    notifyListeners();
  }

  cargarScanPorTipo(String tipo) async {
    final dbscans = await DbProvider.db.getScansPorTipo(tipo);
    scans = [...dbscans];
    tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async {
    await DbProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    await DbProvider.db.deleteScan(id);
    cargarScanPorTipo(tipoSeleccionado);
  }

}