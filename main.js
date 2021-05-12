const fs = require("fs");
const RLE = require("run-length-encoder-decoder");
let arr = [];
let str = ``;
let result = ``;
let splittedResult;
let finalResult = [];

function dec2bin(dec) {
  return Number(dec).toString(2);
}

function finalFormat(splitArr) {
  for (let index = 0; index < splitArr.length; index++) {
    var indicator = splitArr[index][0];
    var run = parseInt(splitArr[index].substring(1));
    while (run > 127) {
      finalResult.push(indicator + "1111111");
      run -= 127;
    }
    var binRun = dec2bin(run);
    var correctedRun = new Array(8 - binRun.length).join("0") + binRun;
    finalResult.push(indicator + correctedRun);
  }
  console.log(finalResult);
}

fs.readFile("00001.bmp", (err, data) => {
  arr = [...data];
  arr.map((el) => {
    str += dec2bin(el);
  });
  RLE.encoder(str, (err, res) => {
    if (err) {
      console.log(err);
    } else {
      result = res;
      splittedResult = result.split("/");
      finalFormat(splittedResult);
    }
  });
});
