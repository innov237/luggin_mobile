import 'package:flutter/material.dart';

class TransferHistoryPage extends StatefulWidget {
  @override
  _TransferHistoryPageState createState() => _TransferHistoryPageState();
}

class _TransferHistoryPageState extends State<TransferHistoryPage> {
  List transferData = [
    {
      'id': 1,
      'date': '12/avril/2020',
      'annee': '2020',
      'data': [
        {'moi': 'Avril', 'montant': '33.0€'},
        {'moi': 'Mars', 'montant': '15.0€'},
        {'moi': 'Février', 'montant': '5.0€'},
        {'moi': 'Janvier', 'montant': '10.3€'}
      ]
    },
    {
      'id': 1,
      'date': '12/avril/2020',
      'annee': '2019',
      'data': [
        {'moi': 'Avril', 'montant': '20.0€'},
        {'moi': 'Mars', 'montant': '00.0€'},
        {'moi': 'Février', 'montant': '5.0€'},
        {'moi': 'Janvier', 'montant': '8.3€'}
      ]
    },
    {
      'id': 1,
      'date': '12/avril/2018',
      'annee': '2018',
      'data': [
        {'moi': 'Avril', 'montant': '20.0€'},
        {'moi': 'Mars', 'montant': '15.0€'},
        {'moi': 'Février', 'montant': '5.0€'},
        {'moi': 'Janvier', 'montant': '12.3€'}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Historique"),
        ),
        body: ListView.builder(
          itemCount: transferData.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transferData[index]['annee'],
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transferData[index]['data'].length,
                      itemBuilder: (BuildContext ctxt, int index2) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transferData[index]['data'][index2]['moi'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          transferData[index]['data'][index2]
                                              ['montant'],
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12.0,
                                          color: Colors.black.withOpacity(
                                            0.5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
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
