// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiScreen1 extends StatefulWidget {
  const ApiScreen1({super.key});

  @override
  State<ApiScreen1> createState() => _ApiScreen1State();
}

class _ApiScreen1State extends State<ApiScreen1> {
  Future fetchData() async {
    print("Fetching data");
    final response = await http.get(Uri.parse(
        'https://datausa.io/api/data?drilldowns=Nation&measures=Population'));
    if (response.statusCode == 200) {
      print("surver result: " "${response.statusCode}");
      // If the server returns a 200 OK response, parse the JSON
      // final api1 = Api1(
      //     data: json.decode(response.body)['data'],
      //     source: jsonDecode(response.body)['source']);
      print('Api result: ${json.decode(response.body)}');
      // print(api1.data);
      return json.decode(response.body);
    } else {
      print("failed to load data");
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 212, 233),
      appBar: AppBar(
        title: const Text(
          "Api Data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 173, 212, 233),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          // initialData: const CircularProgressIndicator(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // final api1 = Api1(
              //   data: snapshot.data['data'],
              //   source: snapshot.data['source'],
              // );
              // Display the fetched data
              return ListView.separated(
                itemCount: snapshot.data['data'].length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Id Nation: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    '${snapshot.data["data"][index]['Nation ID']}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Nation: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    '${snapshot.data["data"][index]['Nation']}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Year: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${snapshot.data["data"][index]['Year']}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Population: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    '${snapshot.data["data"][index]['Population']}',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Slug Nation: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    '${snapshot.data["data"][index]['Slug Nation']}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
