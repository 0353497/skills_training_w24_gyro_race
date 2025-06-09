import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gyro_race/components/car.dart';
import 'package:gyro_race/components/end_dialog.dart';
import 'package:gyro_race/components/pauze_button.dart';
import 'package:gyro_race/components/shade_overlay.dart';

class Game extends StatefulWidget {
  final String carColor;
  
  const Game({super.key, required this.carColor});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late Ticker _ticker;

  //game actually ends 2 seconds later bc i still need to show end_track
  final int gameDurationinSeconds = 5;
  late Duration timeElasedOnPaused;

  String shadeText = "0";
  bool showShade = true;
  double trackPosition = 0;
  bool firstTrackOver = false;
  bool showEndTrack = false;
  
  @override
  void initState() {
    super.initState();
    
    _ticker = createTicker((elapsed) {
      onTick(elapsed);
    });
    

    startCountDown();
  }
  
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  
  void onTick(Duration elapsed) {
  final int speed = 7500;
  double acceleration = elapsed.inMilliseconds.clamp(0, speed).toDouble() / 1000;

  if (showEndTrack) {
    double timeSinceBraking = (elapsed.inSeconds - gameDurationinSeconds).toDouble().clamp(0, 4);
    
    double brakingFactor = 1 - (timeSinceBraking / 4.0);
    acceleration *= brakingFactor;
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
      endGame();
    }

    trackPosition %= MediaQuery.of(context).size.height;
  });

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
          Car(x: 100, color: widget.carColor,),
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

    for (var i = 5; i > 0; i--) {
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
  }
  
  void endGame() {
    setState(() {
      showDialog(
        context: context,
        builder: (_) => EndDialog(onAgain: () {
          startCountDown();
        },
        title: Text(
          "Finished!",
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