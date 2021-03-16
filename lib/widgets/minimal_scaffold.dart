import 'package:flutter/material.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class MinimalScaffold extends StatelessWidget {
  MinimalScaffold({Key key, this.title = '', this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20.0,
        toolbarHeight: 77.0,
        title: Text(
          title,
          overflow: TextOverflow.fade,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: _BackButton(),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(1.5, 4),
                  blurRadius: 2.0,
                  color: Color.fromRGBO(0, 0, 0, 0.25))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back,
            size: 25.0,
          ),
        ),
      ),
    );
  }
}
