import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:registration_form_1/models/form_data.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();

    fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register page"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchPage,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['email']),
                  subtitle: Text(item['fristname']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      EditPage(item);
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return const [
                      PopupMenuItem(child: Text("Edit"), value: 'edit'),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: 'delete',
                      )
                    ];
                  }),
                );
              }),
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(onPressed: AddPage, label: Text("Add")),
    );
  }

  Future<void> EditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => FormData(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchPage();
  }

  Future<void> AddPage() async {
    final route = MaterialPageRoute(builder: (context) => FormData(

    ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchPage();
  }

  Future<void> deleteById(String id) async {
    final url =
        'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/delete/2';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage('Deletion Failed');
    }
  }
  Future<void> fetchPage() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/fetch'));
    request.body = json.encode({"token": "N6&Sy{4;Hq`uQxr_"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      final json = jsonDecode(response.stream as String) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.yellow),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
