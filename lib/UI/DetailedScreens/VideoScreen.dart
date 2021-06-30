import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SamplePlayer extends StatefulWidget {
  final video_id, video_link;

  SamplePlayer(this.video_id, this.video_link);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  YoutubePlayerController _controller;
  String video_id_to_play;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    setState(() {
      if (widget.video_link != null) {
        try {
          video_id_to_play =
              YoutubePlayerController.convertUrlToId(widget.video_link);
          print('this is ' + video_id_to_play);
        } on Exception catch (exception) {
          print('exception');
        } catch (error) {
          print('catch error');
        }
      } else {
        video_id_to_play = widget.video_id;
      }
    });

    /*_controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );*/

/*

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
*/

    _controller = YoutubePlayerController(
      initialVideoId: video_id_to_play,
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        showControls: true,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    );

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {};
  }

  @override
  void dispose() {
    /* _controller.toggleFullScreenMode();*/
    // _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayerIFrame(
        controller: _controller,
        aspectRatio: 16 / 9,
      ), /*YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),*/
    );
  }
}
