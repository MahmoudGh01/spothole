import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../job/job_gloabelclass/job_color.dart';
import '../job/job_gloabelclass/job_fontstyle.dart';
import '../job/job_pages/job_theme/job_themecontroller.dart';
import '../models/quiz.dart';
import '../models/testQ.dart';
import '../providers/userprovider.dart';
import '../utils/constants.dart';

class ScreenQuiz extends StatefulWidget {
  const ScreenQuiz({Key? key}) : super(key: key);

  @override
  State<ScreenQuiz> createState() => _ScreenQuizState();
}

class _ScreenQuizState extends State<ScreenQuiz> {
  final DateTime currentDate = DateTime.now();

  // Vérifier si la date du quiz est dépassée.
  bool isQuizDateExpired(DateTime quizDate) {
    return currentDate.isAfter(quizDate);
  }
  bool isQuizDateDesactive(DateTime quizDate) {
    return currentDate.isBefore(quizDate);
  }
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
  Future<Quiz> getQuizById(String id) async {
    Uri fetchUri = Uri.parse("${Constants.uri}/onequiz/${id}");
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(fetchUri, headers: headers);
      if (response.statusCode == 200) {
        return Quiz.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      print('Error during fetchQuiz: $e');
      throw Exception('Failed to load quiz');
    }
  }

  Future<List<TestQ>> fetchQuiz() async {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    List<TestQ> testquizs = [];
    Uri fetchUri =
    Uri.parse("${Constants.uri}/testQuizByCandidat/${user.id}");
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(fetchUri, headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        for (var item in data) {
          Quiz q = await getQuizById(item["idQuiz"]);
          testquizs.add(TestQ(
              id: item["_id"],
              idRecruter: item["idRecruter"],
              idCandidat: item["idCandidat"],
              idQuiz: item["idQuiz"],
              quiz: q,
              date: item["date"],
              score: item["score"].toInt(),
              status: item["status"]));
        }
      } else {
        throw Exception('Failed to load test quizs');
      }
    } catch (e) {
      print('Error during fetchQuiz: $e');
      throw Exception('no quiz ');
    }
    return testquizs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Quiz',
              style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<TestQ>>(
        future: fetchQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCubeGrid(
                  color: JobColor.appcolor,
                  size: 50.0
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<TestQ>? testq = snapshot.data;
            return ListView.builder(
              itemCount: testq!.length,
              itemBuilder: (context, index) {
                DateTime quizDate = DateTime.parse(testq[index].date);
                if (testq[index].status == "start"  ) {
                  if (isSameDay(currentDate,quizDate)){
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/lquiz.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          testq[index].quiz.theme,
                          style: TextStyle(
                              color: JobColor.appcolor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${testq[index].quiz.questions.length} questions',
                            ),
                            Text(
                              'Date: ${testq[index].date}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/quiz', arguments: testq[index]);
                          },
                          child: Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: JobColor.appcolor,
                          ),
                        ),
                      ),
                    );
                  }else
                  if(isQuizDateExpired(quizDate)){
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/lquiz.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          testq[index].quiz.theme,
                          style: TextStyle(
                              color: JobColor.appcolor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${testq[index].quiz.questions.length} questions',
                            ),
                            Text(
                              'Date: ${testq[index].date}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Expired Quiz',
                              style: TextStyle(
                                color: JobColor.appcolor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                      ),
                    );

                  }

                  else if(isQuizDateDesactive(quizDate)){
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/lquiz.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          testq[index].quiz.theme,
                          style: TextStyle(
                              color: JobColor.appcolor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${testq[index].quiz.questions.length} questions',
                            ),
                            Text(
                              'Date: ${testq[index].date}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Quiz will be open',
                              style: TextStyle(
                                color: JobColor.appcolor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                      ),
                    );

                  }
                  {
                    print("fama haja ");
                  }
                }

                else {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/lquiz.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        testq[index].quiz.theme,
                        style: TextStyle(
                            color: JobColor.appcolor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${testq[index].quiz.questions.length} questions',
                          ),
                          Text(
                            'Date: ${testq[index].date}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Quiz already completed',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

}