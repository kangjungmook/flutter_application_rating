import 'package:flutter/material.dart';
import 'package:flutter_application_rating/Meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();
  bool enabled = false;
  List<Score> score = [];
  double rate = 0;
  @override
  void initState() {
    super.initState();
    score.add(Score(rate: 5, comment: 'dddd'));
    score.add(Score(rate: 1, comment: 'dddddd'));
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      itemBuilder: (context, index) => ListTile(
          leading: Text('${score[index].rate}'),
          title: Text(score[index].comment)),
    );
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                  enabled = true;
                });
              },
            ),
            TextFormField(
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                hintText: '한마디 해주세요',
                label: Text('한마디'),
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            ElevatedButton(
              onPressed: enabled
                  ? () async {
                      var api = MealApi();
                      var evalDate = DateTime.now().toString().split(' ')[0];
                      var res =
                          await api.insert(evalDate, rate, controller.text);
                      print(res);
                      score.add(
                        Score(rate: rate, comment: controller.text),
                      );
                      setState(() {
                        ListView;
                      });
                    }
                  : null,
              child: const Text('저장하기'),
            ),
            Expanded(child: listView)
          ],
        ),
      ),
    );
  }
}

class Score {
  double rate;
  String comment;
  Score({required this.rate, required this.comment});
}
