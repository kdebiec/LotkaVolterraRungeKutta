var pDeletePredator = 0.1
var pNewPrey = 0.7
var pPredatorEnergyEfficiency = 0.7
var pPredatorMurderEfficiency = 0.2

function f(r) {
    var x = r[0]
    var y = r[1]
    var fxd = -pDeletePredator*x +
            pPredatorEnergyEfficiency*pPredatorMurderEfficiency*x*y
    var fyd = pNewPrey*y - pPredatorMurderEfficiency*x*y
    return [fxd, fyd]
}

function rk4(r, h) {
    var r1 = f(r)
    var r2 = f([r[0]+0.5*r1[0], r[1]+0.5*r1[1]])
    var r3 = f([r[0]+0.5*r2[0], r[1]+0.5*r2[1]])
    var r4 = f([r[0]+r3[1], r[1]+r3[1]])
    return [h*(r1[0] + r2[0] + r3[0] + r4[0])/6,
            h*(r1[1] + r2[1] + r3[1] + r4[1])/6]
}

var predatorPercentage = 0.2
var h = 0.01
var day = 0.00
var r
var xpoints = [0]
var ypoints = [0]

function reset() {
    r = [predatorPercentage*5.0, (1-predatorPercentage)*5.0]
}

function nextDay() {
    for(var i = 0; i < 100; i++) {
        var new_r = rk4(r, h)
        r[0] += new_r[0]
        r[1] += new_r[1]
        day+=h
        day = Math.round((day + Number.EPSILON) * 100) / 100
    }
    xpoints.push(r[0])
    ypoints.push(r[1])
}
