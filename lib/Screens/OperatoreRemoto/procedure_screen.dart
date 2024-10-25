import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
//import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ProcedureScreen extends StatefulWidget {
  const ProcedureScreen({Key? key}) : super(key: key);
  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles(); 
  }

  Future<void> _loadFiles() async {
    final procedureDir = Directory('lib/Documents/Procedure');

    print('Percorso directory Procedure: ${procedureDir.path}');

    if (await procedureDir.exists()) {
      print('La directory esiste, caricamento dei file...');
      final fileList = procedureDir.listSync();
      setState(() {
        files = fileList.map((file) {
          final fileStat = file.statSync();
          return {
            'date': fileStat.modified.toLocal().toString().split(' ')[0],
            'name': file.uri.pathSegments.last,
            'type': file.uri.pathSegments.last.split('.').last.toUpperCase(), 
            'size': '${(fileStat.size / 1024).toStringAsFixed(2)} KB',
            'path': file.path
          };
        }).toList();
      });
      if (files.isEmpty) {
        print('Nessun file trovato nella directory Procedure.');
      }
    } else {
      print('La directory Procedure non esiste. Assicurati che i file siano nella directory corretta.');
    }
  }

  void _openFile(String path) async {
    final result = await OpenFile.open(path);
    print('Result: ${result.message}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedure'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: files.isEmpty
            ? Center(child: Text('Nessun file disponibile'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 7,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Nome: ${file['name']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Data: ${file['date']}'),
                              Text('Tipo: ${file['type']}'),
                              Text('Dimensione: ${file['size']}'),
                            ],
                          ),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => _openFile(file['path']),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.orange,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProcedureScreen(),
  ));
}
