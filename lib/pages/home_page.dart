import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/models/custom_models.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  FirebaseUser curentUser;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) {
      curentUser = user;
      setState(() {});
    });
  }

  final drawerItems = [
    new DrawerItem("Search", Icons.search),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];

  _onSelectItem(BuildContext bldContext, int index) {
    print(index);
    switch (index) {
      case 0:
        MyNavigator.goToSearch(context);
        break;
      case 1:
        AppUtils.showAlert(context, "Settings", null, "Ok", () {});
        break;
      case 2:
        _auth.signOut().then((_) {
          AppUtils.showContionalAlert(
              context, "Do you want to logout?", null, "Yes", () {
            MyNavigator.goToLogin(context);
          }, "No", () => Navigator.of(context).pop());
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = List();
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(
          d.icon,
          color: Theme.of(context).accentColor,
        ),
        title: new Text(
          d.title,
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).accentColor),
        ),
        selected: i == _selectedIndex,
        onTap: () {
          _onSelectItem(context, i);
        },
      ));
    }

    return new Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'MovieGo!',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: CustomText(curentUser?.displayName, 18.0, true,
                  Theme.of(context).primaryColor, 2),
              accountEmail: CustomText(curentUser?.email, 18.0, true,
                  Theme.of(context).primaryColor, 2),
              currentAccountPicture: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 60.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: null,
              ),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
              margin: EdgeInsets.all(0.0),
            ),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: new Column(
                  children: drawerOptions,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Center(
                child: CenterText(
                    "Welcome ${curentUser == null ? "" : curentUser.displayName}!",
                    16.0,
                    true,
                    Colors.white,
                    2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
