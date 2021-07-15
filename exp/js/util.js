const util = (function () {
  let _expID = 0;

  // For data saving
  let _saveData = function (name, data) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({ filename: name, filedata: data }));
  };
  return {
    get expID() {
      return _expID;
    },
    set expID(param) {
      if (typeof param == 'number' || typeof param == 'string') {
        _expID = param;
      }
    },

    par_info: {
      tempID: jsPsych.randomization.randomID(12),
    },

    start_fullscreen: {
      type: 'fullscreen',
      message: '<p>ウィンドウサイズを最大化します。下のボタンを押してください。</p>',
      button_label: '次へ',
      fullscreen_mode: true,
      data: { task: 'instruction' },
    },

    end_fullscreen: {
      type: 'fullscreen',
      fullscreen_mode: false,
      data: { task: 'instruction' },
    },

    save_data: {
      type: 'call-function',
      func: function () {
        jsPsych.data.addProperties(util.par_info);
        _saveData(`exp${_expID}/${util.par_info.tempID}_flanker-BB_exp${_expID}.csv`, jsPsych.data.get().csv());
      },
    },
  };
})();

util.ask = {
  age: {
    type: 'survey-text',
    questions: [{ prompt: '年齢を入力してください', columns: 3, required: true, name: 'age' }],
    data: { task: 'par_info' },
    on_finish: function (data) {
      util.par_info.age = data.response.age;
    },
  },
  sex: {
    type: 'survey-multi-choice',
    questions: [{ prompt: '性別を回答してください', options: ['男性', '女性'], required: true, horizontal: true, name: 'sex' }],
    data: { task: 'par_info' },
    on_finish: function (data) {
      util.par_info.sex = data.response.sex;
    },
  },
};

util.inst = (function () {
  let _getDefault = function (stimulus, prompt = '<p>Press spacebar to continue<p>') {
    return {
      type: 'html-keyboard-response',
      stimulus: stimulus,
      prompt: prompt,
      choices: [' '],
      data: { task: 'instruction' },
    };
  };

  return {
    get opening() {
      txt = 'これから実験をおこないます。';
      let inst_obj = _getDefault(txt);
      return inst_obj;
    },

    get finale() {
      let inst_obj = _getDefault(
        '<p>The experiment is over. Thank you for your participation</p>',
        'Please wait for 5 seconds. The window reverts to the original size automatically.'
      );
      inst_obj.choices = jsPsych.NO_KEYS;
      inst_obj.trial_duration = 5000;

      return inst_obj;
    },
  };
})();
