const flanker = (function () {
  let _repeat_practice = 2;
  let _repeat_main = 10;
  let _font_size = 48;

  let _stims = [
    { stim: '<<<<<', condition: '一致', key: 'f' },
    { stim: '>>>>>', condition: '一致', key: 'j' },
    { stim: '>><>>', condition: '不一致', key: 'f' },
    { stim: '<<><<', condition: '不一致', key: 'j' },
    { stim: '--<--', condition: '中性', key: 'f' },
    { stim: '-->--', condition: '中性', key: 'j' },
  ];

  var _fixation = {
    type: 'html-keyboard-response',
    stimulus: function () {
      return `<p style="font-size: ${_font_size}px">+</p>`;
    },
    choices: jsPsych.NO_KEYS,
    trial_duration: 500,
  };

  var _blank = {
    type: 'html-keyboard-response',
    stimulus: '',
    choices: jsPsych.NO_KEYS,
    trial_duration: 500,
  };

  function _buildBlock(repeat_n, task_nm) {
    let trial = {
      type: 'html-keyboard-response',
      stimulus: function () {
        return `<p style="font-size: ${_font_size}px">${jsPsych.timelineVariable('stim')}</p>`;
      },
      choices: ['f', 'j'],
      data: {
        condition: jsPsych.timelineVariable('condition'),
        key: jsPsych.timelineVariable('key'),
        task: task_nm,
      },
      on_finish: function (data) {
        data.correct = Number(jsPsych.pluginAPI.compareKeys(data.response, data.key));
      },
    };

    return {
      timeline: [_blank, _fixation, trial],
      timeline_variables: _stims,
      sample: {
        type: 'fixed-repetitions',
        size: repeat_n,
      },
    };
  }

  return {
    set repeat_practice(num) {
      if (typeof param == 'number') _repeat_practice = num;
    },

    set repeat_main(num) {
      if (typeof param == 'number') _repeat_main = num;
    },

    main: _buildBlock(_repeat_main, 'flanker_main'),

    practice: _buildBlock(_repeat_practice, 'flanker_practice'),
  };
})();

flanker.inst = (function () {
  function _useDefault(stim) {
    return {
      type: 'html-keyboard-response',
      stimulus: stim,
      choices: ['f', 'j'],
      data: { task: 'instruction' },
    };
  }

  return {
    get procedure() {
      var txt =
        'これから画面上に５つの矢印（>>>>>など）が表示されます。<br>' +
        '中央の矢印が左向き（<）なら「f」キーを<br>' +
        '中央の矢印が右向き（>）なら「j」キーを<br>' +
        'なるべく早く，正確に押してください<br><br>' +
        '準備ができたら「f」キーか「j」キーを押して練習を開始してください。';
      return _useDefault(txt);
    },

    get go_main() {
      var txt = 'それでは本番を行います。<br>準備ができたら「f」キーか「j」キーを押して課題を開始してください。';
      return _useDefault(txt);
    },
  };
})();

flanker.cursor = {
  on: {
    type: 'call-function',
    func: function () {
      document.body.style.cursor = 'none';
    },
  },
  off: {
    type: 'call-function',
    func: function () {
      document.body.style.cursor = 'default';
    },
  },
};
