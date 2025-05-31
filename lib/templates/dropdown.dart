import 'package:flutter/material.dart';
import 'dart:math';

// utilities
import '../utils/colors.dart';

class CustomDropdown extends StatefulWidget {
  final Widget child1;
  final List<Widget> child2;

  const CustomDropdown({super.key, required this.child1, required this.child2});

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> with TickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleExpansion,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.child1,
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * pi,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: 2.5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: widget.child2)
          ),
        )
      ],
    );
  }
}
