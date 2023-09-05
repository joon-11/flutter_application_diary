import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  String filePath;
  AddPage({super.key, required this.filePath});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String filePath = '';

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    filePath = widget.filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filePath),
        centerTitle: true,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: controllers[0],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('title'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: TextFormField(
                  controller: controllers[1],
                  maxLength: 500,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("content"),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  var title = controllers[0].text;
                  print(title);
                  Navigator.pop(context, 'ok');
                },
                child: const Text("저장"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
