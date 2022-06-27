import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TicTacToe());
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<int>> gridState = [
    [47, 47, 47],
    [47, 47, 47],
    [47, 47, 47]
  ];
  int chance = 0;
  int result=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('ELC Activity TicTakToe',
          style: TextStyle(color: Colors.green[800],),
        ),

        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          child: ListView(
            children: <Widget>[
              chance > 0
                  ? Center(
                child: RaisedButton(
                    onPressed: () {
                      gridState = [
                        [47, 47, 47],
                        [47, 47, 47],
                        [47, 47, 47]
                      ];
                      chance = 0;
                      setState(() {});
                    },
                    child: Text(
                      'Restart',
                    )),
              )
                  : Container(),
              _buildGameBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = gridState.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
            ),
            itemBuilder: _buildGridItems,
            itemCount: gridStateLength * gridStateLength,
          ),
        ),
      ),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      //onTap: () => _gridItemTapped(x, y),
      onTap: () async {
        //chance = chance % 2;
        print('x= $x   y=$y chance = $chance');

        if (gridState[x][y] == 47) {
          if (chance % 2 == 0) {
            gridState[x][y] = 0;
            result = check(0);
          } else {
            gridState[x][y] = 1;
            result = check(1);
          }

          chance = chance + 1;
          if (chance == 9){
            // await Future.delayed(const Duration(milliseconds:250 ));
            showAlertDialog(context, result);
          }

          setState(() {});
          if (result == 0 || result == 1) {
            showAlertDialog(context, result);
          }
        }
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: display(x, y),
          ),
        ),
      ),
    );
  }

  Widget display(int x, int y) {
    switch (gridState[x][y].toString()) {
      case '47':
        return Text('');
      case '0':
        return Container(
          child:Text('0',style:TextStyle(fontSize: 60)),
        );
      case '1':
        return Container(
          child:Text('X',style:TextStyle(fontSize: 60)),
        );

      default:
        return Text(gridState[x][y].toString());
    }
  }

  int check(int k) {
    List<List<int>> a = gridState;
    if ((a[0][0] == k && a[0][1] == k && a[0][2] == k) ||
        (a[1][0] == k && a[1][1] == k && a[1][2] == k) ||
        (a[2][0] == k && a[2][1] == k && a[2][2] == k) ||
        (a[0][0] == k && a[1][0] == k && a[2][0] == k) ||
        (a[0][1] == k && a[1][1] == k && a[2][1] == k) ||
        (a[0][2] == k && a[1][2] == k && a[2][2] == k) ||
        (a[0][0] == k && a[1][1] == k && a[2][2] == k) ||
        (a[2][0] == k && a[1][1] == k && a[0][2] == k))
      return k;
    else
      return 47;
  }

  showAlertDialog(BuildContext context, int k) async {
    await Future.delayed(const Duration(milliseconds:100));

    gridState = [
      [47, 47, 47],
      [47, 47, 47],
      [47, 47, 47]
    ];
    chance = 0;
    setState((){});
    Widget launchButton = FlatButton(
      child: Text("Restart"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Results"),
      content: result == 47
          ? Text('Match Drawn')
          : Text("Player ${result + 1} Won!."),
      actions: <Widget>[launchButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}