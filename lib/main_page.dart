import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_diary/add_page.dart';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Directory? directory;
  String filePath = '';
  dynamic myList = const Text('준비');

  @override
  void initState() {
    // TODO: implement initStat
    getPath().then((value) {
      showList();
    });
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory();
    if (directory != null) {
      var fileName = 'diray.json';
      filePath = '${directory!.path}/$fileName';
      print(filePath);
    }
  }

  Future<void> deleteFile() async {
    try {
      var file = File(filePath);
      var result = file.delete().then((value) {
        print(value);
        showList();
      });
      print(result.toString());
    } catch (e) {
      print('delete error');
    }
  }

  Future<void> deleteContents(int index) async {
    var file = File(filePath);
    var fileContents = await file.readAsString();
    var dataList = jsonDecode(fileContents) as List<dynamic>;
    dataList.removeAt(index);

    var jsonData = jsonEncode(dataList);
    await file.writeAsString(jsonData).then((value) => showList());
  }

  Future<void> showList() async {
    try {
      var file = File(filePath);
      if (file.existsSync()) {
        setState(() {
          myList = FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var d = snapshot.data;
                var dataList = jsonDecode(d!) as List<dynamic>;

                if (dataList.isEmpty) {
                  return const Text("파일은 존재하지만 입력된 데이터가 없다");
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = dataList[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['contents']),
                      trailing: IconButton(
                          onPressed: () {
                            deleteContents(index);
                          },
                          icon: const Icon(Icons.delete)),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: dataList.length,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
            future: file.readAsString(),
          );
        });
      } else {
        setState(() {
          myList = const Text('파일이 없습니다');
        });
      }
    } catch (e) {
      print('오류');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  showList();
                },
                child: const Text('조회'),
              ),
              ElevatedButton(
                  onPressed: () {
                    deleteFile();
                  },
                  child: const Text('삭제'))
            ],
          ),
          Expanded(child: myList),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(filePath: filePath),
            ),
          );
          if (result == 'ok') {
            showList();
          }
        },
        child: const Icon(Icons.apple),
      ),
    );
  }
}
