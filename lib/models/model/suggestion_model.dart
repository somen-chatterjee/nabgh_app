class SuggestionModel {
  String? text;
  int? index;

  // Null? logprobs;
  String? finishReason;

  SuggestionModel({
    this.text,
    this.index,
    /* this.logprobs,*/ this.finishReason,
  });

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    index = json['index'];
    // logprobs = json['logprobs'];
    finishReason = json['finish_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['index'] = index;
    // data['logprobs'] = this.logprobs;
    data['finish_reason'] = finishReason;
    return data;
  }
}
