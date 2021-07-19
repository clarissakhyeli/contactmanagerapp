import 'package:contactmanagerapp/screens/wrapper.dart';
import 'package:contactmanagerapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class Screen {
  final String title;
  final Widget child;
  final IconData iconData;
  final RouteFactory onGenerateRoute;
  final String initialRoute;
  final GlobalKey<NavigatorState> navigatorState;
  final ScrollController scrollController;

  Screen({
    @required this.title,
    @required this.child,
    @required this.iconData,
    @required this.onGenerateRoute,
    @required this.initialRoute,
    @required this.navigatorState,
    this.scrollController,
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          StreamProvider<UserModel>.value(
            value: AuthService().user,
            ),
          ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: Wrapper(),
            onGenerateRoute: NavigationProvider.of(context).onGenerateRoute,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen ({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.blueGrey,
            ),
            onGenerateRoute: NavigationProvider.of(context).onGenerateRoute,
          );
        },
      ),
    );
  }
}