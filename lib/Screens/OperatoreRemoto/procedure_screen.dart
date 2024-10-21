import 'package:flutter/material.dart';

class ProcedureScreen extends StatefulWidget {
  const ProcedureScreen({Key? key}) : super(key: key);

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  final List<Map<String, dynamic>> files = [
    {
      'date': '08/10/2024',
      'name': 'file1.pdf',
      'type': 'PDF',
      'size': '2 MB',
      'path': 'path/to/file1.pdf'
    },
    {
      'date': '07/10/2024',
      'name': 'file2.docx',
      'type': 'Word',
      'size': '1.5 MB',
      'path': 'path/to/file2.docx'
    },
    {
      'date': '06/10/2024',
      'name': 'file3.xlsx',
      'type': 'Excel',
      'size': '3 MB',
      'path': 'path/to/file3.xlsx'
    },
  ];

  void _openFile(String path) {
    print('Apri file: $path');
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
        child: GridView.builder(
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
