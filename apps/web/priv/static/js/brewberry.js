"use strict";

function Logger() {
    var self = riot.observable(this);

    function normalizeSample(sample) {
        sample.time = Date.parse(sample.time);
        sample.heater = sample.heater ? 1 : 0;
        return sample;
    }

    var eventSource;

    this.state = function () {
       return eventSource.readyState;
    };

    this.onlineCheck = function () {
        // EventSource watchdog
        // readyState: 0=connecting, 1=open, 2=closed
        if (!eventSource || eventSource.readyState === 2) {
            if (eventSource) { eventSource.close(); }

            eventSource = new EventSource("logger");

            eventSource.addEventListener("sample", function(event) {

                var sample = JSON.parse(event.data);
                if (sample) {
                    normalizeSample(sample);
                    self.trigger("sample", sample);
                }

            }, false);
        }
    };

    setInterval(this.onlineCheck, 1000);

    this.onSample = function (callback) {
        self.on("sample", callback);
    };

    this.onlineCheck();
}

function Controls() {
    var self = this;

    function setHeater(power) {
        $.ajax("/controller", {
                data: JSON.stringify({ "set": power }),
                contentType: "application/json",
                type: "POST"
            });
    }

    this.turnOn = function () {
        setHeater("on");
    };

    this.turnOff = function () {
        setHeater("off");
    };

    this.setTemperature = function (t) {
        $.ajax("/temperature", {
                data: JSON.stringify({ "set": t }),
                contentType: "application/json",
                type: "POST"
            });
    };
}

// Presenter
$(function () {

    var logger = new Logger(),
        controls = new Controls();

    /* Chart */
    var chart = logChart($("#log-chart"));

    addSeries(chart, logger, {
        "name": "Heater",
        "type": "switch",
        "x": "time",
        "y": "heater",
        "color": "#DF5353" });
    addSeries(chart, logger, {
        "name": "Mash temperature",
        "type": "temperature",
        "x": "time",
        "y": "mash_temperature",
        "color": "#DDDF0D" });
    addSeries(chart, logger, {
        "name": "Temperature",
        "type": "temperature",
        "x": "time",
        "y": "temperature",
        "color": "#0000BF" });

    /* Controls */
    var temperatureDisplay = $("#temperature"),
        turnOnButton = $("#turn-on"),
        turnOffButton = $("#turn-off"),
        setTemperatureButton = $("#set-temperature"),
        healthDisplay = $("#health");

    logger.onSample(function (sample) {
        turnOnButton.text(sample.mode);
    });

    logger.onSample(function (sample) {
        temperatureDisplay.text(sample.temperature.toFixed(2));
        healthDisplay.toggleClass("odd").text(new Date().toLocaleTimeString());
    });

    turnOnButton.click(function () {
        controls.turnOn();
        // Check logger, re-initiate if needed.
        logger.onlineCheck();
        turnOnButton.text("...");
    });

    turnOffButton.click(function () {
        controls.turnOff();
        turnOnButton.text("...");
    });

    setTemperatureButton.change(function (event) {
        var temperature = setTemperatureButton.val();
        if (temperature) {
            controls.setTemperature(parseInt(temperature));
        }
        return false;
    });
});

// vim:sw=4:et:ai
