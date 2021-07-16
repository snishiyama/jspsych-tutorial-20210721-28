util.expID = 1;
flanker.repeat_practice = 2;
flanker.repeat_main = 10;

const get_par_info = {
  timeline: [util.ask.age, util.ask.sex],
};

const flanker_task = {
  timeline: [flanker.cursor.off, flanker.inst.procedure, flanker.practice, flanker.inst.go_main, flanker.main, flanker.cursor.on],
};

var exp_timeline = [util.inst.opening, util.start_fullscreen, get_par_info, util.save_data, util.inst.finale, util.end_fullscreen];
// var exp_timeline = [util.inst.opening, util.start_fullscreen, get_par_info, util.inst.finale, util.end_fullscreen]; // for debug
var cb; // identifier of counter balance (CB)
if (Math.random() < 0.5) {
  exp_timeline.splice(3, 0, flanker_task, BISBAS.instruction, BISBAS.trial);
  cb = 1;
} else {
  exp_timeline.splice(3, 0, BISBAS.instruction, BISBAS.trial, flanker_task);
  cb = 2;
}
jsPsych.data.addProperties({ CB: cb }); // add identifier of counter balance (CB)

jsPsych.init({
  timeline: exp_timeline,
});
