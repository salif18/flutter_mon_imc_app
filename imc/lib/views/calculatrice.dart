import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imc/views/result_view.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcCalculatorView extends StatefulWidget {
  const ImcCalculatorView({super.key});

  @override
  State<ImcCalculatorView> createState() => _ImcCalculatorViewState();
}

class _ImcCalculatorViewState extends State<ImcCalculatorView> {
  final _formKey = GlobalKey<FormState>();
  double _height = 0.0;
  double _weight = 0.0;
  int _age = 0;
  String _genre = 'Homme'; // Valeur par défaut
  double _imc = 0.0;
  String _resultMessage = '';

  //sauvegarder dans localstorage
  Future<void> saveToLocalStorage(String key, value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (value is int) {
    await localStorage.setInt(key, value);
  } else if (value is double) {
    await localStorage.setDouble(key, value);
  } else if (value is String) {
    await localStorage.setString(key, value);
  } else {
    throw Exception("Type de donnée non pris en charge pour la sauvegarde dans SharedPreferences");
  }
  }

  void _calculateImc() {
    // Validation du formulaire
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        // Calcul de l'IMC
        _imc = _weight / (_height * _height);
        // Interprétation du résultat de l'IMC
        _resultMessage = _interpretImc(_imc, _age, _genre);
      });

      saveToLocalStorage("age", _age);
      saveToLocalStorage("poids", _weight);
      saveToLocalStorage("taille", _height);
      saveToLocalStorage("genre", _genre);
      saveToLocalStorage("imc", _imc);
      saveToLocalStorage("resultMessage", _resultMessage);
      // Navigation vers l'écran de résultats IMC
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultView(
              imc: _imc,
              poids: _weight,
              taille: _height,
              age: _age,
              genre: _genre,
              resultMessage: _resultMessage,
              regenerateColor: regeneredColor()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez corriger les erreurs dans le formulaire.',
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.03),
          ),
        ),
      );
    }
  }

  // message d'analyse
  String _interpretImc(double imc, int age, String genre) {
    if (age < 18) {
      // Utiliser des percentiles pour les enfants
      return _interpretChildImc(imc, age);
    } else if (age >= 18 && age < 65) {
      // Plages standards pour les adultes
      return _interpretAdultImc(imc, genre);
    } else if (age >= 65 && age < 80) {
      // Plages adaptées pour les personnes âgées de 65 à 80 ans
      return _interpretSeniorImc_65to80(imc);
    } else {
      // Plages adaptées pour les personnes âgées de plus de 80 ans
      return _interpretSeniorImc_80plus(imc);
    }
  }

  // interpretaion pour enfant en fonction de l'âge
  String _interpretChildImc(double imc, int age) {
    if (age >= 0 && age <= 5) {
      return _interpretImcForAge(imc, 14, 17);
    } else if (age > 5 && age <= 10) {
      return _interpretImcForAge(imc, 14.5, 19.5);
    } else if (age > 10 && age <= 13) {
      return _interpretImcForAge(imc, 15, 22);
    } else if (age > 13 && age <= 18) {
      return _interpretImcForAge(imc, 16, 24);
    } else {
      return 'Âge non pris en charge pour l’interprétation enfant.';
    }
  }

  // Fonction pour interpréter l'IMC en fonction des seuils spécifiques à l'âge
  String _interpretImcForAge(
      double imc, double underweightThreshold, double overweightThreshold) {
    if (imc < underweightThreshold) {
      return 'Insuffisance pondérale pour Enfant';
    } else if (imc >= underweightThreshold && imc < overweightThreshold) {
      return 'Poids normal pour Enfant';
    } else if (imc >= overweightThreshold && imc < overweightThreshold + 5) {
      return 'Surpoids pour Enfant';
    } else {
      return 'Obésité pour Enfant';
    }
  }

  // interpretation pour adulte
  String _interpretAdultImc(double imc, genre) {
    if (genre == 'Homme') {
      if (imc < 18.5) {
        return 'Insuffisance pondérale Homme';
      } else if (imc >= 18.5 && imc < 25) {
        return 'Poids normal pour Homme';
      } else if (imc >= 25 && imc < 30) {
        return 'Surpoids pour Homme';
      } else {
        return 'Obésité pour Homme';
      }
    } else {
      if (imc < 18.5) {
        return 'Insuffisance pondérale Femme';
      } else if (imc >= 18.5 && imc < 24) {
        // seuils légèrement différents
        return 'Poids normal pour Femme';
      } else if (imc >= 24 && imc < 29) {
        return 'Surpoids pour Femme';
      } else {
        return 'Obésité pour Femme';
      }
    }
  }

  // Fonction pour interpréter l'IMC pour les personnes âgées de 65 à 80 ans
  String _interpretSeniorImc_65to80(double imc) {
    if (imc < 23) {
      return 'Insuffisance pondérale pour 65 à 80 ans';
    } else if (imc >= 23 && imc < 28) {
      return 'Poids normal pour 65 à 80 ans';
    } else if (imc >= 28 && imc < 32) {
      return 'Surpoids pour 65 à 80 ans';
    } else {
      return 'Obésité pour 65 à 80 ans';
    }
  }

