import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Flutter Example',

      home: MyHomePage(

      ),

    );
  }
}

class MyHomePage extends StatelessWidget {
  var usercontroller = TextEditingController();
  var passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xffcd5813),

      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // simple
            Image.asset('images/logo.png',
              width: 200,
              height: 200,
            ),
            Text('Nhập Username', textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),),
            TextField(
              controller: usercontroller,
            ),
            Text('Nhập Password', textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),),
            TextField(
              controller: passcontroller,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () => makeRequest(context),
              child: Text('Login'),
            )
          ]),
    );
  }


  void makeRequest(BuildContext context) async {
    String userName = usercontroller.text;
    String pass = passcontroller.text;
    if (pass == "khach@123") {
      if (userName.length > 0) {
        var response = await http.get(Uri.parse(
            'https://docs.google.com/spreadsheets/d/e/2PACX-1vQl4ID7SN2EbZ0wmFdLYuLVEyO0EXS-jvcai0IG_jiqC2xcsyJtPdhVaFkCbL7uQT-ZYjSOHb7s6T-7/pubhtml?gid=0&single=true'));
        //If the http request is successful the statusCode will be 200
        if (response.statusCode == 200) {
          //String htmlToParse = response.body;
          var document = parse(response.body);
          var priceElement = document.getElementsByTagName("td");
          bool dangnhap = false;
          for (var user in priceElement) {
            print(user.text + ": " + userName);
            // print(user.nodes.toString() + ": " + userName);
            if (user.text == userName) {
              dangnhap = true;
              print("OKKKK");
              int index = priceElement.indexOf(user);
              String hansudung = priceElement[index + 1].text;
              DateFormat format = DateFormat("dd/MM/yyyy");
              DateTime dthsd = format.parse(hansudung);
              try {
                var now = new DateTime.now();
                var formatter = new DateFormat('dd/MM/yyyy');
                String formattedDate = formatter.format(now);
                bool valDate = now.isBefore(dthsd);
                if (valDate == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );

                  Fluttertoast.showToast(
                      msg: "Đăng nhập thành công. Hạn sử dụng tool của bạn là: " +
                          hansudung,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                else {
                  Fluttertoast.showToast(
                      msg: "Đăng nhập thất bại. Quá hạn sử dụng! Liên hệ admin để được sử dụng!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
              on Exception catch (exception) {}
            }
          }
          if (dangnhap == false) {
            Fluttertoast.showToast(
                msg: "Đăng nhập thất bại! Người dùng không tồn tại!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
      }
      else {
        Fluttertoast.showToast(
            msg: "Không thể để trống trường userName!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    else {
      Fluttertoast.showToast(
          msg: "Sai mật khẩu!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}

class SecondRoute extends StatelessWidget {
  var sanhchoi = TextEditingController();
  var maban = TextEditingController();
  var mavan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xffcd5813),
        title: Text("Dự đoán tài xỉu"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:Text(
                    'CHÚ Ý: Để đạt hiểu quả tối đa trong quá trình dự đoán chúng tôi khuyến nghị bạn nên bắt đầu nhấn nút PLAY khi sàn bắt đầu mở phiên đặt cược!',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.white, backgroundColor: Colors.green))),
            Container(
                margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Text('Nhập sảnh chơi', textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black))),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:TextField(
                  controller: sanhchoi,
                )),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:Text('Nhập mã bàn', textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black))),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:TextField(
                  controller: maban,
                )),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:Text('Nhập mã ván', textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black))),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:TextField(
                  controller: mavan,
                )),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffcd5813), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () => makeRequest(context),
                  child: Text('Chạy dự đoán'),
                ))
          ]),
    );
  }

  void makeRequest(BuildContext context) async {
    String sanh_choi = sanhchoi.text;
    String ma_ban = maban.text;
    String ma_van = mavan.text;
    int state = -1;
    if (sanh_choi.toLowerCase().contains("baccarat")) {
      state = 0;
    }
    else if (sanh_choi.toLowerCase().contains("xóc đĩa") ||
        sanh_choi.toLowerCase().contains("xoc dia")) {
      state = 1;
    }
    else if (sanh_choi.toLowerCase().contains("sic bo") ||
        sanh_choi.toLowerCase().contains("roulette")) {
      state = 2;
    }
    if (state != -1 && ma_ban.length > 0 && ma_van.length > 0 ) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootWidget(state)),
      );

      Fluttertoast.showToast(
          msg: "Tạo phiên thành công! Nhấn nút Play để chơi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else
      {
        Fluttertoast.showToast(
            msg: "Tạo phiên thất bại! Vui lòng chọn đúng mã sảnh, mã bàn và mã ván!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }
}





class RootWidget extends StatefulWidget  {
  int state;
  RootWidget(this.state);
  @override
  _RootWidgetState createState() => _RootWidgetState(state);
}

class _RootWidgetState extends State<RootWidget> {
  int state;
  _RootWidgetState(this.state);
  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Locale('en'),
      delegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: Directionality(
        child: Navigator(
          onGenerateRoute: generate,
          onUnknownRoute: unKnownRoute,
          initialRoute: '/',
        ),
          textDirection: ui.TextDirection.ltr,
      ),
    );
  }

  Route generate(RouteSettings settings) {
    Route page;
    switch (settings.name) {
      case "/":
        page = PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation<double> animation, Animation<double> secondaryAnimation) {
          return DialogWidget(state);
        }, transitionsBuilder: (_, Animation<double> animation,
            Animation<double> second, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(second),
              child: child,
            ),
          );
        });
        break;
    }
    return page;
  }

  Route unKnownRoute(RouteSettings settings) {
    return new PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return DialogWidget(state);
    });
  }
}

