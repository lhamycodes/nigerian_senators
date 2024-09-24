import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/senator.dart';
import '../models/state.dart';
import '../widgets/senator_list.dart';
import 'search.dart';

class Index extends StatefulWidget {
  static const routeName = '/';

  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool _isInit = false;
  bool _isLoading = false;
  List<NigState> _states = [];

  String? _selectedSenate; // default year of the senate
  String get selectedSenate => _selectedSenate ?? senateData[0].keys.first;
  set selectedSenate(String value) {
    setState(() {
      _selectedSenate = value;
      _isLoading = true;
    });
    _loadStates();
  }

  List<Map<String, dynamic>> senateData = [
    {"10th": "10.json"},
    {"9th": "09.json"}
  ];

  final databaseReference = FirebaseFirestore.instance;

  _loadStates() async {
    String path = senateData
        .where((data) => data.containsKey(selectedSenate))
        .first[selectedSenate];
    _states = json
        .decode(await DefaultAssetBundle.of(context)
            .loadString("assets/data/$path"))
        .map<NigState>((item) => NigState.fromJson(item))
        .toList();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _launchIntent(String url, Senator senator, String action) async {
    Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      await databaseReference.collection('log_activity').add({
        'senator_name': senator.name ?? "Not Provided",
        'senator_email': senator.email ?? "Not Provided",
        'senator_phone': senator.phone ?? "Not Provided",
        'action': action,
      });
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void initState() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadStates();
    }
    _isInit = true;
    super.initState();
  }

  void onTapSenator(Senator senator) {
    showModalBottomSheet(
      context: (context),
      isScrollControlled: true,
      builder: (BuildContext ct) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Full name",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 135, 81, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  senator.name ?? "Not Provided",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Email Address",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 135, 81, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.email),
                  label: Text(
                    senator.email ?? "Not Provided",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    if (senator.email == null) {
                      return;
                    }

                    _launchIntent(
                      "mailto:${senator.email}",
                      senator,
                      'email',
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                // SizedBox(height: 10),
                const Text(
                  "Phone number",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 135, 81, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (senator.phone == null) ...[
                  const Text(
                    "Not Provided",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        senator.phone!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.call),
                            onPressed: () => _launchIntent(
                              "tel:${senator.phone}",
                              senator,
                              'call',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.sms),
                            onPressed: () => _launchIntent(
                              "sms:${senator.phone}",
                              senator,
                              'sms',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nigerian Senators", style: TextStyle(fontSize: 18)),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Select Senate',
            onSelected: (year) {
              if (year != selectedSenate) {
                selectedSenate = year;
              }
            },
            itemBuilder: (context) => senateData.map((data) {
              final year = data.keys.first;
              return PopupMenuItem<String>(
                value: year,
                child: Text('$year Senate'),
              );
            }).toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('$selectedSenate Senate'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(_states, onTapSenator),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, i) {
                NigState stateData = _states[i];
                List<Senator> senatorByState = stateData.data ?? [];
                return SenatorList(
                  sen: stateData,
                  senatorByState: senatorByState,
                  onTap: onTapSenator,
                );
              },
              itemCount: _states.length,
            ),
    );
  }
}
