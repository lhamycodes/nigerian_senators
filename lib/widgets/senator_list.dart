import 'package:flutter/material.dart';

import '../models/senator.dart';
import '../models/state.dart';

class SenatorList extends StatelessWidget {
  final NigState sen;
  final List<Senator> senatorByState;
  final Function onTap;

  const SenatorList({
    Key? key,
    required this.sen,
    required this.senatorByState,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...senatorByState.map(
          (item) => ListTile(
            onTap: () => onTap(item),
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(0, 135, 81, 1),
              child: Text(
                item.name.toString().split(" ")[1].substring(0, 1),
              ),
            ),
            title: Text(item.name ?? "No name"),
            subtitle: Text(item.email ?? "No email address"),
            trailing: Text(sen.state ?? "No state"),
          ),
        ),
      ],
    );
  }
}
