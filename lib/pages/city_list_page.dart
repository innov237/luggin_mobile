import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';

class CityListPage extends StatefulWidget {
  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  List serverData;
  List filterData;
  String apiUrl = AppEvironement.apiUrl;

  getAllCity() async {
    Dio dio = Dio();
    var response = await dio.get(apiUrl + "getCity");
    if (response.statusCode == 200) {
      setState(
        () => {
          serverData = response.data,
          filterData = response.data,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCity();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: Color(0xFF2488B9),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          height: 35.0,
                          color: Color(0xFFF2F5F5),
                          child: TextField(
                            style: TextStyle(fontSize: 15.0),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 15.0, top: 2.0, bottom: 5.0),
                              border: InputBorder.none,
                              hintText: 'Search',
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onChanged: (string) {
                              setState(
                                () {
                                  filterData = serverData
                                      .where((item) => (item['name']
                                          .toLowerCase()
                                          .contains(string.toLowerCase())))
                                      .toList();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: filterData != null
                    ? ListView.builder(
                        itemCount: filterData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF2F5F5).withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.pop(
                                context,
                                filterData[index],
                              ),
                              child: Center(
                                child: Text(
                                  filterData[index]['name'],
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Container(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
