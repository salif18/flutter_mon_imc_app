import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcView extends StatefulWidget {
 
  const ImcView({super.key });

  @override
  State<ImcView> createState() => _ImcViewState();
}

class _ImcViewState extends State<ImcView> {

  double taille = 0.0;
  double poids = 0.0;
  int age = 0;
  String genre = 'Homme'; // Valeur par défaut
  double imc = 0.0;
  String resultMessage = '';

 Future<void> getFromLocalStorage(String key) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  dynamic value;

  setState(() {
    if (key == "age") {
      // Pour récupérer un entier
      value = localStorage.getInt(key);
      if (value != null) {
        age = value;
      }
    } else if (key == "genre" || key == "resultMessage") {
      // Pour récupérer une chaîne de caractères
      value = localStorage.getString(key);
      if (value != null) {
        if (key == "genre") {
          genre = value;
        } else if (key == "resultMessage") {
          resultMessage = value;
        }
      }
    } else {
      // Pour récupérer un double (taille, poids, imc)
      value = localStorage.getDouble(key);
      if (value != null) {
        if (key == "taille") {
          taille = value;
        } else if (key == "poids") {
          poids = value;
        } else if (key == "imc") {
          imc = value;
        }
      }
    }
  });
}


@override
  void initState() {
    super.initState();
    // Charger les données lors de l'initialisation
    getFromLocalStorage('taille');
    getFromLocalStorage('poids');
    getFromLocalStorage('imc');
    getFromLocalStorage('resultMessage');
    getFromLocalStorage('genre');
    getFromLocalStorage('age');
  }
   Color regeneredColor() {
    if (age < 18) {
      // Utiliser des percentiles pour les enfants
      return _colorChildImc(imc, age);
    } else if (age >= 18 && age < 65) {
      // Plages standards pour les adultes
      return _colorAdultImc(imc);
    } else if (age >= 65 && age < 80) {
      // Plages adaptées pour les personnes âgées de 65 à 80 ans
      return _colorSeniorImc_65to80(imc);
    } else {
      // Plages adaptées pour les personnes âgées de plus de 80 ans
      return _colorSeniorImc_80plus(imc);
    }
  }

  Color _colorChildImc(double imc, int age) {
    if (age >= 2 && age <= 5) {
      return _colorImcForAge(imc, 14, 17);
    } else if (age > 5 && age <= 10) {
      return _colorImcForAge(imc, 14.5, 19.5);
    } else if (age > 10 && age <= 13) {
      return _colorImcForAge(imc, 15, 22);
    } else if (age > 13 && age <= 18) {
      return _colorImcForAge(imc, 16, 24);
    } else {
      return Colors.black;
    }
  }

  Color _colorImcForAge(
      double imc, double underweightThreshold, double overweightThreshold) {
    if (imc < underweightThreshold) {
      return Colors.blue;
    } else if (imc >= underweightThreshold && imc < overweightThreshold) {
      return Colors.green;
    } else if (imc >= overweightThreshold && imc < overweightThreshold + 5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Color _colorAdultImc(double imc) {
    if (imc < 18.5) {
      return Colors.blue;
    } else if (imc >= 18.5 && imc < 25) {
      return Colors.green;
    } else if (imc >= 25 && imc < 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Color _colorSeniorImc_65to80(double imc) {
    if (imc < 23) {
      return Colors.blue;
    } else if (imc >= 23 && imc < 28) {
      return Colors.green;
    } else if (imc >= 28 && imc < 32) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Color _colorSeniorImc_80plus(double imc) {
    if (imc < 22) {
      return Colors.blue;
    } else if (imc >= 22 && imc < 27) {
      return Colors.green;
    } else if (imc >= 27 && imc < 31) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            toolbarHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Mon IMC",style: GoogleFonts.montserrat(fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.06),),
            ),
          ),
         SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: _percentCircularIndicator(
                  context, imc, regeneredColor()),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Votre IMC est de ...',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(imc.toStringAsFixed(2),
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.13,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$poids kg |",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color:
                                        const Color.fromARGB(255, 97, 97, 97))),
                            const SizedBox(width: 5),
                            Text("$taille m |",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85))),
                            const SizedBox(width: 5),
                            Text("$genre | ",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color: const Color.fromARGB(
                                        255, 105, 105, 105))),
                            const SizedBox(width: 5),
                            Text("$age ans",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color: const Color.fromARGB(
                                        255, 104, 104, 104))),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: regeneredColor(),
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Text(resultMessage,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white))),
                  ),
                  const SizedBox(height: 20),
                  if (resultMessage.contains("normal"))
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(
                                LineIcons.heart,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  " \u{1F60A} 🌞 🎉 Félicitations! Votre score est parfait. Continuez vos bonnes habitudes pour maitenir un poids sain.",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.normal,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: const Color.fromARGB(
                                          255, 36, 36, 36))),
                            ],
                          )),
                    ),
                  if (resultMessage.contains("Insuffisance"))
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(
                                Icons.heart_broken,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  "🤒 Votre score est imparfait. Adopter les bonnes habitudes pour maitenir un poids sain.",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.normal,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Colors.black)),
                            ],
                          )),
                    ),
                  if (resultMessage.contains("Surpoids"))
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(
                                Icons.heart_broken,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  "🤒 Votre score est imparfait. Adopter les bonnes habitudes pour maitenir un poids sain.",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Colors.black)),
                            ],
                          )),
                    ),
                  if (resultMessage.contains("Obésité"))
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(
                                Icons.heart_broken,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  "🤒 Votre score est imparfait. Adopter les bonnes habitudes pour maitenir un poids sain.",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Colors.black)),
                            ],
                          )),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _percentCircularIndicator(BuildContext context, imc, regeneratedColor) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CircularPercentIndicator(
      animation: true,
      animationDuration: 270,
      radius: 80,
      lineWidth: 30,
      percent: imc / 100,
      progressColor: regeneratedColor,
      backgroundColor: const Color.fromARGB(64, 64, 83, 255),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "Santé",
        style: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: regeneratedColor),
      ),
    ),
  );
}
