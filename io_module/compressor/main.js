const fs = require("fs");
let arr = [];
let str = ``;
let splittedResult;
let finalResult = [];

function dec2bin(dec) {
  return Number(dec).toString(2);
}

function mergeAndWirte(arr, fileName) {
  if (arr.length % 2 != 0) {
    arr.push("00000000");
  }

  const res = Array.from(
    { length: arr.length / 2 },
    (_, i) => arr[2 * i] + " " + arr[2 * i + 1]
  );
  let text = res.join("\n");
  fs.writeFileSync(fileName, text, "utf8");
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
  mergeAndWirte(finalResult, process.argv[3]);
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
fs.readFile(process.argv[2], (err, data) => {
  arr = [...data];
  arr.map((el) => {
    str += dec2bin(el);
  });

  str = RLE(str);
  splittedResult = str.split("/");
  splittedResult.pop(); //remove space (last element)
  finalFormat(splittedResult);
});