class DialogWidget extends StatefulWidget {
  int state;
  DialogWidget(this.state);
  @override
  _DialogWidgetState createState() => _DialogWidgetState(state);
}

class _DialogWidgetState extends State<DialogWidget> {
  Timer timer;
  bool play = false;

  bool start = true;
  int count = 0;
  int countcanhbao = 0;
  bool canhbao = false;
  int soluongcanhbao = 0;
  int sanh_choi = 0;
  String traiString = "";
  String phaiString = "";
  String traiImage = "images/blank.png";
  String phaiImage = "images/blank.png";
  String traiImage1 = "images/blank.png";
  String phaiImage1 = "images/blank.png";
  String blankImage = "images/blank.png";
  String traiSound = "";
  String phaiSound = "";
  bool trai = true;
  bool phai = true;
  int state;
  String filePlay = "images/pausered40.png";
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();
  final player3 = AudioPlayer();

  _DialogWidgetState(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(


      child: Column(
        children: <Widget>[
          Container(
            child: new Container(
                height: 110.0,
                width: 200.0,
                decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/background3.png"),
                      fit: BoxFit.cover,
                    ),
                  //color: Color(0xff00583f),
                  borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0),

                )
              ),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children:<Widget> [



                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 4.0),
                          child:Image.asset(traiImage1,
                            width: 60,
                            height: 60,
                          )),



                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(  left: 72.0),
                          child:Image.asset(phaiImage1,
                            width: 60,
                            height: 60,
                          )),


              ]),
          )
          ),


          Container(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                height: 40.0,
                width: 100.0,
                decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(4.0),
                      bottomRight: const Radius.circular(4.0),
                    )
                ),
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:<Widget> [
                      Container(
                        margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                            onTap: () { buttonPlayClick();},
                            child: Image(
                              image: AssetImage(filePlay),
                              fit: BoxFit.cover,
                              height: 20,
                            )
                        ),
                    ),
                    Container(
                        margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                        onTap: () { closeApp();},
                        child: Image(
                        image: AssetImage('images/close40.png'),
                        fit: BoxFit.cover,
                        height: 20,
                        )
                      )),
                    ]),
              )
          ),
    ]),
    );

  }

  void createSounds() async {
    var duration1 = await player1.setAsset('sounds/sound.wav');
    var duration2 = await player2.setAsset(traiSound);
    var duration3 = await player3.setAsset(phaiSound);
  }

  void playSound(AudioPlayer player) async {
    await player.setClip(start: Duration(seconds: 0), end: Duration(seconds: 5));
    await player.play();
  }

  void closeApp()
  {
    timer.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute()),
    );
  }
  void testApp()
  {
    if(trai == true) trai = false;
    else trai = true;
    if(phai == true) phai = false;
    else phai = true;
    setState(() {});
    print(trai.toString() + "-" + phai.toString());
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createSounds();
    start = true;
    if (state == 0) {
      traiString = "BANKER";
      phaiString = "PLAYER";
      traiSound = "sounds/nhacai.wav";
      phaiSound = "sounds/nguoichoi.wav";
      traiImage = "images/banker.png";
      phaiImage = "images/player.png";

      print('initState() --->  baccarat'); // This will print "initState() ---> MainPage"
    }
    else if (state == 1) {
      traiString = "CHẴN";
      phaiString = "LẺ";
      traiSound = "sounds/chan.wav";
      phaiSound = "sounds/le.wav";
      traiImage = "images/chan.png";
      phaiImage = "images/le.png";
      print('initState() --->  xoc dia'); // This will print "initState() ---> MainPage"
    }
    else if (state == 2) {
      traiString = "TÀI";
      phaiString = "XỈU";
      traiSound = "sounds/tai.wav";
      phaiSound = "sounds/xiu.wav";
      traiImage = "images/tai.png";
      phaiImage = "images/xiu.png";
      print('initState() --->  tai xiu'); // This will print "initState() ---> MainPage"
    }
    traiImage1 = traiImage;
    phaiImage1 = phaiImage;
    setState(() {});
  }


  void showMess(String mess, Color color) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
    //5HapticFeedback.vibrate();
   // playSound("sounds/sound.wav");
  }

  void showDuDoan() {
    if(trai == true && phai == false)
      {
        showMess("Dự đoán " + traiString, Colors.blue);
        traiImage1 = traiImage;
        phaiImage1 = blankImage;
        playSound(player2);
      }
    else if (trai == false && phai == true)
      {
        showMess("Dự đoán " + phaiString, Colors.green);
        traiImage1 = blankImage;
        phaiImage1 = phaiImage;
        playSound(player3);
      }
    setState(() {});
  }


  void randomDuDoan() {
    if (play == true) {
      final random = new Random();
      bool rd = random.nextBool();
      if (rd == true) {
        trai = true;
        phai = false;
        showDuDoan();
      } else {
        trai = false;
        phai = true;
        showDuDoan();
      }
    }
  }

  void TimerMethod() {
    if (play == true) {
      count = count + 1;
      print(count.toString());
      countcanhbao = countcanhbao+1;
      if(start == true) {
        if(count >=3) {
          start = false;
          randomDuDoan();
          count = 0;
        }
      }
      else {
        if(count>=40)
        {
          count = 0;
          randomDuDoan();
        }
      }

      if(canhbao == false) {
        if(countcanhbao >=900) {
          showMess("Bạn nên dừng lại để bảo toàn dòng vốn!" + traiString, Colors.green);
          playSound(player1);
          canhbao = true;
          countcanhbao = 0;
        }
      }
      else {
        if(countcanhbao >= 15) {
          countcanhbao = 0;
          showMess("Bạn nên dừng lại để bảo toàn dòng vốn!" + traiString, Colors.green);
          playSound(player1);
          soluongcanhbao = soluongcanhbao +1;
          if(soluongcanhbao >=5) {
            canhbao = false;
          }
        }
      }
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        setState(() {
          TimerMethod();
        });
      },
    );
  }

  void buttonPlayClick() {
          if (play == false) {
            play = true;
            start = true;
            count = 0;
            countcanhbao = 0;
            canhbao = false;
            soluongcanhbao = 0;
            filePlay = "images/play40.png";
            HapticFeedback.vibrate();
            setState(() {
              startTimer();
            });
          }
          else {
            play = false;
            filePlay = "images/pausered40.png";
            timer.cancel();
            setState(() {});
          }
      }

  }
