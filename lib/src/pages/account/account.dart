import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class AccountManager extends ConsumerStatefulWidget {
  const AccountManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountManagerState();
}

class _AccountManagerState extends ConsumerState<AccountManager>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  right: _visible ? -30 : -200,
                  top: _visible ? -30 : -200,
                  curve: Curves.easeInOut,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -10 * _animation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -10 * _animation.value),
                      child: child,
                    );
                  },
                  child: AnimatedPositioned(
                    duration: Duration(seconds: 2),
                    right: _visible ? -30 : -150,
                    top: _visible ? -30 : -150,
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color.fromARGB(255, 230, 230, 230),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Account Manager'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
