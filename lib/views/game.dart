import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gyro_race/components/car.dart';
import 'package:gyro_race/components/cone.dart';
import 'package:gyro_race/components/end_dialog.dart';
import 'package:gyro_race/components/pauze_button.dart';
import 'package:gyro_race/components/score_tracker.dart';
import 'package:gyro_race/components/shade_overlay.dart';
import 'package:gyro_race/components/star.dart';
import 'package:gyro_race/models/car_model.dart';
import 'package:gyro_race/models/cone_model.dart';
import 'package:gyro_race/models/star_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Game extends StatefulWidget {
  final String carColor;
  
  const Game({super.key, required this.carColor});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late Ticker _ticker;
  final StreamController _gyroController = StreamController();
  StreamSubscription? _gyroSubscription;
  final int gameDurationinSeconds = 25;
  late Duration timeElasedOnPaused;

  final double _sensitivityFactor = 12.0;
  double _targetCarPosition = 100.0;
  double _currentGyroValue = 0.0;
  final double _movementSmoothness = 0.3;

  String shadeText = "0";
  bool showShade = true;
  double trackPosition = 0;
  bool firstTrackOver = false;
  bool showEndTrack = false;
  int score = 0;
  late final CarModel car;
  final ConeModel coneModel = ConeModel(220, 0);
  final StarModel starModel = StarModel(100, 0);
  Duration lastDurationOfScore = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    
    car = CarModel(100, widget.carColor);
    _ticker = createTicker((elapsed) {
      onTick(elapsed);
    });

    startCountDown();

  }
  
  @override
  void dispose() {
    _ticker.dispose();
    _gyroSubscription?.cancel();
    super.dispose();
  }
  
  void onTick(Duration elapsed) {
  final int speed = 7500;
  double acceleration = elapsed.inMilliseconds.clamp(0, speed).toDouble() / 1000;

  if (showEndTrack) {
    double timeSinceBraking = (elapsed.inSeconds - gameDurationinSeconds).toDouble().clamp(0, 5);
    
    double brakingFactor = 1 - (timeSinceBraking / 5.0);
    acceleration *= brakingFactor;
  } else if (firstTrackOver) {
    acceleration = 7.5;
  }
  
  setState(() {
    trackPosition += acceleration;

    if (trackPosition >= MediaQuery.of(context).size.height && !firstTrackOver) {
      firstTrackOver = true;
    }

    if (elapsed.inSeconds > gameDurationinSeconds &&
        trackPosition < MediaQuery.of(context).size.height * 0.75) {
      showEndTrack = true;
    }

    if (elapsed.inSeconds > (gameDurationinSeconds + 3)) {
      endGame("Finished!");
    }

    trackPosition %= MediaQuery.of(context).size.height;
    coneModel.top = trackPosition;
    
    starModel.top = (trackPosition + MediaQuery.of(context).size.height * 0.5) % MediaQuery.of(context).size.height;

    if (_currentGyroValue != 0) {
      _targetCarPosition = _targetCarPosition - (_currentGyroValue * _sensitivityFactor);
      _targetCarPosition = _targetCarPosition.clamp(80.0, 240.0);
    }
    
    double distance = _targetCarPosition - car.left;
    car.left += distance * _movementSmoothness;
    car.rotation = -(_currentGyroValue);
    
    if (coneModel.top > 0 && coneModel.top < MediaQuery.of(context).size.height - 50) {
      if (checkCollision(coneModel.bounds)) {
        failedGame("Crashed!");
      }
    }
    if (starModel.top > 0 && starModel.top < MediaQuery.of(context).size.height - 50) {
      if (checkCollision(starModel.bounds) && (elapsed.inSeconds > (lastDurationOfScore.inSeconds + 1))) {
        addScore(elapsed);
      }
    }
    if (trackPosition > MediaQuery.of(context).size.height - 8) respawnCone();
    if (starModel.top > MediaQuery.of(context).size.height - 8) respawnStar();
  });
  }

  void addScore(Duration elapsed) async {
    lastDurationOfScore = elapsed;
    setState(() {
      starModel.showStar = false;
      score++;
    });
    return;
  }

  void pauzeTick(){ 
    setState(() {
      _ticker.stop();
      shadeText = "Paused";
      showShade = true;
    });
  }

  void playtick() {
    setState(() {
      showShade = false;
      _ticker.start();
    });
  }
  
  void reset() {
    setState(() {
      lastDurationOfScore = Duration.zero;
      score = 0;
      shadeText = "0";
      showShade = true;
      trackPosition = 0;
      firstTrackOver = false;
      showEndTrack = false;
      _ticker.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          DefaultTrack(trackPosition: trackPosition),
          DefaultTrack(trackPosition: trackPosition - screenHeight),
          firstTrackOver ?
          SizedBox()
          :  StartTrack(trackPosition: trackPosition + (screenHeight * 0.28)),
          showEndTrack
          ? EndTrack(trackPosition: (trackPosition) - (screenHeight * 0.9))
          : SizedBox(),
          

          Car(car: car,),
          Star(starModel: starModel),
          Cone(coneModel: coneModel),
          Scoretracker(score: score),

          showShade ? ShadeOverlay(
            text: shadeText,
            pauzed: !_ticker.isActive,
          ) : SizedBox(),
          PauzeButton(
            onPressed: _ticker.isActive ? pauzeTick : playtick,
            icon: _ticker.isActive ? Icons.pause : Icons.play_arrow,),
        ],
      ),
    );
  }
  
  void startCountDown() async {

    for (var i = 3; i > 0; i--) {
      setState(() {
        shadeText = "$i";
      });
      await Future.delayed(Duration(seconds: 1));
    }
    if (_ticker.isActive) _ticker.stop();
    setState(() {
      _ticker.start();
      showShade = false;
    });
    listenCarPosition();

  }
  
  void endGame(String title) {
    _gyroSubscription?.cancel();
    
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => EndDialog(onAgain: () {
          startCountDown();
        },
        title: Text(
          title,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        ),
      );
      reset();
    });
  }
  void failedGame(String title) {
    _gyroSubscription?.cancel();
    
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => EndDialog(onAgain: () {
          startCountDown();
        },
        title: Text(
          title,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red
          ),
        ),
        ),
      );
      reset();
    });
  }
  
  bool checkCollision(Rect bounds) {
    return car.bounds.overlaps(bounds);
  }
  
  void respawnStar() {
    final int side = Random().nextInt(2);
    final double position = side == 0 ? 100 : 220;

    setState(() {
      starModel.showStar = true;
      starModel.left = position;
      starModel.top = 0;
    });
  }
  void respawnCone() {
    final int side = Random().nextInt(2);
    final double position = side == 0 ? 100 : 220;

    setState(() {
      coneModel.showCone = true;
      coneModel.left = position;
    });
  }
  
  void listenCarPosition() {
    _gyroSubscription?.cancel();
    
    _targetCarPosition = car.left;
    
    _gyroSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _gyroController.add(event);
      _currentGyroValue = -event.y;
    });
  }
}

class DefaultTrack extends StatelessWidget {
  const DefaultTrack({
    super.key,
    required this.trackPosition,
    this.isSecond = false
  });

  final double trackPosition;
  final bool isSecond;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, trackPosition),
        child: Image.asset(
          "assets/default_track.png",
          repeat: ImageRepeat.repeatY,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class StartTrack extends StatelessWidget {
  const StartTrack({
    super.key,
    required this.trackPosition,
  });

  final double trackPosition;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, trackPosition),
        child: Image.asset(
          "assets/start_track.png",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class EndTrack extends StatelessWidget {
  const EndTrack({
    super.key,
    required this.trackPosition,
  });

  final double trackPosition;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, trackPosition),
        child: Image.asset(
          "assets/end_track.png",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}