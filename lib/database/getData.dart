import 'package:rehabis/models/memory_tile.dart';

String selectedTile = "";
int selectedIndex = 0;
bool selected = true;
int points = 0;

List<MemoryTile> myPairs = [];
List<bool> clicked = [];

List<bool> getClicked() {
  List<bool> yoClicked = [];
  List<MemoryTile> myairs = [];
  myairs = getPairs();
  for (int i = 0; i < myairs.length; i++) {
    yoClicked[i] = false;
  }

  return yoClicked;
}

List<MemoryTile> getPairs() {
  List<MemoryTile> pairs = [];

  MemoryTile tileModel = MemoryTile();

  //1
  tileModel.setImageAssetPath("assets/fox_one.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //2
  tileModel.setImageAssetPath("assets/hippo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //3
  tileModel.setImageAssetPath("assets/horse.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //4
  tileModel.setImageAssetPath("assets/monkey.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();
  //5
  tileModel.setImageAssetPath("assets/panda.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //6
  tileModel.setImageAssetPath("assets/parrot.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //7
  tileModel.setImageAssetPath("assets/rabbit.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //8
  tileModel.setImageAssetPath("assets/zoo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  return pairs;
}

List<MemoryTile> getQuestionPairs() {
  List<MemoryTile> pairs = [];

  MemoryTile tileModel = MemoryTile();

  //1
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //2
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //3
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //4
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();
  //5
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //6
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //7
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  //8
  tileModel.setImageAssetPath("assets/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = MemoryTile();

  return pairs;
}


List similiarWordsData = [
  {
    "audioFile": "cry.mp3",
    "options": [
      {"img": "assets/executioner.jpeg", "title": "Палач"},
      {"img": "assets/cry.png", "title": "Плачь"},
      {"img": "assets/cloak.jpeg", "title": "Плащ"},
      {"img": "assets/rook.jpeg", "title": "Грач"},
    ],
    "right": 1
  },
  {
    "audioFile": "pay.mp3",
    "options": [
      {"img": "assets/prophet.jpeg", "title": "Отсрочка"},
      {"img": "assets/shirt.png", "title": "Сорочка"},
      {"img": "assets/hillock.jpeg", "title": "Кочка"},
      {"img": "assets/payment.png", "title": "Рассрочка"},
    ],
    "right": 3
  },
  {
    "audioFile": "ghost.mp3",
    "options": [
      {"img": "assets/ghost.png", "title": "Привидение"},
      {"img": "assets/dream.jpeg", "title": "Приведение"},
      {"img": "assets/behaviour.png", "title": "Поведение"},
      {"img": "assets/history.jpeg", "title": "Краеведение"},
    ],
    "right": 1
  },
  {
    "audioFile": "flaw.mp3",
    "options": [
      {"img": "assets/prophet.jpeg", "title": "Пророк"},
      {"img": "assets/flaw.png", "title": "Порок"},
      {"img": "assets/flow.png", "title": "Поток"},
      {"img": "assets/pie.png", "title": "Пирог"},
    ],
    "right": 1
  },
];
