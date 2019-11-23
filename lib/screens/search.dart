import 'package:flutter/material.dart';
import 'package:nigerian_senators/widgets/senator_list.dart';

class DataSearch extends SearchDelegate<String> {
  final List senators;
  final Function onTapSenator;

  DataSearch(this.senators, this.onTapSenator);
  String selectedState;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List suggestionList =
        senators.where((sen) => sen['state'] == selectedState).toList();

    return SenatorList(
      sen: suggestionList[0],
      senatorByState: suggestionList[0]['data'],
      onTap: onTapSenator,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? senators
        : senators
            .where(
              (sen) => sen['state']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase(),),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => ListTile(
        onTap: () {
          selectedState = suggestionList[i]['state'];
          showResults(context);
        },
        title: Text(suggestionList[i]['state']),
      ),
    );
  }
}
