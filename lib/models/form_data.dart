import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:registration_form_1/controllers/logger.dart';

class FormData extends StatefulWidget {
  final Map? todo;
  const FormData({
    super.key,
    this.todo,
  });
  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  // TextEditingController lastnameController = TextEditingController();
  // TextEditingController address1Controller = TextEditingController();
  // TextEditingController address2Controller = TextEditingController();
  // TextEditingController countryController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  // TextEditingController stateController = TextEditingController();
  // TextEditingController zipcodeController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController phonenumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final item = widget.todo;
    if (item != null) {
      isEdit = true;
      final email = item['email'];
      final firstname = item['firstname'];
      emailController.text = email;
      firstnameController.text = firstname;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Page' : "Register"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter email";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
            TextFormField(
              controller: firstnameController,
              decoration: const InputDecoration(
                hintText: "Firstname",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter firstname";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                icon: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                label: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_isLoading
                      ? 'Loading'
                      : isEdit
                          ? 'update'
                          : 'Submit'),
                ),
                onPressed: () async {
                  await isEdit ? updateData : submitData();
                  setState(() {
                    _isLoading ? null : _startLoading();

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  });
                })
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final item = widget.todo;
    if (item == null) {
      print('you can not call updated without todo data');
      return;
    }
    final id = item['_id'];
    final email = emailController.text;
    final firstname = firstnameController.text;

    final body = ({
      "email": "pravalika98@gmail.com",
      "first_name": "pravalika",
      "last_name": "lakshmi",
      "address1": "lucky",
      "address2": "lucky",
      "country": "India",
      "city": "Tirupathi",
      "state": "Andra pradesh",
      "zipcode": "5234558",
      "password": "123456",
      "phno": "9642936343",
      "token": "N6&Sy{4;Hq`uQxr_"
    });

    final url =
        'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/update/3';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      //print('Creation Success');
      showSuccessMessage('Updation Success');
    } else {
      // print('Creation Failed');
      showErrorMessage('Updation Failed');
      // print(response.body);
    }
  }

  Future<void> submitData() async {
    final email = emailController.text;
    final firstname = firstnameController.text;

    Future<void> submitData() async {
      final email = emailController.text;
      final firstname = firstnameController.text;
      final body = {
        "email": emailController.text,
        "firstname": firstnameController.text,
        "last_name": "moresu",
        "address1": "lucky",
        "address2": "lucky",
        "country": "India",
        "city": "Tirupathi",
        "state": "Andra pradesh",
        "zipcode": "522018",
        "password": "123456",
        "phno": "9683687393",
        "token": "N6&Sy{4;Hq`uQxr_"
      };
      final url =
          "http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/create";
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        // headers: {}
      );
      logger.d(response);
      logger.d("response data");
      logger.d(response.body.toString);
      if (response.statusCode == 201) {
        // emailController.text = '';
        // firstnameController.text = '';

        showSuccessMessage('Creation Success');
      } else {
        showErrorMessage('Creatrion Failed');
      }
    }

    // this is the hard  code
    /*var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/create'));
    request.body = json.encode({
      "email": "pravalika98@gmail.com",
      "first_name": "pravalika",
      "last_name": "lakshmi",
      "address1": "lucky",
      "address2": "lucky",
      "country": "India",
      "city": "Tirupathi",
      "state": "Andra pradesh",
      "zipcode": "5234558",
      "password": "123456",
      "phno": "9642936343",
      "token": "N6&Sy{4;Hq`uQxr_",
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      emailController.text = '';
      firstnameController.text = '';

      print(await response.stream.bytesToString());
      showSuccessMessage('Creation Success');
    } else {
      print(response.reasonPhrase);
    }*/
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
