// ignore_for_file: sized_box_for_whitespace, avoid_print, duplicate_ignore, file_names, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/page/stadium/Navigation.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:my_app/page/stadium/StadiumInfo.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchStadiums() async {
  String url = 'http://10.0.2.2:8000/stadium/view-all-stadium/';

  try {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Map<String, dynamic> body = {};

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    List<dynamic> extractedData = jsonDecode(response.body);

    // await Future.delayed(Duration(seconds: 10));
    if (response.statusCode == 200) {
      return {"isSuccessful": true, "data": extractedData, "error": null};
    } else {
      return {
        "isSuccessful": false,
        "data": extractedData,
        "error": "An error has occurred"
      };
    }
  } catch (error) {
    return {
      "isSuccessful": false,
      "data": [],
      "error": "Our web service is down."
    };
  }
}

class StadiumA {
  final String stadiumName;

  StadiumA({required this.stadiumName});

  static List<StadiumA> getSuggestions() {
    // return a list of Stadium objects
    return [
      StadiumA(stadiumName: "Suncorp Stadium"),
      StadiumA(stadiumName: "The Gabba"),
      StadiumA(stadiumName: "QUT Kelvin Groove"),
    ];
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchStadium createState() => SearchStadium();
}

class SearchStadium extends State<SearchPage> {
  List<dynamic> allStadiums = [];
  Map<String, dynamic> response = {};
  late AutoCompleteTextField<StadiumA> searchTextField;
  GlobalKey<AutoCompleteTextFieldState<StadiumA>> key = GlobalKey();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    searchTextField = AutoCompleteTextField<StadiumA>(
      key: key,
      clearOnSubmit: false,
      suggestions: StadiumA.getSuggestions(),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        hintText: "Search Stadium",
        hintStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: const Color(0xffD9D9D9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
      itemFilter: (item, query) {
        return item.stadiumName.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.stadiumName.compareTo(b.stadiumName);
      },
      itemSubmitted: (item) async {
        print("Selected item: '${item.stadiumName}'");
        setState(() {
          if (searchTextField.textField != null &&
              searchTextField.textField!.controller != null) {
            searchTextField.textField!.controller!.text = item.stadiumName;
          }
        });
        if (item.stadiumName == 'Suncorp Stadium') {
          await Future.delayed(const Duration(milliseconds: 100));
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Navigation()));
        }
      },
      itemBuilder: (context, item) {
        return row(item);
      },
    );
  }

  Future<void> _intializeData() async {
    response = await fetchStadiums();
    if (response["isSuccessful"]) {
      allStadiums = response["data"];
    }
  }

  Widget row(StadiumA item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          item.stadiumName,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFECECEC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Searching",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 60, // Set the height that you want
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child:
                            searchTextField, // Your AutoCompleteTextField widget
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Text(
                        'Recent Search',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FutureBuilder(
                          future: _intializeData(),
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < allStadiums.length; i++)
                                  Container(
                                    width: 500,
                                    height: 105,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(48),
                                            elevation: 0,
                                            backgroundColor:
                                                const Color(0xffD9D9D9),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            )),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StadiumInfo(allStadiums[i]
                                                          ['newsletter_id'])));
                                        },
                                        child: Row(
                                          // ignore: duplicate_ignore, duplicate_ignore
                                          children: [
                                            // ignore: sized_box_for_whitespace
                                            Container(
                                              width: 90.0,
                                              height: 90.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                child: Image.network(
                                                  'http://10.0.2.2:8000' +
                                                      jsonDecode(allStadiums[i]
                                                          ['stadium_picture']),
                                                  fit: BoxFit
                                                      .cover, // You can use different BoxFit property as per your requirement
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            Text(
                                              allStadiums[i]['stadium_name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          })
                    ],
                  )),
            )
          ]),
        ));
  }
}
