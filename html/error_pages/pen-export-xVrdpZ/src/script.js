try {
  window.AudioContext = window.AudioContext || window.webkitAudioContext, window.audioContext = new window.AudioContext
} catch (a) {
  console.log("No Web Audio API support")
}
var WebAudioAPISoundManager = function(a) {
  this.context = a;
  this.bufferList = {};
  this.playingSounds = {}
};
WebAudioAPISoundManager.prototype = {
  addSound: function(a) {
    var b = new XMLHttpRequest;
    b.open("GET", a, !0);
    b.responseType = "arraybuffer";
    var c = this;
    b.onload = function() {
      c.context.decodeAudioData(b.response, function(b) {
        b ? c.bufferList[a] = b : alert("error decoding file data: " + a)
      })
    };
    b.onerror = function() {
      console.log("BufferLoader: XHR error")
    };
    b.send()
  },
  stopSoundWithUrl: function(a) {
    if (this.playingSounds.hasOwnProperty(a))
      for (var b in this.playingSounds[a]) this.playingSounds[a].hasOwnProperty(b) && this.playingSounds[a][b].stop()
  }
};
var WebAudioAPISound = function(a) {
  this.url = a + ".mp3";
  window.webAudioAPISoundManager = window.webAudioAPISoundManager || new WebAudioAPISoundManager(window.audioContext);
  this.manager = window.webAudioAPISoundManager;
  this.manager.addSound(this.url)
};
WebAudioAPISound.prototype = {
  play: function(a) {
    var b = this.manager.bufferList[this.url];
    this.settings = {
      loop: !1,
      volume: .5
    };
    for (var c in a) a.hasOwnProperty(c) && (this.settings[c] = a[c]);
    "undefined" !== typeof b && (a = this.makeSource(b), a.loop = this.settings.loop, a.start(0), this.manager.playingSounds.hasOwnProperty(this.url) || (this.manager.playingSounds[this.url] = []), this.manager.playingSounds[this.url].push(a))
  },
  stop: function() {
    this.manager.stopSoundWithUrl(this.url)
  },
  makeSource: function(a) {
    var b = this.manager.context.createBufferSource(),
      c = this.manager.context.createGain();
    c.gain.value = this.settings.volume;
    b.buffer = a;
    b.connect(c);
    c.connect(this.manager.context.destination);
    return b
  }
};

var typingSound = new WebAudioAPISound("https://websemantics.uk/audio/speccy.keypress");
var speccy1Sound = new WebAudioAPISound("https://websemantics.uk/audio/speccy1");
var speccy2Sound = new WebAudioAPISound("https://websemantics.uk/audio/speccy2");

var box = document.getElementById("box"),
  delay = 1;

function boxClass(cls, delay, add) {
  if (add) {
    setTimeout(function() {
      box.classList.add(cls);
    }, delay);
  } else {
    setTimeout(function() {
      box.classList.remove(cls);
    }, delay);
  }
}

function animateWords() {
  var delay = 0,
    i = 12;
  while (i--) {
    boxClass('e' + (12 - i) + 'ON', delay, true);
    delay += 200;
  }
}

boxClass('bootup', delay, true);
delay += 500;
boxClass('bootup', delay);
boxClass('text_copy', delay, true);
delay += 1500;
boxClass('text_copy', delay);
boxClass('text_load1', delay, true);
setTimeout(function() {
  typingSound.play({
    // keep it quiet
    volume: 0.1
  });
}, delay);
delay += 1250;
boxClass('text_load1', delay - 10);
boxClass('text_load2', delay, true);
setTimeout(function() {
  typingSound.play({
    volume: 0.1
  });
}, delay);
delay += 750;
boxClass('text_load2', delay - 10);
boxClass('text_load3', delay, true);
setTimeout(function() {
  typingSound.play({
    volume: 0.1
  });
}, delay);
delay += 750;
setTimeout(function() {
  typingSound.play({
    volume: 0.1
  });
}, delay - 100);
boxClass('text_load3', delay - 10);
boxClass('init_load', delay, true);
delay += 2920;

setTimeout(function() {
  speccy1Sound.play({
    loop: false,
    volume: 0.1
  });
}, delay);

delay += 80;
boxClass('start_load', delay, true);
delay += 1000;
boxClass('start_load', delay - 10);
boxClass('start_blip', delay, true);
delay += 300;
boxClass('start_blip', delay - 10);
boxClass('text_prog', delay, true);

setTimeout(function() {
  document.body.addEventListener('click', ETgoHome, false);
}, delay);

delay += 1200;
boxClass('start_load', delay, true);
delay += 150;

setTimeout(function() {
  speccy2Sound.play({
    loop: false,
    volume: 0.1
  });
}, delay);

delay += 350;
boxClass('init_load', delay - 20);
boxClass('start_load', delay - 10);
boxClass('loading', delay, true);

setTimeout(animateWords, delay);
boxClass('text_prog', delay);

delay += 2150;
boxClass('loading', delay - 20);
boxClass('text_rtape', delay, true);