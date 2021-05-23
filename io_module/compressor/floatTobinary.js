function floatToBinary(x) {
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
var x = "2.5";
var val = floatToBinary(x);