// Fonction pour interpréter l'IMC pour les personnes âgées de plus de 80 ans
  String _interpretSeniorImc_80plus(double imc) {
    if (imc < 22) {
      return 'Insuffisance pondérale pour 80 ans et plus';
    } else if (imc >= 22 && imc < 27) {
      return 'Poids normal pour 80 ans et plus';
    } else if (imc >= 27 && imc < 31) {
      return 'Surpoids pour 80 ans et plus';
    } else {
      return 'Obésité pour 80 ans et plus';
    }
  }

  Color regeneredColor() {
    if (_age < 18) {
      // Utiliser des percentiles pour les enfants
      return _colorChildImc(_imc, _age);
    } else if (_age >= 18 && _age < 65) {
      // Plages standards pour les adultes
      return _colorAdultImc(_imc);
    } else if (_age >= 65 && _age < 80) {
      // Plages adaptées pour les personnes âgées de 65 à 80 ans
      return _colorSeniorImc_65to80(_imc);
    } else {
      // Plages adaptées pour les personnes âgées de plus de 80 ans
      return _colorSeniorImc_80plus(_imc);
    }
  }

  Color _colorChildImc(double imc, int age) {
    if (age >= 0 && age <= 5) {
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
      backgroundColor: const Color(0xfff0f1f5),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xffffffff),
        actions: [
          Icon(
            LineIcons.doctor,
            color: Colors.blueGrey,
            size: MediaQuery.of(context).size.width * 0.09,
          ),
          const SizedBox(width: 20)
        ],
        title: Text('Calculatrice IMC',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Champ pour la taille
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Taille",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: GoogleFonts.montserrat(
                            color: Colors.blue, // Change la couleur du texte
                            fontWeight:
                                FontWeight.bold, // Change le poids du texte
                            fontSize: MediaQuery.of(context).size.width *
                                0.05, // Taille du texte
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Taille (m)',
                            hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              LineIcons.rulerVertical,
                              size: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.blue[600],
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre taille';
                            }
                            final parsedValue = double.tryParse(value);
                            if (parsedValue == null || parsedValue <= 0) {
                              return 'Veuillez entrer un nombre';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _height = double.parse(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      width: 16.0), // Espacement entre les deux champs

                  // Champ pour le poids
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Poids",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(
                                255, 22, 177, 1), // Change la couleur du texte
                            fontWeight:
                                FontWeight.bold, // Change le poids du texte
                            fontSize: MediaQuery.of(context).size.width *
                                0.05, // Taille du texte
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Poids (kg)',
                            hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              Icons.speed_rounded,
                              size: MediaQuery.of(context).size.width * 0.1,
                              color: const Color.fromARGB(255, 22, 177, 1),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre poids';
                            }
                            final parsedValue = double.tryParse(value);
                            if (parsedValue == null || parsedValue <= 0) {
                              return 'Veuillez entrer un nombre';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _weight = double.parse(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Âge",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    style: GoogleFonts.montserrat(
                      color:
                          Colors.deepOrange[800], // Change la couleur du texte
                      fontWeight: FontWeight.bold, // Change le poids du texte
                      fontSize: MediaQuery.of(context).size.width *
                          0.05, // Taille du texte
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Âge',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          Icons.cake,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.deepOrange[600],
                        ),
                        hintStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre âge';
                      }
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null || parsedValue <= 0) {
                        return 'Veuillez entrer un nombre naturel';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _age = int.parse(value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Genre",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.man_outlined,
                              color: Colors.blue,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Radio<String>(
                              value: 'Homme',
                              groupValue: _genre,
                              onChanged: (String? value) {
                                setState(() {
                                  _genre = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.woman,
                              color: const Color.fromARGB(255, 243, 33, 149),
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Radio<String>(
                              value: 'Femme',
                              groupValue: _genre,
                              onChanged: (String? value) {
                                setState(() {
                                  _genre = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        onPressed: _calculateImc,
        label: Text(
          "Calculer",
          style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    );
  }
}
