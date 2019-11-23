import 'package:flutter/material.dart';

class SenatorList extends StatelessWidget {
  final Map sen;
  final List senatorByState;
  final Function onTap;

  SenatorList({this.sen, this.senatorByState, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...senatorByState
            .map(
              (item) => ListTile(
                onTap: () => onTap(item),
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(0, 135, 81, 1),
                  child: Text(
                    item['name'].toString().split(" ")[1].substring(0, 1),
                  ),
                ),
                title: Text(item['name']),
                subtitle: Text(item['email']),
                trailing: Text(sen['state']),
              ),
            )
            .toList(),
      ],
    );
  }
}
