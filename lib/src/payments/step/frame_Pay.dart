import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FramePay extends StatefulWidget {
  const FramePay({Key? key}) : super(key: key);

  @override
  State<FramePay> createState() => _FramePayState();
}

class _FramePayState extends State<FramePay> {
  int _currentStep = 0;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> _steps = [
      Step(
        title: Text('Step 1'),
        content: Text('This is the content of Step 1'),
        isActive: true,
      ),
      Step(
        title: Text('Step 2'),
        content: Text('This is the content of Step 2'),
        isActive: true,
      ),
      Step(
        title: Text('Step 3'),
        content: Text('This is the content of Step 3'),
        isActive: true,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Sample App'),
      ),
      body: Center(
          child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        height: MediaQuery.of(context).size.height / 1.5,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              if (_currentStep < _steps.length - 1) {
                _currentStep++;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              }
            });
          },
          steps: _steps,
        ),
      )),
    );
  }
}



//  child: Stepper(
//             currentStep: _currentStep,
//             controller: _controller,
//             connectorThickness: 7,
//             stepIconHeight: 34.0,
//             stepIconWidth: 34.0,
//             stepIconMargin: const EdgeInsets.all(10),
//             margin: const EdgeInsets.all(10),

//             type: StepperType.vertical,
//             physics: AlwaysScrollableScrollPhysics(),
//             elevation: 0.1, // Adjust duration here

//             onStepCancel: () {
//               setState(() {
//                 _currentStep > 0 ? _currentStep -= 1 : null;
//               });
//             },
//             onStepContinue: () {
//               setState(() {
//                 _currentStep < 2 ? _currentStep += 1 : null;
//               });
//             },
//             steps: <Step>[
//               Step(
//                 stepStyle: StepStyle(indexStyle: TextStyle()),
//                 label: const Text('XO 1'),
//                 isActive: true,
//                 state:
//                     _currentStep >= 0 ? StepState.complete : StepState.disabled,
//                 title: const Text(''),
//                 content: Container(
//                   height: 100,
//                   width: 100,
//                   color: Colors.red,
//                 ),
//               ),
//               Step(
//                 isActive: _currentStep >= 1,
//                 state:
//                     _currentStep >= 1 ? StepState.complete : StepState.disabled,
//                 title: const Text('Step 2'),
//                 content: const Text('This is the second step.'),
//               ),
//               Step(
//                 isActive: _currentStep >= 2,
//                 title: const Text('Step 3'),
//                 content: const Text('This is the third step.'),
//               ),
//             ],
//           ),
       