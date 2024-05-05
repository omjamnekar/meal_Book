import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Sample App'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 2,
          child: Stepper(
            currentStep: _currentStep,
            controller: _controller,
            connectorThickness: 20,
            stepIconHeight: 34.0,
            stepIconWidth: 34.0,
            stepIconMargin: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),

            type: StepperType.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            elevation: 0.1, // Adjust duration here
            onStepCancel: () {
              setState(() {
                _currentStep > 0 ? _currentStep -= 1 : null;
              });
            },
            onStepContinue: () {
              setState(() {
                _currentStep < 2 ? _currentStep += 1 : null;
              });
            },
            steps: <Step>[
              Step(
                label: const Text('XO 1'),
                isActive: true,
                stepStyle: StepStyle(
                  connectorColor: Colors.red,
                ),
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
                title: const Text(''),
                content: const Text('This is the first step.'),
              ),
              Step(
                isActive: _currentStep >= 1,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
                title: const Text('Step 2'),
                content: const Text('This is the second step.'),
              ),
              Step(
                isActive: _currentStep >= 2,
                title: const Text('Step 3'),
                content: const Text('This is the third step.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
