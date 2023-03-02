import 'package:ems_mobile/pages/detailed_view.dart';
import 'package:ems_mobile/pages/request_new.dart';
import 'package:flutter/material.dart';

class Viewreq extends StatefulWidget {
  const Viewreq({super.key});

  @override
  State<Viewreq> createState() => _ViewreqState();
}

class _ViewreqState extends State<Viewreq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 105, 147, 1),
          title: Text("Request View")),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [reqList()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 105, 147, 1),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const requestservice()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget reqList() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 15),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 8,
                color: Color.fromRGBO(0, 105, 147, 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DetailedView()));
                  },
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 13, bottom: 13, left: 10, right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      "Request ID: 1",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 3,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Employee",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          "Change E-mail to employee1@gmail.com ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ]),
                    )
                  ]),
                ));
          }),
    ));
  }
}
