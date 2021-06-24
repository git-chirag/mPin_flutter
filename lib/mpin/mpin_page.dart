import 'package:flutter/material.dart';
import 'package:mpin_flutter/mpin/mpin_widget.dart';

class MpinPage extends StatefulWidget {
  const MpinPage({Key? key}) : super(key: key);

  @override
  _MpinPageState createState() => _MpinPageState();
}

class _MpinPageState extends State<MpinPage> {
  MpinController mpinController = MpinController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: (MpinWidget(
                  onCompleted: (mPin) {
                    print('You entered : $mPin');
                    if (mPin == '12345') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text('Go to next Step'),
                            );
                          });
                    } else {
                      mpinController.notifyWrongInput();
                    }
                  },
                  pinLength: 5,
                  controller: mpinController,
                )),
              ),
              SizedBox(
                height: 24,
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                childAspectRatio: 1.6,
                children:
                    List.generate(9, (index) => buildMaterialButton(index + 1)),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                childAspectRatio: 1.6,
                children: [
                  MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text('#', style: TextStyle(fontSize: 22)),
                  ),
                  buildMaterialButton(0),
                  MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {
                      mpinController.delete();
                    },
                    child: Icon(Icons.backspace_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton(int input) {
    return MaterialButton(
      onPressed: () {
        mpinController.addInput('$input');
      },
      textColor: Colors.white,
      child: Text(
        '$input',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
