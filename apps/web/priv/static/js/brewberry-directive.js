"use strict";

function logChart(element) {
    Highcharts.setOptions({
        // This is for all plots, change Date axis to local timezone
        global : {
            useUTC : false
        }
    });
    return new Highcharts.Chart({
        chart: {
            renderTo: element.get(0),
            type: "area",
            backgroundColor: "transparent",
            animation: Highcharts.svg // don"t animate in old IE
        },

        title: {
            text: ""
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        xAxis: [{
            type: "datetime",
            title: {
                text: "Time"
            }
        }],
        yAxis: [{
            labels: {
                style: {
                    color: "#89A54E"
                }
            },
            title: {
                text: null,
                style: {
                    color: "#89A54E"
                }
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: "#808080"
            }],
            opposite: true
        }, {
            gridLineWidth: 0,
            title: {
                text: "",
                style: {
                    color: "#A74572"
                }
            },
            labels: {
                formatter: function() {
                    return this.value === 0 ? "Off" : (this.value === 1 ? "On" : "");
                },
                style: {
                    color: "#A74572"
                }
            },
            min: 0,
            max: 1
        }],
        tooltip: {
            enabled: false,
            shared: true
        },
        plotOptions: {
            series: {
                stacking: null,
                marker: {
                    enabled: false
                }
            }
        }
    });
}

function addSeries(chart, logger, attrs) {
    var HISTORY_DEPTH = 3600 * 1000; // 1 hours of history
    var series = chart.addSeries({
        name: attrs.name,
        type: attrs.type === "switch" ? "area" : "spline",
        color: attrs.color,
        yAxis: attrs.type === "switch" ? 1 : 0,
        tooltip: {
            enabled: false
        },
        data: []
    });

    function dropOldData(series, ts) {
        while (series.data.length > 0 && series.data[0].x < ts - HISTORY_DEPTH) {
            series.data[0].remove(false);
        }
    }

    var x = attrs.x;
    var y = attrs.y;
    
    logger.on("samples", function (samples) {
        if (samples) {
            for (var i in samples) {
                var e = samples[i];
                series.addPoint([e[x], e[y]], false, false);
            }
            series.update();
        }
    });

    logger.on("sample", function(sample) {
        if (sample) {
            dropOldData(series, sample[x]);
            series.addPoint([sample[x], sample[y]], true, false);
        }
    });
}

// vim:sw=4:et:ai
