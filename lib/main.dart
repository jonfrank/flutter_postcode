import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _formattedPostcode = '';
  final _postcodeController = TextEditingController();
  // set up regex for matching postcodes
  // taken from https://regex101.com/library/mOsPHp
  final RegExp postcodeRegExp = new RegExp(
      r"^(A[BL]|B[ABDFHLNRSTX]?|C[ABFHMORTVW]|D[ADEGHLNTY]|E[CHNX]?|F[KY]|G[LUY]?|H[ADGPRSUX]|I[GMPV]|JE|K[ATWY]|L[ADELNSU]?|M[EKL]?|N[EGNPRW]?|O[LX]|P[AEHLOR]|R[GHM]|S[AEGKLMNOPRSTWY]?|T[ADFNQRSW]|UB|W[ACDFNRSV]?|YO|ZE)(\d[\dA-Z]?) ?(\d)([A-Z]{2})");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _postcodeController.dispose();
    super.dispose();
  }

  void _formatPostcode() {
    setState(() {
      _formattedPostcode = validatePostcode(_postcodeController.text);
      // validatePostcode() returns either a formatted valid postcode or else null
      if (_formattedPostcode == null) {
        _formattedPostcode = '#error#';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _postcodeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a postcode'),
              ),
              ElevatedButton(
                onPressed: _formatPostcode,
                child: const Text('Test it'),
              ),
              Spacer(),
              Text(
                '$_formattedPostcode',
                style: Theme.of(context).textTheme.headline4,
              ),
              Spacer(flex: 8),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _formatPostcode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  validatePostcode(pc) {
    // convert to upper case and then get the first regex match
    Match match = postcodeRegExp.firstMatch(pc.toUpperCase());
    // the match will contain four groups for a properly formatted postcode
    // which are displayed as G1G2 G3G4 (i.e. concatenated but with a space between the 3rd and 4th groups)
    if (match == null || match.groupCount != 4) {
      // if we got no match or somehow not the right number of groups, return null
      return null;
    } else {
      // format the groups properly
      // (group 0 is the whole match)
      return "${match.group(1)}${match.group(2)} ${match.group(3)}${match.group(4)}";
    }
  }
}
