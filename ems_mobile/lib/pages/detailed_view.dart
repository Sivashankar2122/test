import 'package:flutter/material.dart';

class DetailedView extends StatefulWidget {
  const DetailedView({super.key});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 105, 147, 1),
        title: Text("Detailed view"),
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 500,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 105, 147, 1),
                    boxShadow: [],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Name:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text("Employee",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ]),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "E-mail:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text("Employee@gmail.com",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ]),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Request",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text("Change Email to employee1@gmail.com",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ]),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              
                              width: 100,
                              height: 50,
                              decoration:const BoxDecoration(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Text(
                                  "Cancel",
                                  style:
                                      TextStyle(fontSize: 19, color: Colors.red),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
