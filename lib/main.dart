import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Future<Album> fetchAlbum() async {
//   final response = await http.get(Uri.parse(
//       'https://dev-eza.api.ffw.io/v6/EZSearch/Get?q=&facets=&pageIndex=0&pageSize=10&sessionGUID=99d053e9-fa0a-4e8f-8f2a-e3ec4499a29c&format=json2&userHTTPStatusCodes=False'));
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
Future<Album> fetchAlbum() async {
  Response response;
  BaseOptions options = BaseOptions(
    baseUrl: "https://dev-eza.api.ffw.io",
    connectTimeout: 6000,
    receiveTimeout: 3000,
  );
  Dio dio = Dio(options);
  FormData formData = FormData.fromMap({
    "email": 'admin',
    "password": 'CHAOSpbvu7000',
    "sessionGUID": '38b919a9-6be6-4918-9c9e-d9a0e77ef31c',
    "format": 'json2',
    "userHTTPStatusCodes": 'False',
  });
  response = await dio.post("/v6/EmailPassword/Login", data: formData);
  if (response.statusCode == 200) {
    print('succes'); //eturn Album.fromJson(jsonDecode(response.data));
    return Album.fromJson(jsonDecode(response.toString()));
  } else {
    //return response;
    print('Error:');
  }
  throw '';
}

class Album {
  final String userId;
  // final String id;
  final String title;
  Album({
    required this.userId,
    // required this.id,
    required this.title,
  });
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['Body']['Results'][0]['Guid'],
      //id: json['id'],
      title: json['Body']['Results'][0]['Guid'],
    );
  }
}





void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
                //return Image.network(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
