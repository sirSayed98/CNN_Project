const fs = require("fs");
let arr = [];
let str = ``;
let splittedResult;
let finalResult = [];
let filter_string = "";
const IMG_CHOICE = 1;
const FILTER_CHOICE = 2;

function dec2bin(dec) {
  return Number(dec).toString(2);
}

function float2bin(x) {
  var correctedFloat = "";
  var intg = "";
  var str = "";
  var finalOut = 0.0;
  var floatPart = 0.0;
  let i = 0;
  var powerSign = "";
  var expon = 0;
  var value = 0;
  var shifted = 0.0;
  var flag = false; // false => positve

  if (x.includes("e")) {
    x = x.split("e");
    powerSign = x[1][0];
    expon = parseInt(x[1].slice(1));
    value = parseFloat(x[0]);

    if (powerSign == "-") {
      shifted = value * Math.pow(10, -expon);
    } else {
      shifted = value * Math.pow(10, expon);
    }
  } else {
    shifted = x;
  }

  flag = shifted > 0 ? false : true;

  str = shifted.toString();
  str = str.split(".");

  // less than 15
  intg = Number(str[0]).toString(2);

  intg = new Array(6 - intg.length).join("0") + intg;

  floatPart = parseFloat("." + str[1]);

  while (i < 11) {
    floatPart = floatPart * 2;
    tmp = parseInt(floatPart);
    correctedFloat += tmp.toString();
    floatPart -= tmp;
    i++;
  }
  finalOut = intg + correctedFloat;

  if (flag) {
    var complement = "";
    for (var j = 0; j < finalOut.length; j++) {
      complement += finalOut[j] === "0" ? "1" : "0";
    }
    result = parseInt(complement, 2) + 1;
    finalOut = result.toString(2);
  }

  return finalOut;
}

function mergeAndWirte(arr, fileName) {
  if (arr.length % 2 != 0) {
    arr.push("00000000");
  }

  const res = Array.from(
    { length: arr.length / 2 },
    (_, i) => arr[2 * i] +  arr[2 * i + 1]
  );
  let text = res.join("\n");
  fs.writeFileSync(fileName, text, "utf8");
}

function finalFormat(splitArr, output) {
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
  mergeAndWirte(finalResult, output);
}

function RLE(binString) {
  let lastLetter, currentCount;
  let output = "";
  lastLetter = binString[0];
  currentCount = 1;
  for (let i = 1; i < binString.length + 1; i++) {
    if (binString[i] !== lastLetter) {
      output += lastLetter + currentCount + "/";
      lastLetter = binString[i];
      currentCount = 1;
    } else currentCount++;
  }
  return output;
}

function readImg(imgPath, output) {
  fs.readFile(imgPath, (err, data) => {
    arr = [...data];
    arr.map((el) => {
      str += dec2bin(el);
    });

    str = RLE(str);
    splittedResult = str.split("/");
    splittedResult.pop(); //remove space (last element)
    finalFormat(splittedResult, output);
  });
}

function readFilters(argArr,output) {
  [1, 2, 3].forEach((el) => {
    argArr.shift();
  });

  var compine_filters = [];

  argArr.forEach((file) => {
    var text = fs
      .readFileSync(file)
      .toString("utf-8")
      .replace(/\r?\n|\r/g, " ");

    text = text.split(" ");
    compine_filters = compine_filters.concat(text);
  });
  compine_filters = compine_filters.filter(function (e) {
    return e !== "";
  });

  compine_filters.map((el) => {
    filter_string += float2bin(el);
  });
  filter_string = RLE(filter_string);

  splittedResult = filter_string.split("/");
  splittedResult.pop(); //remove space (last element)
  finalFormat(splittedResult, output);
}
switch (parseInt(process.argv[2])) {
  case IMG_CHOICE:
    readImg(process.argv[3], process.argv[4]);
    break;
  case FILTER_CHOICE:
    var out = process.argv.pop();
    readFilters(process.argv, out);
    break;
  default:
    break;
}
