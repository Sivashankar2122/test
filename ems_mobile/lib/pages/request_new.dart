import 'package:flutter/material.dart';

class requestservice extends StatefulWidget {
  const requestservice({super.key});

  @override
  State<requestservice> createState() => _requestserviceState();
}

class _requestserviceState extends State<requestservice> {
  String? valuechoose;
  List listItem = [
    "Change Email",
    "Change Mobile Number",
    "Change Pan Number",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Request',
          style: TextStyle(
            fontFamily: 'Signika',
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromRGBO(204, 225, 233, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          'FILL THE DETAILS',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1.0,
                            color: Color.fromRGBO(0, 105, 147, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "THIRUGNANASKANDHAN S",
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 1.0,
                                color: Color.fromRGBO(0, 105, 147, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "ID",
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "G17006",
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 1.0,
                                color: Color.fromRGBO(0, 105, 147, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: DropdownButton(
                        underline: Container(
                            decoration: BoxDecoration(color: Colors.white)),
                        hint: const Text(
                          "REQUEST SUBJECT",
                          style: TextStyle(
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                        isExpanded: true,
                        dropdownColor: const Color.fromRGBO(0, 105, 147, 1),
                        value: valuechoose,
                        onChanged: (newValue) {
                          setState(() {
                            valuechoose = newValue.toString();
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.20),
                              offset: Offset(0, 0),
                              blurRadius: 20.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'CHANGE TO',
                            hintStyle: TextStyle(
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.20),
                              offset: Offset(0, 0),
                              blurRadius: 20.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'REASON',
                            hintStyle: TextStyle(
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (() => {}),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(0, 105, 147, 1),
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
