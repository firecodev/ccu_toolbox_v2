import 'package:flutter/material.dart';
import 'bounce_button.dart';

class ChooseMenuButton extends StatelessWidget {
  ChooseMenuButton({
    Key key,
    this.buttonText = '',
    this.menuTitle = '',
    this.width,
    this.items = const [],
    this.onChosen,
  });

  final String buttonText;
  final String menuTitle;
  final double width;
  final List<Widget> items;
  final void Function(int index) onChosen;

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                      child: Text(
                        menuTitle,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (_, index) => BounceButton(
                        onTap: () {
                          Navigator.pop(context);
                          if (onChosen != null) onChosen(index);
                        },
                        child: items[index],
                      ),
                      separatorBuilder: (_, __) => Divider(
                        height: 1.0,
                        thickness: 1.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).scaffoldBackgroundColor,
          border:
              Border.all(color: Theme.of(context).textTheme.subtitle1.color),
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1.5, 1.5),
                blurRadius: 1.0,
                color: Color.fromRGBO(0, 0, 0, 0.25))
          ],
        ),
        child: Padding(
          padding: width == null
              ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
              : const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF9E9E9E),
            ),
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
