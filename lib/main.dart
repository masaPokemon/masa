import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(_PointsPageState())
}

class _PointsPageState extends State<PointsPage> {
  int points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロードする関数
  void _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      points = (prefs.getInt('points') ?? 0);
    });
  }

  // ポイントを保存する関数
  void _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', points);
  }

  void addPoints(int value) {
    setState(() {
      points += value;
    });
    _savePoints();  // 保存する
  }

  void subtractPoints(int value) {
    setState(() {
      points -= value;
    });
    _savePoints();  // 保存する
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイントシステム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '現在のポイント:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$points',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => addPoints(10),
                  child: Text('+10 ポイント'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => subtractPoints(10),
                  child: Text('-10 ポイント'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
