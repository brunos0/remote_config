import 'package:br_dev_coderia_remoteconfig/data/e_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gap/gap.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MagazineApp',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FirebaseRemoteConfig remoteConfig;

  @override
  void initState() {
    super.initState();
    firebaseInit();
  }

  Future<void> firebaseInit() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'time_app': true,
      'mundias': 2,
      'nome': 'Corinthians',
      'cor': 'black'
    });
    await remoteConfig.fetchAndActivate();
  }

  @override
  Widget build(BuildContext context) {
    final isSoccer = remoteConfig.getBool('time_app');
    final mundialPrizes = remoteConfig.getInt('mundias');
    final soccerTeamName = remoteConfig.getString('nome');
    final soccerTeamColor = remoteConfig.getString('cor');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isSoccer ? colorMap[soccerTeamColor] : Colors.orange,
        title: const Text(
          'MagazineApp',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Clique aqui para ver o horóscopo do dia.',
                softWrap: true, textAlign: TextAlign.justify),
            const Gap(10),
            Visibility(
              visible: isSoccer,
              child: Flexible(
                child: Text(
                  'O $soccerTeamName é um time com atualmente $mundialPrizes título(s) mundiais de clube Fifa.',
                  softWrap: true,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
