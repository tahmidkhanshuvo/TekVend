import '../pages.dart';

class HeadlineWidget extends StatelessWidget {
  const HeadlineWidget({Key? key}) : super(key: key);

  Stream<List<String>> _getHeadlinesStream() {
    return FirebaseFirestore.instance
        .collection('headlines')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc['text'] as String).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _getHeadlinesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List<String> headlines = snapshot.data ?? [];
        return Container(
          height: 40,
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Marquee(
            text: headlines.join('   |   '),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            scrollAxis: Axis.horizontal,
            blankSpace: 20.0,
            velocity: 50.0,
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        );
      },
    );
  }
}
