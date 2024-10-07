import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultView extends StatefulWidget {
  final double imc;
  final String resultMessage;
  final Color regenerateColor;
  final int age;
  final double poids;
  final double taille;
  final String genre;
  const ResultView(
      {super.key,
      required this.imc,
      required this.poids,
      required this.taille,
      required this.age,
      required this.genre,
      required this.resultMessage,
      required this.regenerateColor});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f1f5),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: MediaQuery.of(context).size.width * 0.06,
            )),
        toolbarHeight: 80,
        actions: [
          Icon(
            LineIcons.heartbeat,
            color: Colors.red,
            size: MediaQuery.of(context).size.width * 0.09,
          ),
          const SizedBox(width: 20)
        ],
        title: Text(
          "Resultat d'analyse ",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width * 0.06),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: _percentCircularIndicator(
                  context, widget.imc, widget.regenerateColor),
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
                    child: Text(widget.imc.toStringAsFixed(2),
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
                            Text("${widget.poids} kg |",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color:
                                        const Color.fromARGB(255, 97, 97, 97))),
                            const SizedBox(width: 5),
                            Text("${widget.taille} m |",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85))),
                            const SizedBox(width: 5),
                            Text("${widget.genre} | ",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color: const Color.fromARGB(
                                        255, 105, 105, 105))),
                            const SizedBox(width: 5),
                            Text("${widget.age} ans",
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
                            color: widget.regenerateColor,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Text(widget.resultMessage,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white))),
                  ),
                  const SizedBox(height: 20),
                  if (widget.resultMessage.contains("normal"))
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
                  if (widget.resultMessage.contains("Insuffisance"))
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
                  if (widget.resultMessage.contains("Surpoids"))
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
                  if (widget.resultMessage.contains("Obésité"))
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
