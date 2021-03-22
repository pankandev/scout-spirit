enum DevelopmentStage { Prepuberty, Puberty }

Map<String, DevelopmentStage> _stageNames = {
  "prepuberty": DevelopmentStage.Prepuberty,
  "puberty": DevelopmentStage.Puberty
};

String stageToString(DevelopmentStage stage) {
  return stage.toString().split('.')[1].toLowerCase();
}

DevelopmentStage stageFromName(String name) {
  return _stageNames[name];
}