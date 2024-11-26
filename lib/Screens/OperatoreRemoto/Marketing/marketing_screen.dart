import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
//import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';   flutter_pdfview: ^1.2.5
//import 'package:path_provider/path_provider.dart';
//import 'package:url_launcher/url_launcher.dart';

class MarketingFilesScreen extends StatefulWidget {
  const MarketingFilesScreen({Key? key}) : super(key: key);

  @override
  _MarketingFilesScreenState createState() => _MarketingFilesScreenState();
}

class _MarketingFilesScreenState extends State<MarketingFilesScreen> {
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final marketingDir = Directory('lib/Documents/Marketing');

    print('Percorso directory Marketing: ${marketingDir.path}');

    if (await marketingDir.exists()) {
      print('La directory esiste, caricamento dei file...');
      final fileList = marketingDir.listSync();
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
        print('Nessun file trovato nella directory Marketing.');
      }
    } else {
      print('La directory Marketing non esiste. Assicurati che i file siano nella directory corretta.');
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
        title: const Text('File Marketing'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage()
                )
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: files.isNotEmpty
            ? GridView.builder(
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
              )
            : const Center(child: Text('Nessun file disponibile.')),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MarketingFilesScreen(),
  ));
}