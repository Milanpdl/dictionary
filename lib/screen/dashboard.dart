import 'package:dictionary_app/Models/dictionaryModel.dart';
import 'package:dictionary_app/Models/services.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool Isloading = false;
  String noDataFound = "Now you can Search";
  Dictionary? _dictionary;
  searchcontent(String word) async {
    setState(() {
      Isloading = true;
    });
    try {
      _dictionary = await APIservices.fetchData(word);
    } catch (e) {
      _dictionary = null;
      noDataFound = "Meaning can't found";
    } finally {
      setState(() {
        Isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Dictionary",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            SearchBar(
                hintText: "Search the word Here",
                onSubmitted: (value) {
                  searchcontent(value);
                }),
            SizedBox(
              height: 10,
            ),
            if (Isloading)
              const LinearProgressIndicator()
            else if (_dictionary != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dictionary!.word,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      _dictionary!.phonetics.isNotEmpty
                          ? _dictionary!.phonetics[0].text ?? ""
                          : "",
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: _dictionary!.meanings.length,
                      itemBuilder: (context, index) {
                        return showMeaning(_dictionary!.meanings[index]);
                      },
                    ))
                  ],
                ),
              )
            else
              Center(
                  child: Text(
                noDataFound,
                style: TextStyle(fontSize: 22),
              ))
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    String wordDefination = "";
    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      wordDefination += "\n${index + 1}.${element.definition}\n";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Defination:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Text(
                wordDefination,
                style: TextStyle(fontSize: 16, height: 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
