import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nigerian_senators/screens/search.dart';
import 'package:nigerian_senators/widgets/senator_list.dart';
import 'package:url_launcher/url_launcher.dart';

class Index extends StatefulWidget {
  static const routeName = '/';
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool _isInit = false;
  bool _isLoading = false;
  List _senators = [];

  _getSenators() async {
    _senators = json.decode(
      await DefaultAssetBundle.of(context).loadString("assets/senators.json"),
    );
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _launchIntent(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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
      _getSenators();
    }
    _isInit = true;
    super.initState();
  }

  void onTapSenator(Map _senatorData) {
    showModalBottomSheet(
      context: (context),
      isScrollControlled: true,
      builder: (BuildContext ct) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Full name",
                style: TextStyle(
                  color: Color.fromRGBO(0, 135, 81, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _senatorData['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Email Address",
                style: TextStyle(
                  color: Color.fromRGBO(0, 135, 81, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              FlatButton.icon(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.email),
                label: Text(
                  _senatorData['email'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () =>
                    _launchIntent("mailto:${_senatorData['email']}"),
              ),
              // SizedBox(height: 10),
              Text(
                "Phone number",
                style: TextStyle(
                  color: Color.fromRGBO(0, 135, 81, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _senatorData['phone'] == null
                  ? Text(
                      "Not Provided",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _senatorData['phone'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () =>
                                  _launchIntent("tel:${_senatorData['phone']}"),
                            ),
                            IconButton(
                              icon: Icon(Icons.sms),
                              onPressed: () =>
                                  _launchIntent("sms:${_senatorData['phone']}"),
                            ),
                          ],
                        )
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nigerian Senators"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(_senators, onTapSenator));
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              separatorBuilder: (ctx, i) => Divider(),
              itemBuilder: (ctx, i) {
                Map _sen = _senators[i];
                List _senatorByState = _sen['data'];
                return SenatorList(
                  sen: _sen,
                  senatorByState: _senatorByState,
                  onTap: onTapSenator,
                );
              },
              itemCount: _senators.length,
            ),
    );
  }
}
